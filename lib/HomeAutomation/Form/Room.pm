package HomeAutomation::Form::Room;

use strict;
use warnings;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
use namespace::autoclean;

use Readonly;

Readonly::Scalar my $MAX_SETTING => 31;

our $VERSION = '0.01';

has '+item_class'     => (default => 'Rooms');
has '+widget_wrapper' => (default => 'Bootstrap');

has_field 'name' => (
    type          => 'Text',
    required      => 1,
    element_class => ['form-control'],
    element_attr  => { placeholder => 'Name' },
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

HomeAutomation::Form::Room - Form for the creation of rooms

=head2 Description

Form to cover the creation/update of rooms in the web application.

=head2 Fields

=over

=item name

Name of the room

=back

=cut
