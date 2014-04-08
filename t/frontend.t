#!perl

BEGIN {
    system(q{for file in script/sql/*.sql; do echo ${file}; sqlite3 frontend.db < ${file}; done;}) == 0
      || die q{Can't create database};
    $ENV{HA_DSN}         = 'dbi:SQLite:frontend.db';    # point at our new db
    $ENV{CATALYST_DEBUG} = 0;                           # turn off debug messages for cleaner output
                                                        # create some users and appliances
    my $connect_info = {
        dsn           => $ENV{HA_DSN},
        user          => q{},
        password      => q{},
        on_connect_do => q{PRAGMA foreign_keys = ON},
    };
    use HomeAutomation::Schema;
    $schema = HomeAutomation::Schema->connect($connect_info);

    # we'll use this resultset to apply roles to our users
    my $role_rs = $schema->resultset(q{Role});

    # create a few users
    $schema->resultset(q{User})->populate(
        [
            {
                username      => q{test01},
                password      => q{mypass},
                email_address => q{test01@example.com},
                first_name    => q{test01},
                last_name     => q{major},
                active        => 1,
                user_roles    => [ map { { role_id => $_->id } } $role_rs->all ],
            },
            {
                username      => q{test02},
                password      => q{mypass},
                email_address => q{test02@example.com},
                first_name    => q{test02},
                last_name     => q{Hague},
                active        => 1,
                user_roles    => [
                    map { { role_id => $_->id } }
                      $role_rs->search({ role => [ q{schedule}, q{usermanagement}, q{user} ] })->all
                ],
            },
            {
                username      => q{test03},
                password      => q{mypass},
                email_address => q{test03@example.com},
                first_name    => q{test03},
                last_name     => q{Cameron},
                active        => 1,
                user_roles    => [ map { { role_id => $_->id } } $role_rs->search({ role => [q{user}] })->all ],
            },
        ]
    );

    # create some appliances
    my $first_appliance = $schema->resultset(q{Appliance})->next_appliance();
    $first_appliance->update({ device => 'T.V.', room_id => 7, protocol => q{pl}, status => 1 });

    my $second_appliance = $schema->resultset(q{Appliance})->next_appliance();
    $second_appliance->update({ device => 'Lights', room_id => 1, protocol => q{pl}, status => 1 });

    $schema->storage->disconnect;
}

END {
    unlink q{frontend.db};
}

use Test::More;
use Test::WWW::Mechanize::Catalyst q{HomeAutomation};

subtest q{bad logins} => sub {
    my $ua = Test::WWW::Mechanize::Catalyst->new;

    $ua->get_ok(q{http://localhost/}, q{Check redirect of base URL});
    $ua->title_is(q{Login}, q{Check for login title});
    $ua->submit_form(
        fields => {
            username => q{},
            password => q{},
        }
    );
    $ua->content_contains(q{Empty username or password.}, q{empty username and password gets the right error});

    $ua->submit_form(
        fields => {
            username => q{test01},
            password => q{},
        }
    );
    $ua->content_contains(q{Empty username or password.}, q{empty password gets the right error});

    $ua->submit_form(
        fields => {
            username => q{},
            password => q{mypass},
        }
    );
    $ua->content_contains(q{Empty username or password.}, q{empty username gets the right error});

    $ua->submit_form(
        fields => {
            username => q{test04},
            password => q{mypass},
        }
    );
    $ua->content_contains(q{Bad username or password.}, q{can't login with a user who doesn't exist});

    $ua->submit_form(
        fields => {
            username => q{test03},
            password => q{notmypass},
        }
    );
    $ua->content_contains(q{Bad username or password.}, q{can't login with a bad password});

    # login properly
    $ua->submit_form(
        fields => {
            username => q{test03},
            password => q{mypass},
        }
    );
    # navigate back to the login page and submit an empty form, we should still be redirected
    $ua->get_ok(q{/login}, q{get the login page});
    $ua->submit_form(
        fields => {
            username => q{},
            password => q{},
        }
    );
    $ua->content_lacks(q{Empty username or password.}, q{empty username and password gets no error, as we're already logged in});

    $ua = undef;
    return 1;
};

subtest q{basic_user} => sub {
    my $ua = Test::WWW::Mechanize::Catalyst->new;

    # Login
    $ua->get_ok(q{http://localhost/}, q{Check redirect of base URL});
    $ua->title_is(q{Login}, q{Check for login title});
    $ua->submit_form(
        fields => {
            username => q{test03},
            password => q{mypass},
        }
    );
    $ua->title_is(q{Appliance List}, q{Check redirect to appliance list after log in});
    $ua->get_ok(q{http://localhost/}, q{Check index page});
    $ua->content_contains(q{HomeAutomation}, q{index page shows some stuff});

    subtest q{appliance list} => sub {
        # appliance list page contents
        $ua->get(q{/appliances/list});
        $ua->content_lacks(q{/schedules/list">Schedules</a>},  q{'test03' should NOT be able to see the schedules});
        $ua->content_lacks(q{/usermanagement/list">Users</a>}, q{'test03' should NOT be able to see the other users});
        $ua->content_contains(q{/usermanagement/change_password">Change Password</a>},
            q{'test03' should be able to change their password});
        $ua->content_contains(q{/logout">Logout</a>}, q{'test03' should be able to logout});
        $ua->content_contains(q{<td>T.V.</td>},       q{'test03' can see the T.V appliance});
        $ua->content_like(qr{class="btn btn-sm btn-success"\s*>\s*On\s*</a>}, q{can see the switch for the T.V.});
        $ua->content_lacks(q{<td>F1</td>}, q{shouldn't be able to see the address});
        $ua->content_unlike(qr{class="btn btn-sm btn-danger"\s*>\s*Delete\s*</a>},
            q{shouldn't be able to delete appliances});
        $ua->content_unlike(qr{class="btn btn-sm btn-info"\s*>\s*Edit\s*</a>}, q{shouldn't be able to edit appliances});
        $ua->content_unlike(qr{class="btn btn-sm btn-primary"\s*>\s*Schedule\s*</a>},
            q{shouldn't be able to schedule anything});
        $ua->content_lacks(q{/appliances/create" class="btn btn-primary">Create</a>},
            q{shouldn't be able to create devices});

        # user switch
        my @switch_links = $ua->find_all_links(text => 'On');
        $ua->get_ok($switch_links[0]->url, q{can click the switch 'button'});
        $ua->content_like(qr{class="btn btn-sm btn-danger"\s*>\s*Off\s*</a>}, q{T.V. switch is now set to off});
        @switch_links = $ua->find_all_links(text => 'Off');
        $ua->get_ok($switch_links[0]->url, q{can click the switch 'button' again});
        $ua->content_like(qr{class="btn btn-sm btn-success"\s*>\s*On\s*</a>}, q{T.V. switch is now set to on});

        # room with another device
        $ua->get_ok(q{/appliances/list?room=Imogen}, q{can go to another room});
        $ua->content_contains(q{<td>Lights</td>}, q{Imogen's room has a lights device});

        # room with no device
        $ua->get_ok(q{/appliances/list?room=Master}, q{can get to the master room});
        $ua->content_contains(q{<p>No devices in this room</p>}, q{master room has no devices});
    };

    subtest q{change password} => sub {
        $ua->follow_link_ok({ text => q{Change Password} }, q{can get to the change password form});
        $ua->title_is(q{Change Password}, q{check we are actually on the change password page});
        $ua->submit_form(
            fields => {
                current_password  => q{mypass},
                new_password      => q{newpass},
                new_password_conf => q{newpass},
            }
        );
        $ua->get(q{/logout});
        $ua->submit_form(
            fields => {
                username => q{test03},
                password => q{newpass},
            }
        );
        $ua->title_is(q{Appliance List}, q{can change password});
        $ua->follow_link_ok({ text => q{Change Password} }, q{can get to the change password form});
        $ua->submit_form(
            fields => {
                current_password  => q{mypass},
                new_password      => q{newpass},
                new_password_conf => q{newpass},
            }
        );
        $ua->content_contains(q{incorrect password}, q{using old password says they're incorrect});
        $ua->submit_form(
            fields => {
                current_password  => q{newpass},
                new_password      => q{mypass},
                new_password_conf => q{newpass},
            }
        );
        $ua->content_contains(q{The password confirmation does not match the password}, q{password mismatch});
        $ua->submit_form(
            fields => {
                current_password  => q{newpass},
                new_password      => q{mypass},
                new_password_conf => q{mypass},
            }
        );
        $ua->content_contains(q{Password Changed}, q{password changed successfully});
    };

    subtest q{user management} => sub {
        $ua->get(q{/usermanagement/id/2/deactivate});
        $ua->content_contains(q{Permission Denied}, q{test01 gets permission denied if they try to deactivate a user});
    };

    # log out
    $ua->follow_link_ok({ url_regex => qr/logout/ }, q{can log out again});

    $ua = undef;
    return 1;
};

subtest q{privileged_user} => sub {
    my $ua = Test::WWW::Mechanize::Catalyst->new;

    # Login
    $ua->get_ok(q{http://localhost/}, q{Check redirect of base URL});
    $ua->title_is(q{Login}, q{Check for login title});
    $ua->submit_form(
        fields => {
            username => q{test02},
            password => q{mypass},
        }
    );

    subtest q{appliance list} => sub {
        # appliance list page contents
        $ua->title_is(q{Appliance List}, q{Check redirect to appliance list after log in});
        $ua->content_contains(q{/schedules/list">Schedules</a>},  q{'test02' should be able to see the schedules});
        $ua->content_contains(q{/usermanagement/list">Users</a>}, q{'test02' should be able to see the other users});
        $ua->content_contains(q{/usermanagement/change_password">Change Password</a>},
            q{'test02' should be able to change their password});
        $ua->content_contains(q{/logout">Logout</a>}, q{'test02' should be able to logout});
        $ua->content_contains(q{<td>T.V.</td>},       q{'test02' can see the T.V appliance});
        $ua->content_like(qr{class="btn btn-sm btn-success"\s*>\s*On\s*</a>}, q{can see the switch for the T.V.});
        $ua->content_lacks(q{<td>F1</td>}, q{shouldn't be able to see the address});
        $ua->content_unlike(qr{class="btn btn-sm btn-danger"\s*>\s*Delete\s*</a>},
            q{shouldn't be able to delete appliances});
        $ua->content_unlike(qr{class="btn btn-sm btn-info"\s*>\s*Edit\s*</a>}, q{shouldn't be able to edit appliances});
        $ua->content_like(qr{class="btn btn-sm btn-primary"\s*>\s*Schedule\s*</a>},
            q{should be able to schedule appliances});
        $ua->content_lacks(q{/appliances/create" class="btn btn-primary">Create</a>},
            q{shouldn't be able to create devices});

        # user switch
        my @switch_links = $ua->find_all_links(text => 'On');
        $ua->get_ok($switch_links[0]->url, q{can click the switch 'button'});
        $ua->content_like(qr{class="btn btn-sm btn-danger"\s*>\s*Off\s*</a>}, q{T.V. switch is now set to off});
        @switch_links = $ua->find_all_links(text => 'Off');
        $ua->get_ok($switch_links[0]->url, q{can click the switch 'button' again});
        $ua->content_like(qr{class="btn btn-sm btn-success"\s*>\s*On\s*</a>}, q{T.V. switch is now set to on});

        # room with another device
        $ua->get_ok(q{/appliances/list?room=Imogen}, q{can go to another room});
        $ua->content_contains(q{<td>Lights</td>}, q{Imogen's room has a lights device});

        # room with no device
        $ua->get_ok(q{/appliances/list?room=Master}, q{can get to the master room});
        $ua->content_contains(q{<p>No devices in this room</p>}, q{master room has no devices});

        $ua->get(q{/appliances/address/F1/delete});
        $ua->content_contains(q{Permission Denied}, q{test02 gets permission denied if they try to delete});
    };

    subtest q{change password} => sub {
        $ua->get(q{/appliances/list});
        $ua->follow_link_ok({ text => q{Change Password} }, q{can get to the change password form});
        $ua->title_is(q{Change Password}, q{check we are actually on the change password page});
        # note can't actually check that the form works, see the tests for the change password form for that
    };

    # test user management, should only be able to make them active/inactive
    subtest q{user management} => sub {
        $ua->get(q{/appliances/list});
        $ua->follow_link_ok({ text => q{Users} }, q{can get to the user management page});
        $ua->title_is(q{User List}, q{check we are on the user management page});
        $ua->content_contains(q{test02}, q{we should be able to see ourselves});
        $ua->content_contains(q{test03}, q{we should be able to see another user});
        $ua->content_lacks(q{test01}, q{we should not be able to see admin users});
        $ua->content_lacks(q{Delete}, q{we aren't allowed to delete anybody});
        $ua->content_lacks(q{Edit}, q{we aren't allowed to edit anybody});
        my @switch_links = $ua->find_all_links(text => 'Active');
        $ua->get_ok($switch_links[0]->url, q{can deactivate a user});
        $ua->content_contains(q{Inactive}, q{user is now inactive});
        @switch_links = $ua->find_all_links(text => 'Inactive');
        $ua->get_ok($switch_links[0]->url, q{can reactivate a user});
        $ua->content_lacks(q{Inactive}, q{all users are now active});
        $ua->get_ok(q{/usermanagement}, q{can get usermanagement base url});
        $ua->title_is(q{User List}, q{base url redirects to user list});
    };

    # test schedule, should be able to schedule a device
    subtest q{schedule} => sub {
        # make sure we are on the appliance page
        $ua->get_ok(q{/appliances/list}, q{can go back to the appliance page});
        $ua->title_is(q{Appliance List}, q{make sure we're on the appliance page});
        $ua->follow_link_ok({ text => q{Schedule} }, q{can get to the schedule page});
        $ua->title_is(q{Create/Update Schedule}, q{check we are on the right page});
        # actual scheduling is done through the form
    };

    # log out
    $ua->follow_link_ok({ url_regex => qr/logout/ }, q{can log out again});

    $ua = undef;
    return 1;
};

subtest q{admin_user} => sub {
    my $ua = Test::WWW::Mechanize::Catalyst->new;

    # Login
    $ua->get_ok(q{http://localhost/}, q{Check redirect of base URL});
    $ua->title_is(q{Login}, q{Check for login title});
    $ua->submit_form(
        fields => {
            username => q{test01},
            password => q{mypass},
        }
    );

    subtest q{appliance list} => sub {
        # appliance list page contents
        $ua->title_is(q{Appliance List}, q{Check redirect to appliance list after log in});
        $ua->content_contains(q{/schedules/list">Schedules</a>},  q{'test01' should be able to see the schedules});
        $ua->content_contains(q{/usermanagement/list">Users</a>}, q{'test01' should be able to see the other users});
        $ua->content_contains(q{/usermanagement/change_password">Change Password</a>},
            q{'test01' should be able to change their password});
        $ua->content_contains(q{/logout">Logout</a>}, q{'test01' should be able to logout});
        $ua->content_contains(q{<td>T.V.</td>},       q{'test01' can see the T.V appliance});
        $ua->content_like(qr{class="btn btn-sm btn-success"\s*>\s*On\s*</a>}, q{can see the switch for the T.V.});
        $ua->content_contains(q{<td>F1</td>}, q{should be able to see the address});
        $ua->content_like(qr{class="btn btn-sm btn-danger"\s*>\s*Delete\s*</a>},
            q{should be able to delete appliances});
        $ua->content_like(qr{class="btn btn-sm btn-info"\s*>\s*Edit\s*</a>}, q{should be able to edit appliances});
        $ua->content_like(qr{class="btn btn-sm btn-primary"\s*>\s*Schedule\s*</a>},
            q{should be able to schedule appliances});
        $ua->content_contains(q{/appliances/create" class="btn btn-primary">Create</a>},
            q{should be able to create devices});

        # user switch
        my @switch_links = $ua->find_all_links(text => 'On');
        $ua->get_ok($switch_links[0]->url, q{can click the switch 'button'});
        $ua->content_like(qr{class="btn btn-sm btn-danger"\s*>\s*Off\s*</a>}, q{T.V. switch is now set to off});
        @switch_links = $ua->find_all_links(text => 'Off');
        $ua->get_ok($switch_links[0]->url, q{can click the switch 'button' again});
        $ua->content_like(qr{class="btn btn-sm btn-success"\s*>\s*On\s*</a>}, q{T.V. switch is now set to on});

        # room with another device
        $ua->get_ok(q{/appliances/list?room=Imogen}, q{can go to another room});
        $ua->content_contains(q{<td>Lights</td>}, q{Imogen's room has a lights device});

        # room with no device
        $ua->get_ok(q{/appliances/list?room=Master}, q{can get to the master room});
        $ua->content_contains(q{<p>No devices in this room</p>}, q{master room has no devices});

        # index page
        $ua->get_ok(q{/appliances}, q{index redirects to list});
        $ua->title_is(q{Appliance List}, q{check the title is correct});

        # create appliance
        $ua->get_ok(q{/appliances/create}, q{can create an appliance});
        $ua->title_is(q{Create/Update Appliance}, q{check we are on the create page});
        $ua->submit_form_ok(
            {
                fields => {
                    device   => 'Lights',
                    room     => 7,
                    status   => 1,
                    protocol => 'pl',
                }
            },
            q{can submit the form create}
        );
        $ua->title_is(q{Appliance List}, q{get redirected to the appliance list});
        $ua->content_contains(q{<td>Lights</td>}, q{new device is listed});
        $ua->content_contains(q{<td>F3</td>}, q{new device is listed at address F3});

        $ua->get_ok(q{/appliances/address/F3/edit}, q{can get to the edit page for the new appliance});
        $ua->submit_form_ok(
            {
                fields => {
                    device   => 'Lighters',
                    room     => 7,
                    status   => 1,
                    protocol => 'pl',
                }
            },
            q{can submit the edit form}
        );
        $ua->title_is(q{Appliance List}, q{get redirected to the appliance list after edit});
        $ua->content_contains(q{<td>Lighters</td>}, q{device name has changed});

        $ua->get_ok(q{/appliances/address/F3/delete}, q{can delete our new device});
        $ua->content_lacks(q{<td>F3</td>}, q{our new device no longer exists});

        $ua->get(q{/appliances/address/F30/edit});
        $ua->content_contains(q{Page not found}, q{page not found is returned for an unknown device});

        # fill up all the devices
        for my $address (3..16) {
            $ua->get(qq{/appliances/address/F${address}/edit});
            $ua->submit_form(
                fields => {
                    device   => 'blah',
                    room     => 7,
                    status   => 1,
                    protocol => 'pl',
                }
            );
        }
        # check a redirect for no more devices
        $ua->get(q{/appliances/create});
        #TODO: need to change what happens when we run out
        $ua->content_contains(q{Page not found}, q{page not found is returned when we run out of devices});
        # clear the devices
        for my $address (3..16) {
            $ua->get(qq{/appliances/address/F${address}/delete});
        }
    };

    subtest q{change password} => sub {
        $ua->get(q{/appliances});
        $ua->follow_link_ok({ text => q{Change Password} }, q{can get to the change password form});
        $ua->title_is(q{Change Password}, q{check we are actually on the change password page});
        # note can't actually check that the form works, see the tests for the change password form for that
    };

    # test user management, should only be able to make them active/inactive
    subtest q{user management} => sub {
        $ua->follow_link_ok({ text => q{Users} }, q{can get to the user management page});
        $ua->title_is(q{User List}, q{check we are on the user management page});
        $ua->content_contains(q{test02}, q{we should be able to see ourselves});
        $ua->content_contains(q{test03}, q{we should be able to see another user});
        $ua->content_contains(q{test01}, q{we should be able to see admin users});
        $ua->content_contains(q{Delete}, q{we are allowed to delete anybody});
        $ua->content_contains(q{Edit}, q{we are allowed to edit anybody});
        my @switch_links = $ua->find_all_links(text => 'Active');
        $ua->get_ok($switch_links[0]->url, q{can deactivate a user});
        $ua->content_contains(q{Inactive}, q{user is now inactive});
        @switch_links = $ua->find_all_links(text => 'Inactive');
        $ua->get_ok($switch_links[0]->url, q{can reactivate a user});
        $ua->content_lacks(q{Inactive}, q{all users are now active});
    };

    # test schedule, should be able to schedule a device
    subtest q{schedule} => sub {
        # make sure we are on the appliance page
        $ua->get_ok(q{/appliances/list}, q{can go back to the appliance page});
        $ua->title_is(q{Appliance List}, q{make sure we're on the appliance page});
        $ua->follow_link_ok({ text => q{Schedule} }, q{can get to the schedule page});
        $ua->title_is(q{Create/Update Schedule}, q{check we are on the right page});
        # actual scheduling is done through the form
    };

    # log out
    $ua->follow_link_ok({ url_regex => qr/logout/ }, q{can log out again});

    $ua = undef;
    return 1;
};

done_testing();
