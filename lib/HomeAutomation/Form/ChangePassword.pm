package HomeAutomation::Form::ChangePassword;

use strict;
use warnings;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
use HTML::FormHandler::Types qw( NoSpaces NotAllDigits );
use namespace::autoclean;

our $VERSION = '0.01';

has user => (
    is  => 'ro',
    isa => 'HomeAutomation::Schema::Result::User',
);

has_field 'current_password' => (
    type          => 'Password',
    label         => 'Current Password',
    required      => 1,
    element_class => ['form-control'],
    element_attr  => { placeholder => 'Current Password' },
    wrapper_class => ['form-group'],
);

#chance to update their password
has_field 'new_password' => (
    type          => 'Password',
    label         => 'New Password',
    apply         => [ NoSpaces, NotAllDigits ],
    required      => 1,
    element_class => ['form-control'],
    element_attr  => { placeholder => 'New Password' },
    wrapper_class => ['form-group'],
);

has_field 'new_password_conf' => (
    type           => 'PasswordConf',
    label          => 'Confirm New Password',
    messages       => { required => 'You must enter the password a second time' },
    password_field => 'new_password',
    required       => 1,
    element_class  => ['form-control'],
    element_attr   => { placeholder => 'Confirm Password' },
    wrapper_class  => ['form-group'],
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

HomeAutomation::Form::ChangePassword - Form for changing a users password

=head2 Description

Form to allow a user to change their password. It is not a DBIC sub-class
so controllers using the form will need to update the password themselves.

=head2 Fields

=over

=item current_password

Current password

B<Note: no checks are performed to make sure this is correct so this needs
to be handled in the controller>

=item new_password

The new password, must be alpha-numeric with no spaces.

=item new_password_conf

Checked to make sure it is the same as new_password.

=back

=cut
