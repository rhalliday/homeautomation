package HomeAutomation::Controller::Scenes;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

our $VERSION = '0.01';

use HomeAutomation::Form::Scene;
use JSON qw/encode_json/;

=head1 NAME

HomeAutomation::Controller::Scenes - Set up scenes

=head1 DESCRIPTION

Catalyst Controller for CRUD of scenes.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path : Args(0) {
    my ($self, $c) = @_;

    $c->response->redirect(q{/scenes/list});

    return 1;
}

=head2 base

The start of our chained methods

=cut

sub base : Chained('/') : PathPart('scenes') : CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash(resultset => $c->model('DB::Scene'));

    $c->load_status_msgs;

    return 1;
}

=head2 object
    
Fetch the specified scene object based on the scene id and store
it in the stash
    
=cut

sub object : Chained('base') : PathPart('') : CaptureArgs(1) {
    my ($self, $c, $scene_id) = @_;

    # Find the scene object and store it in the stash
    my $object = $c->stash->{resultset}->find($scene_id);
    $c->detach('/default') if !$object;

    $c->stash(object => $object,);

    return 1;
}

=head2 list

Display all the scenes

=cut

sub list : Chained('base') : PathParth('list') : Args(0) {
    my ($self, $c) = @_;

    $c->stash(
        scenes   => [ $c->stash->{resultset}->all ],
        template => 'scenes/list.tt2',
    );

    return 1;
}

=head2 create

Create a new scene.

=cut

sub create : Chained('base') : PathPart('create') : Args(0) {
    my ($self, $c) = @_;

    my $scene = $c->stash->{resultset}->new_result({});

    $c->detach('/default') unless $scene;

    $c->stash->{object} = $scene;

    return $self->form($c, $scene);
}

=head2 edit

Edit an existing scene

=cut

sub edit : Chained('object') PathPart('edit') Args(0) {
    my ($self, $c) = @_;

    return $self->form($c, $c->stash->{object});
}

=head2 form

Process the scene form

=cut

sub form {
    my ($self, $c, $scene) = @_;

    my $form = HomeAutomation::Form::Scene->new;

    my @appliances =
      map { { address => $_->address, device => $_->device, dimable => $_->dimable, room => $_->room->name, } }
      $c->model('DB::Appliance')->all_appliances->all;

    my $appliance_json = encode_json \@appliances;

    # Set the template
    $c->stash(template => 'scenes/form.tt2', form => $form, appliance_json => $appliance_json);
    $form->process(item => $scene, params => $c->req->body_params);
    return unless $form->validated;

    # Set a status message for the user & return to scenes list
    $c->response->redirect(
        $c->uri_for($self->action_for('list'), { mid => $c->set_status_msg($scene->name . ' created/updated') }));

    return 1;
}

=head2 delete
    
Delete a scene

=cut

sub delete : Chained('object') : PathPart('delete') : Args(0) {
    my ($self, $c) = @_;

    # Check permissions
    $c->detach('/error_noperms')
      unless $c->stash->{object}->delete_allowed_by($c->user->get_object);

    my $scene = $c->stash->{object}->name;

    $c->stash->{object}->delete;

    # Redirect to the list action/method in this controller
    $c->response->redirect(
        $c->uri_for($self->action_for('list'), { mid => $c->set_status_msg("Deleted scene $scene") }));

    return 1;
}

=head2 run

Run a scene.

=cut

sub run : Chained('object') : PathPart('run') : Args(0) {
    my ($self, $c) = @_;

    $c->stash->{object}->run;

    $c->response->redirect(
        $c->uri_for_action('/appliances/list', { selected_room => $c->req->param('selected_room') }));

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
