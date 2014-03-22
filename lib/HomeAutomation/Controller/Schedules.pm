package HomeAutomation::Controller::Schedules;
use Moose;
use namespace::autoclean;

use HomeAutomation::Form::Schedule;

BEGIN { extends 'Catalyst::Controller'; }

our $VERSION = '0.01';

=head1 NAME

HomeAutomation::Controller::Schedules - Set up schedules for appliance actions

=head1 DESCRIPTION

Catalyst Controller for CRUD of schedules.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path : Args(0) {
    my ($self, $c) = @_;

    $c->response->body('Matched HomeAutomation::Controller::Schedules in Schedules.');

    return 1;
}

=head2 base

The start of our chained methods

=cut

sub base : Chained('/') : PathPart('schedules') : CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash(resultset => $c->model('DB::Task'));

    $c->load_status_msgs;

    return 1;
}

=head2 object
    
Fetch the specified schedule object based on the task id and store
it in the stash
    
=cut

sub object : Chained('base') : PathPart('id') : CaptureArgs(1) {
    my ($self, $c, $id) = @_;

    $c->detach('/error_noperms')
        unless $c->check_user_roles('schedule');
    # Find the task object and store it in the stash
    $c->stash(object => $c->stash->{resultset}->find($id));

    $c->detach('/default') if !$c->stash->{object};

    return 1;
}

=head2 list

Display all the tasks (will need to make this an API for a calendar)

=cut

sub list : Chained('base') : PathPart('list') : Args(0) {
    my ($self, $c) = @_;

    $c->stash(tasks => [ $c->stash->{resultset}->all ]);

    $c->stash(template => 'schedule/list.tt2');

    return 1;
}

=head2 create

Create a new schedule

=cut

sub create : Chained('base') : PathPart('create') : Args(1) {
    my ($self, $c, $appliance_id) = @_;

    my $schedule = $c->stash->{resultset}->new_result({ appliance => $appliance_id});

    $c->detach('/default') unless $schedule;

    $c->stash->{object} = $schedule;

    return $self->form($c, $schedule);
}

=head2 edit

Edit an existing schedule with  FormHandler

=cut

sub edit : Chained('object') PathPart('edit') Args(0) {
    my ($self, $c) = @_;

    return $self->form($c, $c->stash->{object});
}

=head2 form

Process the FormHandler appliance form

=cut

sub form {
    my ($self, $c, $schedule) = @_;

    my $form = HomeAutomation::Form::Schedule->new;

    # Set the template
    $c->stash(template => 'schedule/form.tt2', form => $form);
    $form->process(item => $schedule, params => $c->req->params);
    return unless $form->validated;

    # Set a status message for the user & return to books list
    $c->response->redirect($c->uri_for($self->action_for('list'), { mid => $c->set_status_msg('Schedule created') }));

    return 1;
}

=head2 delete
    
Delete a schedule

=cut

sub delete : Chained('object') : PathPart('delete') : Args(0) {
    my ($self, $c) = @_;

    my $id = $c->stash->{object}->id;

    $c->stash->{object}->delete;

    # Redirect to the list action/method in this controller
    $c->response->redirect(
        $c->uri_for($self->action_for('list'), { mid => $c->set_status_msg("Deleted schedule $id") }));

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
