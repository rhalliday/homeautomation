package HomeAutomation::Form::Appliance;

use strict;
use warnings;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
use namespace::autoclean;

our $VERSION = '0.01';

has '+item_class'     => (default => 'Appliances');
has '+widget_wrapper' => (default => 'Bootstrap');

has_field 'device' => (
    type          => 'Text',
    element_class => ['form-control'],
    element_attr  => { placeholder => 'Device' },
    wrapper_class => ['form-group'],
);

has_field 'room' => (
    type          => 'Select',
    init_value    => 7,
    element_class => ['form-control'],
    wrapper_class => ['form-group'],
);

has_field 'status' => (
    type          => 'Select',
    widget        => 'RadioGroup',
    options       => [ { value => 1, label => 'on' }, { value => 0, label => 'off' } ],
    default       => 0,
    wrapper_class => ['form-group'],
);

has_field 'protocol' => (
    type          => 'Select',
    widget        => 'RadioGroup',
    options       => [ { value => 'pl', label => 'Power Line' }, { value => 'rf', label => 'Radio Frequency' } ],
    default       => 'pl',
    wrapper_class => ['form-group'],
);

has_field 'submit' => (
    type          => 'Submit',
    value         => 'Submit',
    element_class => [ 'btn', 'btn-primary' ],
);

__PACKAGE__->meta->make_immutable;
1;
