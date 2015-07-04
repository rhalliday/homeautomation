package HomeAutomation::Controller::Rooms;
use Moose;
use namespace::autoclean;

use HomeAutomation::Form::Room;

BEGIN { extends 'Catalyst::Controller'; }

our $VERSION = '0.01';

=head1 NAME

HomeAutomation::Controller::Rooms - Control rooms

=head1 DESCRIPTION

Catalyst Controller for CRUD of rooms.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path : Args(0) {
    my ($self, $c) = @_;

    $c->response->redirect(q{/rooms/list});

    return 1;
}

=head2 base

The start of our chained methods

=cut

sub base : Chained('/') : PathPart('rooms') : CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash(resultset => $c->model('DB::Room'));

    $c->load_status_msgs;

    return 1;
}

=head2 object
    
Fetch the specified room object based on the room id and store
it in the stash
    
=cut

sub object : Chained('base') : PathPart('') : CaptureArgs(1) {
    my ($self, $c, $room_id) = @_;

    # Find the room object and store it in the stash
    my $object = $c->stash->{resultset}->find($room_id);
    $c->detach('/default') if !$object;

    $c->stash(
        object => $object,
    );

    return 1;
}

=head2 list

Display all the rooms

=cut

sub list : Chained('base') : PathParth('list') : Args(0) {
    my ($self, $c) = @_;

    my $room = $c->req->param('room') || 'Lounge';

    $c->stash(
        rooms         => [ $c->stash->{resultset}->all ],
        template      => 'rooms/list.tt2',
    );

    return 1;
}

=head2 create

Create a new room

=cut

sub create : Chained('base') : PathPart('create') : Args(0) {
    my ($self, $c) = @_;

    my $room = $c->stash->{resultset}->new_result({});

    $c->detach('/default') unless $room;

    $c->stash->{object} = $room;

    return $self->form($c, $room);
}

=head2 edit

Edit an existing room

=cut

sub edit : Chained('object') PathPart('edit') Args(0) {
    my ($self, $c) = @_;

    return $self->form($c, $c->stash->{object});
}

=head2 form

Process the room form

=cut

sub form {
    my ($self, $c, $room) = @_;

    my $form = HomeAutomation::Form::Room->new;

    # Set the template
    $c->stash(template => 'rooms/form.tt2', form => $form);
    $form->process(item => $room, params => $c->req->body_params);
    return unless $form->validated;

    # Set a status message for the user & return to rooms list
    $c->response->redirect(
        $c->uri_for(
            $self->action_for('list'),
            { mid => $c->set_status_msg($room->name . ' created/updated') }
        )
    );

    return 1;
}

=head2 delete
    
Delete a room

=cut

sub delete : Chained('object') : PathPart('delete') : Args(0) {
    my ($self, $c) = @_;

    # Check permissions
    $c->detach('/error_noperms')
      unless $c->stash->{object}->delete_allowed_by($c->user->get_object);

    my $room = $c->stash->{object}->name;

    $c->stash->{object}->delete;

    # Redirect to the list action/method in this controller
    $c->response->redirect(
        $c->uri_for(
            $self->action_for('list'),
            { mid => $c->set_status_msg("Deleted appliance $room") }
        )
    );

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
