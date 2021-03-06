package Test::HomeAutomation::Schema::Appliance;

use strict;
use warnings;

use Test::Class::Moose extends => 'Test::HomeAutomation::Schema';

use Readonly;

Readonly::Scalar my $NUM_APPLIANCES => 16;
Readonly::Scalar my $DIM_SETTING    => 5;

our $VERSION = '1.00';

sub test_startup {
    my ($self) = @_;

    $self->next::method();

    $self->{resultset} = $self->{schema}->resultset(q{Appliance});

    return 1;
}

sub test_teardown {

    # make sure all the appliances get cleared.
    my ($self) = @_;

    my $all_appliances = $self->{resultset}->all_appliances;

    # clear the appliances
    while (my $appliance = $all_appliances->next()) {
        $appliance->clear();
    }

    return 1;
}

sub test_appliance_contents {
    my ($self) = @_;

    is($self->{resultset}->count, $NUM_APPLIANCES, qq{appliance should have $NUM_APPLIANCES rows});

    return 1;
}

sub test_get_new_appliance {
    my ($self) = @_;

    my $first_appliance = $self->{resultset}->next_appliance;
    is($first_appliance->address, q{F1}, q{next_appliance returns the appliance at address F1});

    # give the appliance some details
    $first_appliance->update(
        {
            device   => 'Light',
            room_id  => 1,
            protocol => 'pl',
            status   => 1,
        }
    );
    isa_ok($first_appliance->hardware, q{Mochad}, q{hardware is a Mochad object});
    $self->set_up_mochad([ q{10/31 22:06:52 Tx PL HouseUnit: F1}, q{10/31 22:06:52 Tx PL House: F Func: On} ]);
    ok $first_appliance->hardware->on(), q{can turn the appliance on};
    is $self->{fake_mochad}->message, q{pl F1 on} . "\n", q{appliance on sends the correct message};

    $self->set_up_mochad([ q{10/31 22:06:52 Tx PL HouseUnit: F1}, q{10/31 22:06:52 Tx PL House: F Func: Off} ]);
    ok $first_appliance->control(q{off}), q{can call the control method};
    is $first_appliance->status, 0, q{first appliance status is now off};
    is $self->{fake_mochad}->message, q{pl F1 off} . "\n", q{control off sends the correct message};

    my $second_appliance = $self->{resultset}->next_appliance;
    is($second_appliance->address, q{F2}, q{next_appliance returns F2 when F1 is filled});

    $second_appliance->update(
        {
            device   => 'Curtain',
            room_id  => 2,
            protocol => 'pl',
            status   => 1,
        }
    );

    $self->set_up_mochad([ q{10/31 22:06:52 Tx PL HouseUnit: F2}, q{10/31 22:06:52 Tx PL House: F Func: Off} ]);
    $second_appliance->switch;
    ok(!$second_appliance->status, q{just turned the lights out});
    is $self->{fake_mochad}->message, q{pl F2 off} . "\n", q{switch off sends the correct message};

    $self->set_up_mochad([ q{10/31 22:06:52 Tx PL HouseUnit: F2}, q{10/31 22:06:52 Tx PL House: F Func: On} ]);
    $second_appliance->switch;
    ok($second_appliance->status, q{now they're on again});
    is $self->{fake_mochad}->message, q{pl F2 on} . "\n", q{switch on sends the correct message};

    my $all_appliances = $self->{resultset}->all_appliances;

    is($all_appliances->count, 2, q{there are 2 set devices});

    my $room = $self->{schema}->resultset(q{Room})->find(1);

    my $room_appliance = $self->{resultset}->appliances_in_room($room->name);

    is($room_appliance->count, 1, q{there is only one device in that room});

    return 1;
}

sub test_fill_all_appliances {
    my ($self) = @_;

    for my $i (1 .. $NUM_APPLIANCES) {
        my $appliance = $self->{resultset}->next_appliance;
        $appliance->update({ device => 'Lights' });
    }

    is($self->{resultset}->next_appliance, undef, q{next_appliance returns undef when there are none left});

    return 1;
}

sub test_appliance_with_timings {
    my ($self) = @_;

    my $appliance = $self->{resultset}->next_appliance;
    is($appliance->address, q{F1}, q{next_appliance returns the appliance at address F1});

    # give the appliance some details
    $appliance->update(
        {
            device   => 'Curtain',
            room_id  => 1,
            protocol => 'pl',
            status   => 0,
            timings  => 1,
        }
    );
    $self->set_up_mochad(
        [
            q{10/31 22:06:52 Tx PL HouseUnit: F1},
            q{10/31 22:06:52 Tx PL House: F Func: On},
            q{10/31 22:06:52 Tx PL HouseUnit: F1},
            q{10/31 22:06:52 Tx PL House: F Func: Off}
        ]
    );
    $appliance->switch;
    ok($appliance->status, q{switch turns the curtain on});
    is $self->{fake_mochad}->message, q{pl F1 on} . "\n" . q{pl F1 off} . "\n",
      q{the last message sent should be an off one despite the status being on};

    $self->set_up_mochad(
        [
            q{10/31 22:06:52 Tx PL HouseUnit: F1},
            q{10/31 22:06:52 Tx PL House: F Func: On},
            q{10/31 22:06:52 Tx PL HouseUnit: F1},
            q{10/31 22:06:52 Tx PL House: F Func: Off}
        ]
    );

    # send the on message
    $appliance->control(q{on});
    ok($appliance->status, q{timed device should still be on if it was on before});
    is $self->{fake_mochad}->message, undef, q{no message should've been sent to the device as it is already on};

    $self->set_up_mochad(
        [
            q{10/31 22:06:52 Tx PL HouseUnit: F1},
            q{10/31 22:06:52 Tx PL House: F Func: On},
            q{10/31 22:06:52 Tx PL HouseUnit: F1},
            q{10/31 22:06:52 Tx PL House: F Func: Off}
        ]
    );
    $appliance->control(q{off});
    ok(!$appliance->status, q{can turn the curtain off});
    is $self->{fake_mochad}->message, q{pl F1 on} . "\n" . q{pl F1 off} . "\n", q{correct message to close curtains};

    $self->set_up_mochad(
        [
            q{10/31 22:06:52 Tx PL HouseUnit: F1},
            q{10/31 22:06:52 Tx PL House: F Func: On},
            q{10/31 22:06:52 Tx PL HouseUnit: F1},
            q{10/31 22:06:52 Tx PL House: F Func: Off}
        ]
    );
    $appliance->control(q{off});
    ok !$appliance->status, q{timed device should still be off if it was off before};
    is $self->{fake_mochad}->message, undef, q{no message should've been sent to the device as it is already off};

    $self->set_up_mochad(
        [
            q{10/31 22:06:52 Tx PL HouseUnit: F1},
            q{10/31 22:06:52 Tx PL House: F Func: On},
            q{10/31 22:06:52 Tx PL HouseUnit: F1},
            q{10/31 22:06:52 Tx PL House: F Func: Off}
        ]
    );

    # send the on message
    $appliance->control(q{on});
    ok($appliance->status, q{timed device should now be on if it was off before});
    return 1;
}

sub test_dim {
    my ($self) = @_;

    my $appliance = $self->{resultset}->next_appliance;
    $appliance->update(
        {
            device   => 'Light',
            room_id  => 1,
            protocol => 'pl',
            status   => 0,
            colour   => undef,
        }
    );

    ok !$appliance->dim(1), q{can't dim an appliance unless it is dimmable};
    is $appliance->text_colour, q{#000}, q{text defaults to black};

    # make the appliance dimmable
    $appliance->update(
        {
            dimable => 1,
            setting => 1,
        }
    );

    ok !$appliance->dim(1), q{dim doesn't do anything if the dim setting is already set};

    $self->set_up_mochad([ q{10/31 22:06:52 Tx PL HouseUnit: F1}, q{10/31 22:06:52 Tx PL House: F Func: Bright} ]);
    ok $appliance->dim($DIM_SETTING), q{dim returns true if it has something to do};
    is $self->{fake_mochad}->message, q{pl F1 bright 4} . "\n", q{dim sends bright message if it needs to};

    $self->set_up_mochad([ q{10/31 22:06:52 Tx PL HouseUnit: F1}, q{10/31 22:06:52 Tx PL House: F Func: Dim} ]);
    ok $appliance->dim(1), q{dim returns true if it has something to do - dim};
    is $self->{fake_mochad}->message, q{pl F1 dim 4} . "\n", q{dim sends dim message if it needs to};

    return 1;
}

1;
