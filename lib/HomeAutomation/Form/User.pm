package HomeAutomation::Form::User;

use strict;
use warnings;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
use HTML::FormHandler::Types qw( NoSpaces Email NotAllDigits );
use Email::Valid;
use namespace::autoclean;

our $VERSION = '0.01';

has '+item_class' => (default => 'User');
has_field 'username' => (
    type     => 'Text',
    required => 1,
    unique   => 1,
    message  => { required => 'username is required', unique => 'this username is already taken', }
);

has_field 'password' => (type => 'Password', apply => [ NoSpaces, NotAllDigits ]);

has_field 'first_name' => (type => 'Text',);

has_field 'last_name' => (type => 'Text',);

has_field 'email_address' =>
  (type => 'Text', required => 1, message => q{I's got ta ave ur address, init bruv?}, apply => [Email]);

has_field 'roles' => (type => 'Select', label_column => 'role', multiple => 1, widget => 'CheckboxGroup');

has_field 'active' => (type => 'Checkbox');

has_field 'submit' => (type => 'Submit', value => 'Submit');

__PACKAGE__->meta->make_immutable;
1;
