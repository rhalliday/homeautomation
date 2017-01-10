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

    my $tf = Text::Fuzzy->new($search, trans => 1);
    my @scenes = map { $_->name } $self->search({}, { columns => [qw/name/] })->all;
    my $match = $tf->nearestv(\@scenes);
    return $self->search_rs({ name => $match })->first();
}

1;
