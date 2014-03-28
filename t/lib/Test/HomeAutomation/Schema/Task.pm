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

    $self->{resultset}->delete_all;

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

    $self->{resultset}->delete_all;

    return 1;
}

1;
