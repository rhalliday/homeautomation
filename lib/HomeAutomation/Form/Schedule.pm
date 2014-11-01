package HomeAutomation::Form::Schedule;

use strict;
use warnings;

use 5.010;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
use namespace::autoclean;
use Readonly;

Readonly::Scalar my $MAX_HOURS => 23;
Readonly::Scalar my $MAX_MINS  => 59;

our $VERSION = '0.01';

has '+item_class'     => (default => 'Task');
has '+widget_wrapper' => (default => 'Bootstrap');

has 'action_labels' => (
    is       => 'ro',
    isa      => 'HashRef',
    required => 1,
    default  => sub { return { on => q{On}, off => q{Off} } },
);

has_field 'action' => (
    type          => 'Select',
    widget        => 'RadioGroup',
    required      => 1,
    wrapper_class => ['form-group'],
);

sub options_action {
    my ($self) = @_;

    my $on_label  = $self->action_labels->{on};
    my $off_label = $self->action_labels->{off};

    return [ { value => 'on', label => $on_label, }, { value => 'off', label => $off_label } ];
}

has_field 'time' => (
    type          => 'Text',
    required      => 1,
    wrapper_class => ['form-group'],
    element_class => ['form-control'],
    element_attr  => { placeholder => 'HH:MM' },
);

sub validate_time {
    my ($self, $field) = @_;

    if ($field->value =~ /^(?<hour>\d{2}):(?<min>\d{2})$/x) {
        if ($+{hour} > $MAX_HOURS) {
            $field->add_error('Must be within 24 hours');
            return 0;
        }
        if ($+{min} > $MAX_MINS) {
            $field->add_error('Must be within 60 minutes');
            return 0;
        }
    } else {
        $field->add_error('Time must have HH:MM format');
        return 0;
    }
    return 1;
}

has_field 'day' => (
    type          => 'Date',
    format        => 'dd/mm/yy',
    wrapper_class => ['form-group'],
    element_class => ['form-control'],
    element_attr  => { placeholder => 'DD/MM/YYYY' },
);

has_field 'recurrence' => (type => 'Compound',);

has_field 'recurrence.expires' => (
    type          => 'Date',
    format        => 'dd/mm/yy',
    wrapper_class => ['form-group'],
    element_class => ['form-control'],
    element_attr  => { placeholder => 'DD/MM/YYYY' },
);

has_field 'recurrence.days' => (
    type          => 'Select',
    label_column  => 'day',
    sort_column   => 'id',
    multiple      => 1,
    widget        => 'CheckboxGroup',
    wrapper_class => ['form-group'],
);

has_field 'submit' => (
    type          => 'Submit',
    value         => 'Submit',
    element_class => [ 'btn', 'btn-primary' ],
);

__PACKAGE__->meta->make_immutable;
1;

__END__

=head1 NAME

HomeAutomation::Form::Schedule - Form for setting up scheduled tasks

=head2 Description

Form to set up times for actions to take place. This means you can
schedule the curtains to close at a certain time and turn the lights on.

=head2 Fields

=over

=item action

action to perform on the device.

=item time

time to perform the action.

=item day

day to perform the action on.

=item recurrence-expires

if you want to perform the action on multiple days, leave day blank
and set the expire for a recurrence.

=item recurrence-days

set which days to perform the task on.

=back

=head2 validation

=over

=item validate_time

Time should be in HH:MM format.

=back

=cut
