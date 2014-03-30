package Test::HomeAutomation::Controller;

use Test::Class::Moose extends => q{Test::HomeAutomation};

use HomeAutomation::Schema;
use Test::WWW::Mechanize::Catalyst q{HomeAutomation};

sub test_startup {
    my ($self) = @_;

    # create some users and appliances
    my $connect_info = {
        dsn           => $ENV{HA_DSN},
        user          => q{},
        password      => q{},
        on_connect_do => q{PRAGMA foreign_keys = ON},
    };
    $self->{schema} = HomeAutomation::Schema->connect($connect_info);

    # we'll use this resultset to apply roles to our users
    my $role_rs = $self->{schema}->resultset(q{Role});

    # create a few users
    $self->{schema}->resultset(q{User})->populate(
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

    # create a couple of appliances
    my $first_appliance = $self->{schema}->resultset(q{Appliance})->next_appliance;

    # give the appliance some details
    $first_appliance->update(
        {
            device => 'Light',
            room_id => 1,
            protocol => 'pl',
            status   => 1,
        }
    );

    my $next_appliance = $self->{schema}->resultset(q{Appliance})->next_appliance;

    # give the appliance some details
    $next_appliance->update(
        {
            device => 'Light',
            room_id => 7,
            protocol => 'pl',
            status   => 1,
        }
    );
    return 1;
}

sub test_shutdown {
    my ($self) = @_;
    # remove the stuff we added to the database
    $self->{schema}->resultset(q{User})->delete_all();
    for my $appliance ($self->{schema}->resultset(q{Appliance})->all) {
        $appliance->clear;
    }

    # this would probably happen on end of scope, but
    $self->{schema}->storage->disconnect();
}

1;

__END__

=head1 NAME

Test::HomeAutomation::Controller

=head2 DESCRIPTION

Base class for the controller tests.

=cut
