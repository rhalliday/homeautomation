package Test::HomeAutomation::Schema::Scene;

use strict;
use warnings;

use Test::Class::Moose extends => 'Test::HomeAutomation::Schema';

use JSON qw/encode_json/;

our $VERSION = '1.00';

sub test_startup {
    my ($self) = @_;

    $self->next::method();

    $self->{first_appliance} = $self->{schema}->resultset(q{Appliance})->next_appliance;
    $self->{first_appliance}->update(
        {
            device   => 'Light',
            room_id  => 1,
            protocol => 'pl',
            status   => 1,
        }
    );

    $self->{resultset} = $self->{schema}->resultset(q{Scene});

    return 1;
}

sub test_teardown {

    # make sure all the appliances get cleared.
    my ($self) = @_;

    $self->{resultset}->delete_all;

    return 1;
}

# empty scene
sub test_empty_scene {
    my ($self) = @_;

    my $scene = $self->{resultset}->create({ name => q{empty one} });
    ok $scene->run, q{runs without errors};

    return 1;
}

# scene with appliance and delay
sub test_appliance_and_delay {
    my ($self) = @_;

    my $scene_config = [
        {
            delay => 1,
        },
        {
            address => $self->{first_appliance}->address,
            state   => q{off},
        },
    ];

    my $scene = $self->{resultset}->create(
        {
            name  => q{appliance and delay},
            scene => encode_json $scene_config,
        }
    );
    $self->set_up_mochad([ q{10/31 22:06:52 Tx PL HouseUnit: F1}, q{10/31 22:06:52 Tx PL House: F Func: Off} ]);
    ok $scene->run, q{runs ok};
    $self->{first_appliance}->discard_changes;
    is $self->{first_appliance}->status, 0, q{appliance has been turned off};

    # reset the status
    $self->{first_appliance}->update({ status => 1 });

    return 1;
}

# scene with just appliance
sub test_just_appliance {
    my ($self) = @_;

    my $scene_config = [
        {
            address => $self->{first_appliance}->address,
            state   => q{off},
        },
    ];

    my $scene = $self->{resultset}->create(
        {
            name  => q{just appliance},
            scene => encode_json $scene_config,
        }
    );

    $self->set_up_mochad([ q{10/31 22:06:52 Tx PL HouseUnit: F1}, q{10/31 22:06:52 Tx PL House: F Func: Off} ]);
    ok $scene->run, q{runs ok};
    $self->{first_appliance}->discard_changes;
    is $self->{first_appliance}->status, 0, q{appliance has been turned off};

    # reset the status
    $self->{first_appliance}->update({ status => 1 });

    return 1;
}

# scene with just delay
sub test_delay {
    my ($self) = @_;

    my $scene_config = [
        {
            delay => 1,
        },
    ];

    my $scene = $self->{resultset}->create(
        {
            name  => q{delay},
            scene => encode_json $scene_config,
        }
    );
    ok $scene->run, q{runs ok};

    return 1;
}

# scene with appliance that doesn't exist
sub test_appliance_not_exists {
    my ($self) = @_;

    my $scene_config = [
        {
            address => q{Z2},
            state   => q{off},
        },
        {
            address => $self->{first_appliance}->address,
            state   => q{off},
        },
    ];

    my $scene = $self->{resultset}->create(
        {
            name  => q{appliance doesn't exist},
            scene => encode_json $scene_config,
        }
    );

    $self->set_up_mochad([ q{10/31 22:06:52 Tx PL HouseUnit: F1}, q{10/31 22:06:52 Tx PL House: F Func: Off} ]);
    ok $scene->run, q{runs ok};
    $self->{first_appliance}->discard_changes;
    is $self->{first_appliance}->status, 0, q{appliance has been turned off};

    # reset the status
    $self->{first_appliance}->update({ status => 1 });

    return 1;
}

sub test_fuzzy_match {
    my ($self) = @_;

    $self->{resultset}->populate([
        [qw/name/],
        [q{rise and shine}],
        [q{bedtime}],
        [q{evening mode}],
    ]);

    my $scene = $self->{resultset}->fuzzy_match(q{ride am sign});
    is $scene->name, q{rise and shine}, q{get the right scene from something close};

    $scene = $self->{resultset}->fuzzy_match(q{evelyn node});
    is $scene->name, q{evening mode}, q{evening mode found};

    $scene = $self->{resultset}->fuzzy_match(q{bedtime});
    is $scene->name, q{bedtime}, q{exact match works};

    ok $self->{resultset}->fuzzy_match(q{why the face}), q{always match something};

    return 1;
}

1;
