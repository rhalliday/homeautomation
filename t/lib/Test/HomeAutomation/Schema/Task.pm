package Test::HomeAutomation::Schema::Task;

use Test::Class::Moose extends => 'Test::HomeAutomation::Schema';

use DateTime;

sub test_startup {
    my ($self) = @_;

    $self->next::method();

    $self->{resultset} = $self->{schema}->resultset(q{Task});

    # create a couple of appliances
    $self->{appliances} = [
        $self->{schema}->resultset(q{Appliance})->next_appliance->update({ device => 'Lights',  room_id => 1 }),
        $self->{schema}->resultset(q{Appliance})->next_appliance->update({ device => 'Curtain', room_id => 2 }),
    ];

    # set up a load of useful? DateTime objects
    $self->{today} = DateTime->from_epoch(epoch => 1396041043, time_zone => 'Europe/London');    # is a friday
    $self->{last_week} = $self->{today}->subtract(weeks => 1);
    $self->{next_week} = $self->{today}->add(weeks => 1);

    return 1;
}

sub test_shutdown {
    my ($self) = @_;

    for my $appliance (@{ $self->{appliances} }) {
        $appliance->clear;
    }

    $self->next::method();

    return 1;
}

sub test_teardown {
    my ($self) = @_;

    $self->{resultset}->delete_all;

    $self->next::method();

    return 1;
}


sub test_one_time_task {
    my ($self) = @_;

    my $task = $self->{resultset}->create(
        {
            appliance => $self->{appliances}[0],
            action    => 'on',
            time      => '16:00',
            day       => $self->{today}->ymd,
        }
    );

    is $task->all_days,          q{}, q{all days should return an empty string for one off events};
    is $task->recurrence_expiry, q{}, q{one off event shouldn't have a recurrence expiry};
    is $self->{resultset}->scheduled_tasks($self->{last_week}->epoch, $self->{next_week}->epoch)->count, 1,
      q{scheduled task is returned};

    return 1;
}

sub test_recurring_task {
    my ($self) = @_;

    my $task = $self->{resultset}->create(
        {
            appliance  => $self->{appliances}[0],
            action     => 'on',
            time       => '12:00',
            recurrence => {
                expires    => $self->{today}->ymd,
                tasks_days => [ { day_id => 1 }, { day_id => 3 }, { day_id => 5 }, ],
            },
        }
    );

    is $task->all_days, q{Monday, Wednesday, Friday}, q{all days returns a comma separated list of days};
    is $task->recurrence_expiry->ymd, q{2014-03-28}, q{recurrence_expiry returns the correct date};
    is $self->{resultset}->scheduled_tasks($self->{last_week}->epoch, $self->{next_week}->epoch)->count, 1,
      q{scheduled task returns a recurring task};

    return 1;
}

sub test_delete_allowed_by {
    my ($self) = @_;

    my $user = $self->{schema}->resultset(q{User})->create(
        {
            username => q{bob},
            password => q{mypass},
            email_address => q{bob@example.com},
            first_name => q{bob},
            last_name => q{user},
            active => 1,
        }
    );
    my $role_rs = $self->{schema}->resultset(q{Role})->find({ role => q{user} });
    $user->add_to_roles($role_rs);

    my $task = $self->{resultset}->create(
        {
            appliance => $self->{appliances}[0],
            action    => 'on',
            time      => '16:00',
            day       => $self->{today}->ymd,
        }
    );

    ok !$task->delete_allowed_by($user), q{non schedule user is not allowed to delete a schedule};

    $role_rs = $self->{schema}->resultset(q{Role})->find({ role => q{schedule} });
    $user->add_to_roles($role_rs);
    ok $task->delete_allowed_by($user), q{schedule user is allowed to delete};

    return 1;
}

1;
