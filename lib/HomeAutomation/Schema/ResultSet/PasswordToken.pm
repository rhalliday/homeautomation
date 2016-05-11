package HomeAutomation::Schema::ResultSet::PasswordToken;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

use DateTime;

our $VERSION = '0.01';

=head2 validate_token($token, $user_id)

Returns a resultset searching for a token and user_id within the timeframe.

=cut

sub validate_token {
    my ($self, $token, $user_id) = @_;

    return $self->search(
        {
            token   => $token,
            user_id => $user_id,

            # make sure the token hasn't been active
            timestamp => {
                q{>} => \q{datetime('now','-1 hours')},
            },

            # make sure the token hasn't already been used
            active => 1,
        }
    );
}

1;
