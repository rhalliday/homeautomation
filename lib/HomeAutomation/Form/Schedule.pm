package HomeAutomation::Form::Schedule;

use strict;
use warnings;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
use namespace::autoclean;
use Readonly;

Readonly::Scalar my $MAX_HOURS => 23;
Readonly::Scalar my $MAX_MINS  => 59;

our $VERSION = '0.01';

has '+item_class'     => (default => 'Task');
has '+widget_wrapper' => (default => 'Bootstrap');

has_field 'action' => (
    type          => 'Select',
    widget        => 'RadioGroup',
    options       => [ { value => 'on', label => 'on', }, { value => 'off', label => 'off', }, ],
    required      => 1,
    wrapper_class => ['form-group'],
);

has_field 'time' => (
    type          => 'Text',
    wrapper_class => ['form-group'],
    element_class => ['form-control'],
    element_attr  => { placeholder => 'HH:MM' },
);

sub validate_time {
    my ($self, $field) = @_;

    if ($field->value =~ /^(\d{2}):(\d{2})$/) {
        if ($1 < 0 && $1 > $MAX_HOURS) {
            $field->add_error('Must be within 24 hours');
        }
        if ($2 < 0 && $1 > $MAX_MINS) {
            $field->add_error('Must be within 60 minutes');
        }
    } else {
        $field->add_error('Time must have HH:MM format');
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
