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

has_field 'timings' => (
    type          => 'PosInteger',
    element_class => ['form-control'],
    element_attr  => { placeholder => 'Seconds' },
    wrapper_class => ['form-group'],
);

has_field 'colour' => (
    type          => 'Text',
    maxlength     => 7,
    minlength     => 7,
    apply         => [ { check => qr/^#[A-F\d]{6}$/, message => q{Colour must be like '#000000'} } ],
    wrapper_class => ['form-group'],
    element_class => ['form-control color {hash:true}'],
    element_attr  => { placeholder => '#000000' },
);

has_field 'on_button_text' => (
    type          => 'Text',
    label         => 'On Button Text',
    maxlength     => 10,
    wrapper_class => ['form-group'],
    element_class => ['form-control'],
    element_attr  => { placeholder => 'On' },
);

has_field 'off_button_text' => (
    type          => 'Text',
    label         => 'Off Button Text',
    maxlength     => 10,
    wrapper_class => ['form-group'],
    element_class => ['form-control'],
    element_attr  => { placeholder => 'Off' },
);

has_field 'dimable' => (
    type          => 'Checkbox',
    label         => 'Dimable',
    wrapper_class => ['form-group'],
    element_class => ['checkbox'],
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

HomeAutomation::Form::Appliance - Form for the creation of appliances

=head2 Description

Form to cover the creation/update of appliances in the web application.

=head2 Fields

=over

=item device

Name of the appliance

=item room

Room the appliance is in

=item status

Whether the device is on or off

=item protocol

One of power line or radio frequency

=item timings

Number of seconds a timed device should be on for before turning off.

Useful for things like curtains.

=item On Button Text

Text to display for the on button, defaults to 'On'.

You could set it to something like 'Open'.

=item Off Button Text

Text to display for the off button, defaults to 'Off'.

You could set it to something like 'Close'.

=back

=cut
