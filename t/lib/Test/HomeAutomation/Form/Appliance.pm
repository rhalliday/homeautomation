package Test::HomeAutomation::Form::Appliance;

use strict;
use warnings;

use Test::Class::Moose extends => 'Test::HomeAutomation::Form';
use HomeAutomation::Form::Appliance;

our $VERSION = '1.00';

sub test_startup {
    my ($self) = @_;
    $self->next::method;

    $self->{appliance} = $self->{schema}->resultset(q{Appliance})->next_appliance;

    return 1;
}

sub test_setup {
    my ($self) = @_;
    $self->next::method;

    $self->{form} = HomeAutomation::Form::Appliance->new(item => $self->{appliance});

    return 1;
}

sub test_teardown {
    my ($self) = @_;

    # make sure we reset any changes to the password
    $self->{appliance}->clear;

    $self->{form} = undef;

    $self->next::method;
    return 1;
}

sub test_successful_change {
    my ($self) = @_;

    my $params = _good_params();

    ok $self->{form}->process(params => $params), q{form processes with correct data};

    return 1;
}

sub test_bad_timing {
    my ($self) = @_;

    my $params = _good_params();
    $params->{timings} = q{hello};

    ok !$self->{form}->process(params => $params), q{form doesn't process when timing is a string};
    ok $self->{form}->field(q{timings})->has_errors, q{time has errors - not int};
    eq_or_diff $self->{form}->field(q{timings})->errors,
      [q{Value must be an integer}, q{Value must be a positive integer}],
      q{correct error message for not int};

    return 1;
}

sub test_bad_colour {
    my ($self) = @_;

    my $params = _good_params();
    $params->{colour} = q{hello};

    ok !$self->{form}->process(params => $params), q{form doesn't process when colour does not match format};
    ok $self->{form}->field(q{colour})->has_errors, q{colour has errors - not right format};
    eq_or_diff $self->{form}->field(q{colour})->errors,
      [ q{Colour must be like '#000000'}, q{Field must be at least 7 characters. You entered 5} ],
      q{correct error message for bad format};

    return 1;
}

sub _good_params {
    return {
        device   => q{Lights},
        room     => 7,
        status   => 1,
        timings  => 10,
        colour   => q{#000000},
        protocol => q{pl},
    };
}

1;

__END__

=head1 NAME

Test::HomeAutomation::Form::Appliance

=head2 DESCRIPTION

Test the Appliance Form.

=cut

