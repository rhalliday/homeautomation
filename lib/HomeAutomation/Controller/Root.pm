package HomeAutomation::Controller::Root;
use Moose;
use namespace::autoclean;

use Readonly;

BEGIN { extends 'Catalyst::Controller' }

our $VERSION = '0.01';

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in HomeAutomation.pm
#
__PACKAGE__->config(namespace => q{});

Readonly::Hash my %ERROR_CODES => (not_found => 404,);

=head1 NAME

HomeAutomation::Controller::Root - Root Controller for HomeAutomation

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index : Path : Args(0) {
    my ($self, $c) = @_;

    # redirect to the appliances list page
    $c->response->redirect($c->uri_for('/appliances/list'));

    return 1;
}

=head2 default

Standard 404 error page

=cut

sub default : Path {
    my ($self, $c) = @_;
    $c->response->body('Page not found');
    $c->response->status($ERROR_CODES{not_found});

    return 1;
}

=head2 auto

Check if there is a user and, if not, forward to login page

=cut

sub auto : Private {
    my ($self, $c) = @_;

    if ($c->controller eq $c->controller('Login')) {
        return 1;
    }

    # If a user doesn't exist, force login
    if (!$c->user_exists) {

        $c->flash->{redirect_after_login} = '' . $c->req->uri;

        # Redirect the user to the login page
        $c->response->redirect($c->uri_for('/login'));

        # Return 0 to cancel 'post-auto' processing and prevent use of application
        return 0;
    }

    # User found, so return 1 to continue with processing after this 'auto'
    return 1;
}

=head2 error_noperms

Permissions error screen

=cut

sub error_noperms : Chained('/') : PathPart('error_noperms') : Args(0) {
    my ($self, $c) = @_;

    $c->stash(template => 'error_noperms.tt2');

    return 1;
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') { return 1; }

=head1 AUTHOR

Rob Halliday,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
