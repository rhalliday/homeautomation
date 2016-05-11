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

    $c->response->redirect(q{/usermanagement/list});

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

=head2 reset_password /usermanagement/reset_password/$user_id/$token

Makes sure that the token is valid for the user, if it is display a form
letting them change their password.

=cut

sub reset_password : Chained('base') : PathPart('reset_password') : Args(2) : NoAuth {
    my ($self, $c, $user_id, $token) = @_;

    my $token_rs = $c->model('DB::PasswordToken');

    # send user to the change password form if the token is valid
    if (my $reset_token = $token_rs->validate_token($token, $user_id)->single) {
        return $self->change_form($c, $reset_token->user, $reset_token);
    }

    # otherwise error
    return $c->detach('/default');
}

=head2 forgot_password /usermanagement/forgot_password

Displays a form for a user to enter their username or password.
Sends an email with the reset_password link.

=cut

sub forgot_password : Chained('base') : PathPart('forgot_password') : Args(0) : NoAuth {
    my ($self, $c) = @_;

    # if we were posted the user
    if (my $username = scalar $c->request->body_parameters->{username}) {

        # bang this into the user resultset to get a user, it could be a username or
        # email address
        my $user = $c->stash->{resultset}->username_or_email($username)->single;
        $user->forgot_password($c);
        $c->response->redirect(
            $c->uri_for('/login', { mid => $c->set_status_msg(q{Please follow the instructions in the email}) }));
    }
    $c->stash(template => 'usermanagement/forgot_password.tt2');
    return 1;
}

=head2 change_form

Process the FormHandler change password form

=cut

sub change_form {
    my ($self, $c, $user, $reset) = @_;

    my $form = HomeAutomation::Form::ChangePassword->new(user => $user);

    # Set the template
    $c->stash(template => 'usermanagement/change_form.tt2', form => $form);

    my %process_args = (posted => ($c->req->method eq 'POST'), params => $c->req->params, no_update => 1,);
    $process_args{inactive} = [q{current_password}] if $reset;

    return unless $form->process(%process_args);

    # if this is not a reset password form then check that the user has entered the current password
    unless ($reset
        or $c->authenticate({ username => $c->user->username, password => $c->req->param('current_password') }))
    {
        $form->field('current_password')->add_error('incorrect password');
        return;
    }

    # update the password
    $user->update({ password => $form->field('new_password')->value });

    if ($reset) {

        # deactivate the token
        $reset->update({ active => 0 });

        # redirect to login
        $c->response->redirect($c->uri_for('/login', { mid => $c->set_status_msg(q{Password Changed}) }));
    } else {
        $c->user->persist_user();

        # Set a status message for the user & return to appliances list
        $c->response->redirect($c->uri_for('/appliances/list', { mid => $c->set_status_msg(q{Password Changed}) }));
    }

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
