package HomeAutomation::Controller::Appliances;
use Moose;
use namespace::autoclean;

use HomeAutomation::Form::Appliance;

BEGIN { extends 'Catalyst::Controller'; }

our $VERSION = '0.01';

=head1 NAME

HomeAutomation::Controller::Appliances - Control appliances

=head1 DESCRIPTION

Catalyst Controller for CRUD of appliances.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path : Args(0) {
    my ($self, $c) = @_;

    $c->response->redirect(q{/appliances/list});

    return 1;
}

=head2 base

The start of our chained methods

=cut

sub base : Chained('/') : PathPart('appliances') : CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash(resultset => $c->model('DB::Appliance'));

    $c->load_status_msgs;

    return 1;
}

=head2 object
    
Fetch the specified appliance object based on the appliance address and store
it in the stash
    
=cut

sub object : Chained('base') : PathPart('address') : CaptureArgs(1) {
    my ($self, $c, $address) = @_;

    # Find the book object and store it in the stash
    my $object = $c->stash->{resultset}->find({ address => $address });
    $c->detach('/default') if !$object;

    $c->stash(
        object => $object,
        selected_room => $object->room ? $object->room->name : q{},
    );

    return 1;
}

=head2 list

Display all the appliances

=cut

sub list : Chained('base') : PathParth('list') : Args(0) {
    my ($self, $c) = @_;

    my $room = $c->req->param('room') || 'Lounge';

    $c->stash(
        rooms         => [ $c->model('DB::Room')->all ],
        selected_room => $room,
        appliances    => [ $c->stash->{resultset}->appliances_in_room($room)->all ],
        template      => 'appliances/list.tt2',
    );

    return 1;
}

=head2 create

Create a new appliance

=cut

sub create : Chained('base') : PathPart('create') : Args(0) {
    my ($self, $c) = @_;

    my $appliance = $c->stash->{resultset}->next_appliance;
    my $room_name = $c->req->param('selected_room') || 'Lounge';
    my $room      = $c->model('DB::Room')->search({ name => $room_name })->first;

    $c->detach('/default') unless $appliance;

    # set some defaults
    $appliance->update(
        { status => 1, protocol => 'pl', on_button_text => 'On', off_button_text => 'Off', room_id => $room->id });

    $c->stash->{object} = $appliance;

    return $self->form($c, $appliance);
}

=head2 edit

Edit an existing appliance with  FormHandler

=cut

sub edit : Chained('object') PathPart('edit') Args(0) {
    my ($self, $c) = @_;

    return $self->form($c, $c->stash->{object});
}

=head2 form

Process the FormHandler appliance form

=cut

sub form {
    my ($self, $c, $appliance) = @_;

    my $form = HomeAutomation::Form::Appliance->new;

    # Set the template
    $c->stash(template => 'appliances/form.tt2', form => $form);
    $form->process(item => $appliance, params => $c->req->body_params);
    return unless $form->validated;

    # Set a status message for the user & return to books list
    $c->response->redirect(
        $c->uri_for(
            $self->action_for('list'),
            { room => $appliance->room->name, mid => $c->set_status_msg('Appliance created') }
        )
    );

    return 1;
}

=head2 delete
    
Delete an appliance

=cut

sub delete : Chained('object') : PathPart('delete') : Args(0) {
    my ($self, $c) = @_;

    # Check permissions
    $c->detach('/error_noperms')
      unless $c->stash->{object}->delete_allowed_by($c->user->get_object);

    my $id = $c->stash->{object}->address;

    $c->stash->{object}->clear;

    # Redirect to the list action/method in this controller
    $c->response->redirect(
        $c->uri_for(
            $self->action_for('list'),
            { room => $c->stash->{selected_room}, mid => $c->set_status_msg("Deleted appliance $id") }
        )
    );

    return 1;
}

=head2 switch

Change the status of the appliance.

=cut

sub switch : Chained('object') : PathPart('switch') : Args(0) {
    my ($self, $c) = @_;

    $c->stash->{object}->switch;

    # Redirect to the list action/method in this controller
    $c->response->redirect($c->uri_for($self->action_for('list'), { room => $c->stash->{selected_room} }));

    return 1;
}

=head2 dim

Change the dim setting of a dimmable device.

=cut

sub dim : Chained('object') : PathPart('dim') : Args(1) {
    my ($self, $c, $dim) = @_;

    $c->stash->{object}->dim($dim);

    # Redirect to the list
    $c->response->redirect($c->uri_for($self->action_for('list'), { room => $c->stash->{selected_room} }));

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
