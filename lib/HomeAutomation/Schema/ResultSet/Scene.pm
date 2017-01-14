package HomeAutomation::Schema::ResultSet::Scene;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

use Text::Fuzzy;

our $VERSION = '0.01';

=head2 scenes_in_room

Returns a list of all the scenes in the specified room.

=cut

sub scenes_in_room {
    my ($self, $room) = @_;

    return $self->search(
        {
            -or => [

                # anything that doesn't have a room id is valid for this room
                room_id => undef,

                # all the scenes with this room
                q{room.name} => $room
            ],
        },
        {
            join => q{room}
        }
    );
}

=head2 fuzzy_match($search)

Returns the scene that is closest to the input text

=cut

sub fuzzy_match {
    my ($self, $search) = @_;

    # normalise both the strings to make it more likely we get the right scene
    $search = _normalise_string($search);
    my $tf = Text::Fuzzy->new($search, trans => 1);

    # store the normalised name with the dbic row so we only make one trip to the db
    my %scenes = map { _normalise_string($_->name) => $_ } $self->search({})->all;
    my @scenes = keys %scenes;
    my $match  = $tf->nearestv(\@scenes);

    return $match ? $scenes{$match} : undef;
}

sub _normalise_string {
    my ($string) = @_;

    # remove spaces
    $string =~ s/\s+//g;

    # return the lower cased version of the string
    return lc $string;
}

1;
