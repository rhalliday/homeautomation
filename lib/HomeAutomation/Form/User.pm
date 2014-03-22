package HomeAutomation::Form::User;

use strict;
use warnings;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
use HTML::FormHandler::Types qw( NoSpaces Email NotAllDigits );
use Email::Valid;
use namespace::autoclean;

our $VERSION = '0.01';

has '+item_class'     => (default => 'User');
has '+widget_wrapper' => (default => 'Bootstrap');

has_field 'username' => (
    type          => 'Text',
    required      => 1,
    unique        => 1,
    message       => { required => 'username is required', unique => 'this username is already taken', },
    element_class => ['form-control'],
    element_attr  => { placeholder => 'Username' },
    wrapper_class => ['form-group'],
);

has_field 'password' => (
    type          => 'Password',
    apply         => [ NoSpaces, NotAllDigits ],
    element_class => ['form-control'],
    wrapper_class => ['form-group'],
);

has_field 'first_name' => (
    type          => 'Text',
    element_class => ['form-control'],
    element_attr  => { placeholder => 'First Name' },
    wrapper_class => ['form-group'],
);

has_field 'last_name' => (
    type          => 'Text',
    element_class => ['form-control'],
    element_attr  => { placeholder => 'Last Name' },
    wrapper_class => ['form-group'],
);

has_field 'email_address' => (
    type          => 'Text',
    required      => 1,
    message       => q{I's got ta ave ur address, init bruv?},
    apply         => [Email],
    element_class => ['form-control'],
    element_attr  => { placeholder => 'user@example.com' },
    wrapper_class => ['form-group'],
);

has_field 'roles' => (
    type          => 'Select',
    label_column  => 'role',
    multiple      => 1,
    widget        => 'CheckboxGroup',
    element_class => ['form-control'],
    wrapper_class => ['form-group'],
);

has_field 'active' => (
    type          => 'Select',
    widget        => 'RadioGroup',
    options       => [ { value => 1, label => 'yes' }, { value => 0, label => 'no' } ],
    default       => 1,
    wrapper_class => ['form-group'],
);

has_field 'submit' => (
    type          => 'Submit',
    value         => 'Submit',
    element_class => [ 'btn', 'btn-primary' ],
);

__PACKAGE__->meta->make_immutable;
1;
