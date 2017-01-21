package HomeAutomation::Schema::ResultSet::Scene;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

use Text::Fuzzy;
use Readonly;

Readonly my $MAX_SCENES => 3;

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

    my $scene_rs = $self->search({});
    my @scene_scores;
    while (my $scene = $scene_rs->next) {
        push @scene_scores, [ $tf->distance(_normalise_string($scene->name)), $scene ];
    }

    my @ordered_scenes = map { $_->[1] } sort { $a->[0] <=> $b->[0] } @scene_scores;

    splice @ordered_scenes, $MAX_SCENES;

    return \@ordered_scenes;
}

sub _normalise_string {
    my ($string) = @_;

    # remove spaces
    $string =~ s/\s+//g;

    # return the lower cased version of the string
    return lc $string;
}

1;
