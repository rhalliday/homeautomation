package Test::HomeAutomation::Controller;

use strict;
use warnings;

use Test::Class::Moose extends => q{Test::HomeAutomation};
use Test::WWW::Mechanize::Catalyst q{HomeAutomation};

our $VERSION = '1.00';

sub test_startup {
    my ($self) = @_;

    $self->next::method();

    my $schema = $self->{schema};

    # we'll use this resultset to apply roles to our users
    my $role_rs = $schema->resultset(q{Role});

    # create a few users
    $schema->resultset(q{User})->create(
        {
            username      => q{test01},
            password      => q{mypass},
            email_address => q{test01@example.com},
            first_name    => q{test01},
            last_name     => q{major},
            active        => 1,
            user_roles    => [ map { { role_id => $_->id } } $role_rs->all ],
        },
    );
    $schema->resultset(q{User})->create(
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
    );
    $schema->resultset(q{User})->create(
        {
            username      => q{test03},
            password      => q{mypass},
            email_address => q{test03@example.com},
            first_name    => q{test03},
            last_name     => q{Cameron},
            active        => 1,
            user_roles    => [ map { { role_id => $_->id } } $role_rs->search({ role => [q{user}] })->all ],
        },
    );

    # create some appliances
    my $first_appliance = $schema->resultset(q{Appliance})->next_appliance();
    $first_appliance->update(
        {
            device          => 'T.V.',
            room_id         => 7,
            protocol        => q{pl},
            status          => 1,
            colour          => '#FFFFFF',
            on_button_text  => 'StartUp',
            off_button_text => 'ShutDown'
        }
    );

    my $second_appliance = $schema->resultset(q{Appliance})->next_appliance();
    $second_appliance->update(
        {
            device   => 'Lights',
            room_id  => 1,
            protocol => q{pl},
            status   => 1,
            colour   => '#000000',
            dimable  => 1,
            setting  => 1
        }
    );

    $self->{appliances} = [ $first_appliance, $second_appliance ];

    $self->{ua} = Test::WWW::Mechanize::Catalyst->new;

    $self->{room_count} = $schema->resultset(q{Room})->search({})->count;

    $self->{scene} = $schema->resultset(q{Scene})->create(
        {
            name  => q{evening mode},
            scene => <<'EOS',
[{"dimable":1,"device":"light1","room":"Lounge","address":"F2","state":"on"},{"device":"light2","address":"F6","room":"Lounge","dimable":1,"state":"on"},{"address":"F3","device":"Curtains","dimable":0,"room":"Lounge","state":"off"},{"room":"Dining","dimable":0,"device":"Curtains","address":"F4","state":"off"}]
EOS
        }
    );
    return 1;
}

sub test_shutdown {
    my ($self) = @_;

    $self->{schema}->resultset(q{User})->delete_all;
    $self->{schema}->resultset(q{Scene})->delete_all;

    for my $appliance (@{ $self->{appliances} }) {
        $appliance->clear;
    }

    $self->next::method();

    return 1;
}

sub test_teardown {
    my ($self) = @_;

    #logout
    $self->{ua}->get(q{/logout});

    $self->next::method();

    return 1;
}

sub login {
    my ($self, $user) = @_;

    my $ua = $self->{ua};
    $ua->get_ok(q{http://localhost/login}, q{Check redirect of base URL});
    $ua->title_is(q{Login}, q{Check for login title});
    $ua->submit_form(
        fields => {
            username => $user,
            password => q{mypass},
        }
    );

    return 1;
}

1;

__END__

=head1 NAME

Test::HomeAutomation::Controller

=head2 DESCRIPTION

Base class for the controller tests.

=cut

