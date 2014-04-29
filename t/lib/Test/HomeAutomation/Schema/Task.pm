package Test::HomeAutomation::Schema::Task;

use strict;
use warnings;

use Test::Class::Moose extends => 'Test::HomeAutomation::Schema';

use DateTime;
use Readonly;

Readonly::Scalar my $TODAY_EPOCH  => 1_396_041_043;
Readonly::Scalar my $START_EPOCH  => 1_395_436_243;
Readonly::Scalar my $END_EPOCH    => 1_396_645_843;
Readonly::Scalar my $DAYS_IN_WEEK => 7;

our $VERSION = '1.00';

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
    $self->{today}     = DateTime->from_epoch(epoch => $TODAY_EPOCH, time_zone => 'Europe/London');    # is a friday
    $self->{last_week} = $START_EPOCH;
    $self->{next_week} = $END_EPOCH;

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
    my $start = $self->{last_week};
    my $end   = $self->{next_week};
    is $self->{resultset}->scheduled_tasks($start, $end)->count, 1, q{scheduled task is returned};

    my $url = q{http://example.com/task/view};
    eq_or_diff $task->full_calendar($url, $start, $end),
      [ { start => q{2014-03-28T16:00:00Z}, title => q{16:00: Lights on}, url => $url, } ], q{full_calendar check};

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
    my $start = $self->{last_week};
    my $end   = $self->{next_week};
    is $self->{resultset}->scheduled_tasks($start, $end)->count, 1, q{scheduled task returns a recurring task};

    my $url = q{http://example.com/task/view};
    eq_or_diff $task->full_calendar($url, $start, $end),
      [
        { start => q{2014-03-21T12:00:00Z}, title => q{12:00: Lights on}, url => $url, },
        { start => q{2014-03-24T12:00:00Z}, title => q{12:00: Lights on}, url => $url, },
        { start => q{2014-03-26T12:00:00Z}, title => q{12:00: Lights on}, url => $url, },
      ],
      q{full_calendar check};

    return 1;
}

sub test_recurring_task_in_the_future {
    my ($self) = @_;

    my $today = DateTime->now(time_zone => 'Europe/London');
    my $task = $self->{resultset}->create(
        {
            appliance  => $self->{appliances}[0],
            action     => 'on',
            time       => '12:00',
            recurrence => {
                expires    => $today->ymd,
                tasks_days => [ { day_id => 1 }, { day_id => 3 }, { day_id => 5 }, ],
            },
        }
    );

    my $start = $self->{last_week};
    my $end   = $self->{next_week};
    my $url   = q{http://example.com/task/view};
    eq_or_diff $task->full_calendar($url, $start, $end),
      [
        { start => q{2014-03-21T12:00:00Z}, title => q{12:00: Lights on}, url => $url, },
        { start => q{2014-03-24T12:00:00Z}, title => q{12:00: Lights on}, url => $url, },
        { start => q{2014-03-26T12:00:00Z}, title => q{12:00: Lights on}, url => $url, },
        { start => q{2014-03-28T12:00:00Z}, title => q{12:00: Lights on}, url => $url, },
        { start => q{2014-03-31T12:00:00Z}, title => q{12:00: Lights on}, url => $url, },
        { start => q{2014-04-02T12:00:00Z}, title => q{12:00: Lights on}, url => $url, },
        { start => q{2014-04-04T12:00:00Z}, title => q{12:00: Lights on}, url => $url, },
      ],
      q{full_calendar check};

    return 1;
}

sub test_recurring_task_no_expiry {
    my ($self) = @_;

    my $task = $self->{resultset}->create(
        {
            appliance  => $self->{appliances}[0],
            action     => 'on',
            time       => '12:00',
            recurrence => {
                expires    => undef,
                tasks_days => [ { day_id => 1 }, { day_id => 3 }, { day_id => 5 }, ],
            },
        }
    );

    is $task->all_days, q{Monday, Wednesday, Friday}, q{all days returns a comma separated list of days};
    ok !$task->recurrence_expiry, q{there is no expiry for this task};
    my $start = $self->{last_week};
    my $end   = $self->{next_week};
    is $self->{resultset}->scheduled_tasks($start, $end)->count, 1, q{scheduled task returns a recurring task};

    my $url = q{http://example.com/task/view};
    eq_or_diff $task->full_calendar($url, $start, $end),
      [
        { start => q{2014-03-21T12:00:00Z}, title => q{12:00: Lights on}, url => $url, },
        { start => q{2014-03-24T12:00:00Z}, title => q{12:00: Lights on}, url => $url, },
        { start => q{2014-03-26T12:00:00Z}, title => q{12:00: Lights on}, url => $url, },
        { start => q{2014-03-28T12:00:00Z}, title => q{12:00: Lights on}, url => $url, },
        { start => q{2014-03-31T12:00:00Z}, title => q{12:00: Lights on}, url => $url, },
        { start => q{2014-04-02T12:00:00Z}, title => q{12:00: Lights on}, url => $url, },
        { start => q{2014-04-04T12:00:00Z}, title => q{12:00: Lights on}, url => $url, },
      ],
      q{full_calendar check};

    return 1;
}

sub test_delete_allowed_by {
    my ($self) = @_;

    my $user = $self->{schema}->resultset(q{User})->create(
        {
            username      => q{bob},
            password      => q{mypass},
            email_address => q{bob@example.com},
            first_name    => q{bob},
            last_name     => q{user},
            active        => 1,
        }
    );
    my $role_rs = $self->{schema}->resultset(q{Role})->find({ role => q{user} });
    $user->add_to_roles($role_rs);

    my $task = $self->{resultset}->create(
        {
            appliance => $self->{appliances}[0],
            action    => q{on},
            time      => q{16:00},
            day       => $self->{today}->ymd,
        }
    );

    ok !$task->delete_allowed_by($user), q{non schedule user is not allowed to delete a schedule};

    $role_rs = $self->{schema}->resultset(q{Role})->find({ role => q{schedule} });
    $user->add_to_roles($role_rs);
    ok $task->delete_allowed_by($user), q{schedule user is allowed to delete};

    return 1;
}

sub test_active_tasks {
    my ($self) = @_;

    my @tasks = $self->{resultset}->active_tasks();
    is scalar @tasks, 0, q{no pending tasks};

    my $dt = DateTime->now(time_zone => 'Europe/London');
    my $time = sprintf('%02d:%02d', $dt->hour, $dt->minute);

    my $task = $self->{resultset}->create(
        {
            appliance => $self->{appliances}[0],
            action    => q{on},
            time      => $time,
            day       => $dt->ymd,
        }
    );

    @tasks = $self->{resultset}->active_tasks();
    is scalar @tasks, 1, q{we have a pending task};
    is $tasks[0]->action, q{on}, q{get back the right action};
    is $tasks[0]->appliance->device, $self->{appliances}[0]->device, q{get back the right device};

    return 1;
}

sub test_active_tasks_recurring {
    my ($self) = @_;

    my $dt = DateTime->now(time_zone => 'Europe/London');
    my $time     = sprintf('%02d:%02d', $dt->hour, $dt->minute);
    my $dow      = $dt->dow;
    my $tomorrow = ($dow % $DAYS_IN_WEEK) + 1;

    $self->{resultset}->populate(
        [
            {
                appliance  => $self->{appliances}[0],
                action     => q{on},
                time       => $time,
                recurrence => {
                    id         => 1,
                    expires    => $dt->add(days => 1),
                    tasks_days => [ { day_id => $dow }, ],
                },
            },
            {
                appliance  => $self->{appliances}[0],
                action     => q{off},
                time       => $time,
                recurrence => {
                    id         => 2,
                    expires    => $dt->add(days => 1),
                    tasks_days => [ { day_id => $tomorrow }, ],
                },
            },
        ]
    );

    my @tasks = $self->{resultset}->active_tasks();
    is scalar @tasks, 1, q{we have just one pending task};
    is $tasks[0]->action, q{on}, q{get back the right action};
    is $tasks[0]->appliance->device, $self->{appliances}[0]->device, q{get back the right device};

    return 1;
}

sub test_active_tasks_recurring_no_expires {
    my ($self) = @_;

    my $dt = DateTime->now(time_zone => 'Europe/London');
    my $time     = sprintf('%02d:%02d', $dt->hour, $dt->minute);
    my $dow      = $dt->dow;
    my $tomorrow = ($dow % $DAYS_IN_WEEK) + 1;

    $self->{resultset}->populate(
        [
            {
                appliance  => $self->{appliances}[0],
                action     => q{on},
                time       => $time,
                recurrence => {
                    id         => 1,
                    tasks_days => [ { day_id => $dow }, ],
                },
            },
            {
                appliance  => $self->{appliances}[0],
                action     => q{off},
                time       => $time,
                recurrence => {
                    id         => 2,
                    expires    => $dt->add(days => 1),
                    tasks_days => [ { day_id => $tomorrow }, ],
                },
            },
        ]
    );

    my @tasks = $self->{resultset}->active_tasks();
    is scalar @tasks, 1, q{we have just one pending task};
    is $tasks[0]->action, q{on}, q{get back the right action};
    is $tasks[0]->appliance->device, $self->{appliances}[0]->device, q{get back the right device};

    return 1;
}

1;
