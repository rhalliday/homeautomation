package HomeAutomation::Form::Scene;

use strict;
use warnings;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
use namespace::autoclean;

our $VERSION = '0.01';

has '+item_class'     => (default => 'Scene');
has '+widget_wrapper' => (default => 'Bootstrap');

has_field 'name' => (
    type          => 'Text',
    required      => 1,
    element_class => ['form-control'],
    element_attr  => { placeholder => 'Device' },
    wrapper_class => ['form-group'],
);

has_field 'room' => (
    type          => 'Select',
    empty_select  => 'No Room',
    element_class => ['form-control'],
    wrapper_class => ['form-group'],
);

has_field 'scene' => (
    type          => 'Hidden',
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

HomeAutomation::Form::Scene - Form for the creation of scenes

=head2 Description

Form to cover the creation/update of scenes in the web application.

=head2 Fields

=over

=item name

Name of the scene

=item room

Room the scene is in (possibly blank)

=item scene

JSON representation of a scene

=back

=cut
