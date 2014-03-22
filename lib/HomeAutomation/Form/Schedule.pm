package HomeAutomation::Form::Schedule;

use strict;
use warnings;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
use namespace::autoclean;

our $VERSION = '0.01';

has '+item_class' => (default => 'Task');
has '+widget_wrapper' => (default => 'Bootstrap');

has_field 'action' => (
    type     => 'Select',
    widget   => 'RadioGroup',
    options  => [ { value => 'on', label => 'on', }, { value => 'off', label => 'off', }, ],
    required => 1,
    wrapper_class => ['form-group'],
);

has_field 'time' => (
    type => 'Text',
    wrapper_class => ['form-group'],
    element_class => ['form-control'],
    element_attr  => { placeholder => 'HH:MM' },
);

sub validate_time {
    my ($self, $field) = @_;

    if ($field->value =~ /^(\d{2}):(\d{2})$/) {
        $field->add_error('Must be within 24 hours')
          unless $1 > -1 && $1 < 24;
        $field->add_error('Must be within 60 minutes')
          unless $2 > -1 && $2 < 60;
    } else {
        $field->add_error('Time must have HH:MM format');
    }
    return 1;
}

has_field 'expires' => (
    type => 'Date', 
    format => 'dd/mm/yy',
    wrapper_class => ['form-group'],
    element_class => ['form-control'],
    element_attr  => { placeholder => 'DD/MM/YYYY' },
);


has_field 'days' => (
    type => 'Select', 
    label_column => 'day', 
    sort_column => 'id', 
    multiple => 1, 
    widget => 'CheckboxGroup',
    wrapper_class => ['form-group'],
);

has_field 'submit' => (
    type => 'Submit', 
    value => 'Submit',
    element_class => ['btn', 'btn-primary'],
);

__PACKAGE__->meta->make_immutable;
1;
