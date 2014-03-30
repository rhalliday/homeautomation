package HomeAutomation::Controller::UserManagement;
use Moose;
use namespace::autoclean;

use HomeAutomation::Form::User;
use HomeAutomation::Form::ChangePassword;

BEGIN { extends 'Catalyst::Controller'; }

our $VERSION = '0.01';

=head1 NAME

HomeAutomation::Controller::UserManagement - Catalyst Controller for managing users of the application

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path : Args(0) {
    my ($self, $c) = @_;

    $c->response->body('Matched HomeAutomation::Controller::UserManagement in UserManagement.');

    return 1;
}

=head2 base

The start of our chained methods

=cut

sub base : Chained('/') : PathPart('usermanagement') : CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash(resultset => $c->model('DB::User'));

    $c->load_status_msgs;

    return 1;
}

=head2 object
    
Fetch the specified user object based on the user id and store
it in the stash
    
=cut

sub object : Chained('base') : PathPart('id') : CaptureArgs(1) {
    my ($self, $c, $id) = @_;

    # Find the user object and store it in the stash
    $c->stash(object => $c->stash->{resultset}->find({ id => $id }));

    $c->detach('/default') if !$c->stash->{object};

    return 1;
}

=head2 list

Display all the users

=cut

sub list : Chained('base') : PathParth('list') : Args(0) {
    my ($self, $c) = @_;

    $c->stash(users => [ $c->stash->{resultset}->all ]);

    $c->stash(template => 'usermanagement/list.tt2');

    return 1;
}

=head2 create

Create a new user

=cut

sub create : Chained('base') : PathPart('create') : Args(0) {
    my ($self, $c) = @_;

    my $user = $c->stash->{resultset}->new_result({});

    $c->stash->{object} = $user;

    return $self->form($c, $user);
}

=head2 edit

Edit an existing user with FormHandler

=cut

sub edit : Chained('object') PathPart('edit') Args(0) {
    my ($self, $c) = @_;

    return $self->form($c, $c->stash->{object});
}

=head2 form

Process the FormHandler user form

=cut

sub form {
    my ($self, $c, $user) = @_;

    my $form = HomeAutomation::Form::User->new;

    # Set the template
    $c->stash(template => 'usermanagement/form.tt2', form => $form);
    $form->process(item => $user, params => $c->req->params);
    return unless $form->validated;

    # Set a status message for the user & return to books list
    $c->response->redirect($c->uri_for($self->action_for('list'), { mid => $c->set_status_msg('User created') }));

    return 1;
}

=head2 delete

Delete a user

=cut

sub delete : Chained('object') : PathPart('delete') : Args(0) {
    my ($self, $c) = @_;

    # Check permissions
    $c->detach('/error_noperms')
      unless $c->stash->{object}->delete_allowed_by($c->user->get_object);

    my $name = $c->stash->{object}->full_name;

    $c->stash->{object}->delete;

    # Redirect to the list action/method in this controller
    $c->response->redirect(
        $c->uri_for($self->action_for('list'), { mid => $c->set_status_msg("Deleted user: $name") }));

    return 1;
}

=head2 deactivate

Deactivate a user

=cut

sub deactivate : Chained('object') : PathPart('deactivate') : Args(0) {
    my ($self, $c) = @_;

    # Check permissions
    $c->detach('/error_noperms')
      unless $c->stash->{object}->deactivate_allowed_by($c->user->get_object);

    my $name = $c->stash->{object}->full_name;

    $c->stash->{object}->deactivate();

    # Redirect to the list action/method in this controller
    $c->response->redirect($c->uri_for($self->action_for('list')));

    return 1;
}

=head2 change_password

Allows a user to change their password

=cut

sub change_password : Chained('base') : PathPart('change_password') : Args(0) {
    my ($self, $c) = @_;

    return $self->change_form($c, $c->user->get_object);
}

=head2 change_form

Process the FormHandler change password form

=cut

sub change_form {
    my ($self, $c, $user) = @_;

    my $form = HomeAutomation::Form::ChangePassword->new(user => $user);

    # Set the template
    $c->stash(template => 'usermanagement/change_form.tt2', form => $form);
    return unless $form->process(params => $c->req->params);

    # update the password
    $c->user->update({ password => $form->field('new_password')->value });

    # Set a status message for the user & return to appliances list
    $c->response->redirect($c->uri_for('/appliances/list', { mid => $c->set_status_msg(q{Password Changed}) }));

    return 1;
}

=head1 AUTHOR

Rob Halliday,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
