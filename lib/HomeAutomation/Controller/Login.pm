package HomeAutomation::Controller::Login;
use Moose;
use namespace::autoclean;

BEGIN { extends q{Catalyst::Controller}; }

our $VERSION = q{0.01};

=head1 NAME

HomeAutomation::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

Login logic

=cut

sub index : Path : Args(0) {
    my ($self, $c) = @_;

    # Get the username and password from form
    my $username = $c->request->params->{username};
    my $password = $c->request->params->{password};

    # If the username and password values were found in form
    if ($username && $password) {

        # Attempt to log the user in
        if (
            $c->authenticate(
                {
                    username => $username,
                    password => $password
                }
            )
          )
        {
            # If successful, then let them use the application
            my $dest = $c->uri_for(q{/});
            $dest = $c->flash->{redirect_after_login} if $c->flash->{redirect_after_login};
            $c->response->redirect($dest);
            return;
        } else {

            # Set an error message
            $c->stash(error_msg => q{Bad username or password.});
        }
    }

    # If either of above don't work out, send to the login page
    $c->stash(template => q{login.tt2});

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
