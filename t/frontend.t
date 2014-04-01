#!perl

BEGIN {
    system(q{for file in script/sql/*.sql; do echo ${file}; sqlite3 frontend.db < ${file}; done;}) == 0 || die q{Can't create database};
    $ENV{HA_DSN} = 'dbi:SQLite:frontend.db'; # point at our new db
    $ENV{CATALYST_DEBUG} = 0; # turn off debug messages for cleaner output
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
                user_roles    => [ map { { role_id => $_->id } } $role_rs->search({ role => [q{schedule}, q{usermanagement}, q{user}] })->all ],
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

subtest q{basic_user} => sub {
    my $ua = Test::WWW::Mechanize::Catalyst->new;
    $ua->get_ok(q{http://localhost/}, q{Check redirect of base URL});
    $ua->title_is(q{Login}, q{Check for login title});
    $ua->submit_form(
        fields => {
            username => 'test03',
            password => 'mypass',
        }
    );
    $ua->title_is(q{Appliance List}, q{Check redirect to appliance list after log in});
    $ua->content_lacks(q{/schedules/list">Schedules</a>}, q{'test03' should NOT be able to see the schedules});
    $ua->content_lacks(q{/usermanagement/list">Users</a>}, q{'test03' should NOT be able to see the other users});
    $ua->content_contains(q{/usermanagement/change_password">Change Password</a>}, q{'test03' should be able to change their password});
    $ua->content_contains(q{/logout">Logout</a>}, q{'test03' should be able to logout});
    $ua->content_contains(q{<td>T.V.</td>}, q{'test03' can see the T.V appliance});
    $ua->content_like(qr{class="btn btn-sm btn-success"\s*>\s*On\s*</button>}, q{can see the switch for the T.V.});
    $ua->content_lacks(q{<td>F1</td>}, q{shouldn't be able to see the address});
    $ua->content_unlike(qr{class="btn btn-sm btn-danger"\s*>\s*Delete\s*</a>}, q{shouldn't be able to delete appliances});
    $ua->content_unlike(qr{class="btn btn-sm btn-info"\s*>\s*Edit\s*</a>}, q{shouldn't be able to edit appliances});
    $ua->content_unlike(qr{class="btn btn-sm btn-primary"\s*>\s*Schedule\s*</a>}, q{shouldn't be able to schedule anything});
    $ua->content_lacks(q{/appliances/create" class="btn btn-primary">Create</a>}, q{shouldn't be able to create devices});

    return 1;
};

done_testing();

