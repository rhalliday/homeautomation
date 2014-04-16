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

    my $params = {
        device   => 'Lights',
        room     => 7,
        status   => 1,
        protocol => 'pl',
    };

    ok $self->{form}->process(params => $params), q{form processes with correct data};

    return 1;
}

1;

__END__

=head1 NAME

Test::HomeAutomation::Form::Appliance

=head2 DESCRIPTION

Test the Appliance Form.

=cut

