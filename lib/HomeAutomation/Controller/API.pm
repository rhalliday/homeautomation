package HomeAutomation::Controller::API;
use Moose;
use namespace::autoclean;

use HomeAutomation::Form::Appliance;
use Readonly;
use Try::Tiny;

Readonly::Scalar my $DEFAULT_ROOM => 'Lounge';

BEGIN { extends 'Catalyst::Controller'; }

our $VERSION = '0.01';

=head1 NAME

HomeAutomation::Controller::API - API endpoint

=head1 DESCRIPTION

Catalyst Controller to enable programs to connect to the app.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Chained('/') : Path : Args(0) : NoAuth {
    my ($self, $c) = @_;

    $c->stash->{json_data} = $self->_api($c);
    $c->forward('View::JSON');
    return 1;
}

sub _api {
    my ($self, $c) = @_;

    # return early if not a post
    return { message => q{Invalid method} } unless $c->req->method eq 'POST';

    my ($user, $pass) = $c->req->headers->authorization_basic;

    return { message => q{Invalid user} } unless $user && $pass;

    chomp $pass;
    return { message => q{Invalid user} } unless $c->authenticate(
        {
            username => $user,
            password => $pass
        }
    );
    return { message => q{Invalid user} } unless $c->user->active;

    my $json;

    # we don't want to raise an exception yet if the body data is bad, we'll just inform the user with a message
    try {
        $json = $c->req->body_data;
    };

    return { message => q{Invalid body request} } unless $json and exists $json->{scene};

    my $scene_rs = $c->model('DB::Scene');

    # if we've been passed text then perform a fuzzy match and return the scene name and id
    if ($json->{scene} !~ /^\d+$/) {
        my $scenes = $scene_rs->fuzzy_match($json->{scene});

        if (scalar @{$scenes}) {
            my $return = { scenes => [] };
            for my $scene (@{$scenes}) {
                push @{ $return->{scenes} }, { scene => $scene->name, scene_id => $scene->scene_id };
            }
            return $return;
        }
        return { message => q{Failed to find scene } . $json->{scene} };
    }

    # if it's an id then we find the scene and run it, returning the message
    my $scene_id = $json->{scene} + 0;
    my $scene    = $scene_rs->find($scene_id);
    if ($scene) {
        $scene->run;
        return { message => $scene->name . q{ has been run} };
    }

    return { message => q{Failed to find scene } . $json->{scene} };
}

=head1 AUTHOR

Rob Halliday,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
