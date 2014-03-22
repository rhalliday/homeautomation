package HomeAutomation::Form::ChangePassword;

use strict;
use warnings;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
use HTML::FormHandler::Types qw( NoSpaces NotAllDigits );
use namespace::autoclean;

our $VERSION = '0.01';

has user => (is => 'ro');

has_field 'current_password' => (type => 'Password', label => 'Current Password', required => 1);

# make sure the user knows their password
sub validate_old_password {
    my ($self, $field) = @_;
    unless ($self->item->check_password($field->value)) {
        $field->add_error('incorrect password');
    }
}

#chance to update their password
has_field 'new_password' => (
    type     => 'Password',
    label    => 'New Password',
    apply    => [ NoSpaces, NotAllDigits ],
    required => 1
);

has_field 'new_password_conf' => (
    type           => 'PasswordConf',
    label          => 'Confirm New Password',
    messages       => { required => 'You must enter the password a second time' },
    password_field => 'new_password',
    required       => 1,
);

has_field 'submit' => (type => 'Submit', value => 'Submit');

__PACKAGE__->meta->make_immutable;
1;
