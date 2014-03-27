package Test::HomeAutomation::Schema::Appliance;

use Test::Class::Moose extends => 'Test::HomeAutomation::Schema';

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
    while(my $appliance = $all_appliances->next()) {
        $appliance->clear();
    }
}

sub test_appliance_contents {
    my ($self) = @_;

    is($self->{resultset}->count, 16, q{appliance should have 16 rows});

    return 1;
}

sub test_get_new_appliance {
    my ($self) = @_;

    my $first_appliance = $self->{resultset}->next_appliance;
    is($first_appliance->address, q{F1}, q{next_appliance returns the appliance at address F1});

    # give the appliance some details
    $first_appliance->update(
        {
            device => 'Light',
            room_id => 1,
            protocol => 'pl',
            status   => 1,
        }
    );

    my $second_appliance = $self->{resultset}->next_appliance;
    is($second_appliance->address, q{F2}, q{next_appliance returns F2 when F1 is filled});

    $second_appliance->update(
        {
            device => 'Curtain',
            room_id => 2,
            protocol => 'pl',
            status => 0,
        }
    );

    $first_appliance->switch;
    ok(!$first_appliance->status, q{just turned the lights out});
    
    $first_appliance->switch;
    ok($first_appliance->status, q{now they're on again});

    my $all_appliances = $self->{resultset}->all_appliances;

    is($all_appliances->count, 2, q{there are 2 set devices});

    my $room = $self->{schema}->resultset(q{Room})->find(1);

    my $room_appliance = $self->{resultset}->appliances_in_room($room->name);

    is($room_appliance->count, 1, q{there is only one device in that room});

    return 1;
}

sub test_fill_all_appliances {
    my ($self) = @_;

    for my $i (1..16) {
        my $appliance = $self->{resultset}->next_appliance;
        $appliance->update({ device => 'Lights' });
    }

    is($self->{resultset}->next_appliance, undef, q{next_appliance returns undef when there are none left});
}

1;
