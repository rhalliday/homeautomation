package Test::HomeAutomation::Form::Schedule;

use Test::Class::Moose extends => 'Test::HomeAutomation::Form';
use HomeAutomation::Form::Schedule;

sub test_startup {
    my ($self) = @_;
    $self->next::method;

    my $appliance = $self->{schema}->resultset(q{Appliance})->next_appliance;
    $appliance->update({ device => q{Lights} });

    my $schedule_rs = $self->{schema}->resultset(q{Task});

    $self->{task} = $schedule_rs->new_result({ appliance => $appliance->address });

    return 1;
}

sub test_setup {
    my ($self) = @_;
    $self->next::method;

    $self->{form} = HomeAutomation::Form::Schedule->new(item => $self->{task});

    return 1;
}

sub test_teardown {
    my ($self) = @_;

    $self->{form} = undef;

    $self->next::method;
    return 1;
}

sub test_shutdown {
    my ($self) = @_;

    $self->{task}->delete;
    $self->next::method;

    return 1;
}

sub test_successful_change {
    my ($self) = @_;

    my $params = {
        action     => 'on',
        time       => '16:00',
        day        => '25/09/2125',
    };

    ok $self->{form}->process(params => $params), q{form processes with correct data};

    return 1;
}

sub test_bad_time {
    my ($self) = @_;

    my $params = {
        action => 'on',
        time   => '16:00:00',
        day    => '25/09/2125',
    };

    ok !$self->{form}->process(params => $params), q{form doesn't process with incorrect time format};
    ok $self->{form}->field(q{time})->has_errors, q{time has errors - bad format};
    eq_or_diff $self->{form}->field(q{time})->errors, [q{Time must have HH:MM format}],
      q{correct error message for bad format};

    $params = {
        action => 'on',
        time   => '16:62',
        day    => '25/09/2125',
    };

    ok !$self->{form}->process(params => $params), q{form doesn't process with incorrect minutes};
    ok $self->{form}->field(q{time})->has_errors, q{time has errors - incorrect minutes};
    eq_or_diff $self->{form}->field(q{time})->errors, [q{Must be within 60 minutes}],
      q{correct error message for incorrect minutes};

    $params = {
        action => 'on',
        time   => '25:00',
        day    => '25/09/2125',
    };

    ok !$self->{form}->process(params => $params), q{form doesn't process with incorrect hours};
    ok $self->{form}->field(q{time})->has_errors, q{time has errors - incorrect hours};
    eq_or_diff $self->{form}->field(q{time})->errors, [q{Must be within 24 hours}],
      q{correct error message for incorrect hours};

    return 1;
}

sub test_bad_day {
    my ($self) = @_;

    my $params = {
        action => 'on',
        time   => '16:10',
        day    => '25-09-2125',
    };

    ok !$self->{form}->process(params => $params), q{form doesn't process with incorrect date format};
    ok $self->{form}->field(q{day})->has_errors, q{day has errors - bad format};
    eq_or_diff $self->{form}->field(q{day})->errors, [q{Your datetime does not match your pattern.}],
      q{correct error message for bad format};

    return 1;
}

1;

__END__

=head1 NAME

Test::HomeAutomation::Form::Schedule

=head2 DESCRIPTION

Test the Schedule Form.

=cut
