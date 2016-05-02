package HomeAutomation::Schema::ResultSet::User;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

our $VERSION = '0.01';

=head2 username_or_email($username)

Returns a resultset searching for a username or email address.

=cut

sub username_or_email {
    my ($self, $username) = @_;

    return $self->search({ -or => { username => $username, email_address => $username, }, });
}

1;
