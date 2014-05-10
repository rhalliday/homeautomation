package Test::HomeAutomation::Controller::Appliances;

use strict;
use warnings;

use Test::Class::Moose extends => 'Test::HomeAutomation::Controller';
use Readonly;

Readonly::Scalar my $FIRST_FREE    => 3;
Readonly::Scalar my $TOTAL_DEVICES => 16;

our $VERSION = '1.00';

sub test_basic_user {
    my ($self) = @_;

    $self->login(q{test03});
    my $ua = $self->{ua};
    $ua->get_ok(q{http://localhost/}, q{Check index page});
    $ua->content_contains(q{HomeAutomation}, q{index page shows some stuff});
    $ua->get(q{/appliances/list});
    $ua->title_is(q{Appliance List}, q{Check redirect to appliance list after log in});
    $ua->content_lacks(q{/schedules/list">Schedules</a>},  q{'test03' should NOT be able to see the schedules});
    $ua->content_lacks(q{/usermanagement/list">Users</a>}, q{'test03' should NOT be able to see the other users});
    $ua->content_contains(q{/usermanagement/change_password">Change Password</a>},
        q{'test03' should be able to change their password});
    $ua->content_contains(q{/logout">Logout</a>}, q{'test03' should be able to logout});
    $ua->content_contains(q{<td><span class="device-icon" style="background:#FFFFFF"></span>T.V.</td>},       q{'test03' can see the T.V appliance});
    $ua->content_like(qr{class="btn btn-sm btn-success"\s*>\s*StartUp\s*</a>}, q{can see the switch for the T.V.});
    $ua->content_lacks(q{<td>F1</td>}, q{shouldn't be able to see the address});
    $ua->content_unlike(qr{class="btn btn-sm btn-danger"\s*>\s*Delete\s*</a>},
        q{shouldn't be able to delete appliances});
    $ua->content_unlike(qr{class="btn btn-sm btn-info"\s*>\s*Edit\s*</a>}, q{shouldn't be able to edit appliances});
    $ua->content_unlike(qr{class="btn btn-sm btn-primary"\s*>\s*Schedule\s*</a>},
        q{shouldn't be able to schedule anything});
    $ua->content_lacks(q{/appliances/create" class="btn btn-primary">Create</a>},
        q{shouldn't be able to create devices});

    # user switch
    my @switch_links = $ua->find_all_links(text => 'StartUp');
    $ua->get_ok($switch_links[0]->url, q{can click the switch 'button'});
    $ua->content_like(qr{class="btn btn-sm btn-danger"\s*>\s*ShutDown\s*</a>}, q{T.V. switch is now set to off});
    @switch_links = $ua->find_all_links(text => 'ShutDown');
    $ua->get_ok($switch_links[0]->url, q{can click the switch 'button' again});
    $ua->content_like(qr{class="btn btn-sm btn-success"\s*>\s*StartUp\s*</a>}, q{T.V. switch is now set to on});

    # room with another device
    $ua->get_ok(q{/appliances/list?room=Imogen}, q{can go to another room});
    $ua->content_contains(q{<td><span class="device-icon" style="background:#000000"></span>Lights</td>}, q{Imogen's room has a lights device});

    # room with no device
    $ua->get_ok(q{/appliances/list?room=Master}, q{can get to the master room});
    $ua->content_contains(q{<p>No devices in this room</p>}, q{master room has no devices});

    return 1;
}

sub test_privileged_user {
    my ($self) = @_;

    $self->login(q{test02});

    my $ua = $self->{ua};
    $ua->get(q{/appliances/list});
    $ua->title_is(q{Appliance List}, q{Check redirect to appliance list after log in});
    $ua->content_contains(q{/schedules/list">Schedules</a>},  q{'test02' should be able to see the schedules});
    $ua->content_contains(q{/usermanagement/list">Users</a>}, q{'test02' should be able to see the other users});
    $ua->content_contains(q{/usermanagement/change_password">Change Password</a>},
        q{'test02' should be able to change their password});
    $ua->content_contains(q{/logout">Logout</a>}, q{'test02' should be able to logout});
    $ua->content_contains(q{<td><span class="device-icon" style="background:#FFFFFF"></span>T.V.</td>},       q{'test02' can see the T.V appliance});
    $ua->content_like(qr{class="btn btn-sm btn-success"\s*>\s*StartUp\s*</a>}, q{can see the switch for the T.V.});
    $ua->content_lacks(q{<td>F1</td>}, q{shouldn't be able to see the address});
    $ua->content_unlike(qr{class="btn btn-sm btn-danger"\s*>\s*Delete\s*</a>},
        q{shouldn't be able to delete appliances});
    $ua->content_unlike(qr{class="btn btn-sm btn-info"\s*>\s*Edit\s*</a>}, q{shouldn't be able to edit appliances});
    $ua->content_like(qr{class="btn btn-sm btn-primary"\s*>\s*Schedule\s*</a>},
        q{should be able to schedule appliances});
    $ua->content_lacks(q{/appliances/create" class="btn btn-primary">Create</a>},
        q{shouldn't be able to create devices});

    # user switch
    my @switch_links = $ua->find_all_links(text => 'StartUp');
    $ua->get_ok($switch_links[0]->url, q{can click the switch 'button'});
    $ua->content_like(qr{class="btn btn-sm btn-danger"\s*>\s*ShutDown\s*</a>}, q{T.V. switch is now set to off});
    @switch_links = $ua->find_all_links(text => 'ShutDown');
    $ua->get_ok($switch_links[0]->url, q{can click the switch 'button' again});
    $ua->content_like(qr{class="btn btn-sm btn-success"\s*>\s*StartUp\s*</a>}, q{T.V. switch is now set to on});

    # room with another device
    $ua->get_ok(q{/appliances/list?room=Imogen}, q{can go to another room});
    $ua->content_contains(q{<td><span class="device-icon" style="background:#000000"></span>Lights</td>}, q{Imogen's room has a lights device});

    # room with no device
    $ua->get_ok(q{/appliances/list?room=Master}, q{can get to the master room});
    $ua->content_contains(q{<p>No devices in this room</p>}, q{master room has no devices});

    $ua->get(q{/appliances/address/F1/delete});
    $ua->content_contains(q{Permission Denied}, q{test02 gets permission denied if they try to delete});

    return 1;
}

sub test_admin_user {
    my ($self) = @_;

    $self->login(q{test01});

    my $ua = $self->{ua};
    $ua->get(q{/appliances/list});

    $ua->title_is(q{Appliance List}, q{Check redirect to appliance list after log in});
    $ua->content_contains(q{/schedules/list">Schedules</a>},  q{'test01' should be able to see the schedules});
    $ua->content_contains(q{/usermanagement/list">Users</a>}, q{'test01' should be able to see the other users});
    $ua->content_contains(q{/usermanagement/change_password">Change Password</a>},
        q{'test01' should be able to change their password});
    $ua->content_contains(q{/logout">Logout</a>}, q{'test01' should be able to logout});
    $ua->content_contains(q{<td><span class="device-icon" style="background:#FFFFFF"></span>T.V.</td>},       q{'test01' can see the T.V appliance});
    $ua->content_like(qr{class="btn btn-sm btn-success"\s*>\s*StartUp\s*</a>}, q{can see the switch for the T.V.});
    $ua->content_contains(q{<td>F1</td>}, q{should be able to see the address});
    $ua->content_like(qr{class="btn btn-sm btn-danger"\s*>\s*Delete\s*</a>}, q{should be able to delete appliances});
    $ua->content_like(qr{class="btn btn-sm btn-info"\s*>\s*Edit\s*</a>},     q{should be able to edit appliances});
    $ua->content_like(qr{class="btn btn-sm btn-primary"\s*>\s*Schedule\s*</a>},
        q{should be able to schedule appliances});
    $ua->content_contains(q{/appliances/create" class="btn btn-primary">Create</a>},
        q{should be able to create devices});

    # user switch
    my @switch_links = $ua->find_all_links(text => 'StartUp');
    $ua->get_ok($switch_links[0]->url, q{can click the switch 'button'});
    $ua->content_like(qr{class="btn btn-sm btn-danger"\s*>\s*ShutDown\s*</a>}, q{T.V. switch is now set to off});
    @switch_links = $ua->find_all_links(text => 'ShutDown');
    $ua->get_ok($switch_links[0]->url, q{can click the switch 'button' again});
    $ua->content_like(qr{class="btn btn-sm btn-success"\s*>\s*StartUp\s*</a>}, q{T.V. switch is now set to on});

    # room with another device
    $ua->get_ok(q{/appliances/list?room=Imogen}, q{can go to another room});
    $ua->content_contains(q{<td><span class="device-icon" style="background:#000000"></span>Lights</td>}, q{Imogen's room has a lights device});

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
                colour   => '#000001',
            }
        },
        q{can submit the form create}
    );
    $ua->title_is(q{Appliance List}, q{get redirected to the appliance list});
    $ua->content_contains(q{<td><span class="device-icon" style="background:#000001"></span>Lights</td>}, q{new device is listed});
    $ua->content_contains(q{<td>F3</td>},     q{new device is listed at address F3});

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
    $ua->content_contains(q{<td><span class="device-icon" style="background:#000001"></span>Lighters</td>}, q{device name has changed});

    $ua->get_ok(q{/appliances/address/F3/delete}, q{can delete our new device});
    $ua->content_lacks(q{<td>F3</td>}, q{our new device no longer exists});

    $ua->get(q{/appliances/address/F30/edit});
    $ua->content_contains(q{Page not found}, q{page not found is returned for an unknown device});

    # fill up all the devices
    for my $address ($FIRST_FREE .. $TOTAL_DEVICES) {
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
    for my $address ($FIRST_FREE .. $TOTAL_DEVICES) {
        $ua->get(qq{/appliances/address/F${address}/delete});
    }

    return 1;
}

1;

__END__

=head1 NAME

Test::HomeAutomation::Controller::Appliances

=head2 DESCRIPTION

Test class for all the appliance tests.

=cut
