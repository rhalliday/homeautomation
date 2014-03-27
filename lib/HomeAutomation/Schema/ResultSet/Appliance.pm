package HomeAutomation::Schema::ResultSet::Appliance;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

=head2 all_appliances

Returns a list of all the appliances ordered by room.

=cut

sub all_appliances {
    my ($self) = @_;

    return $self->search({ device => { '!=' => undef, }, }, { order_by => 'room_id' });
}

=head2 appliances_in_room

Returns a list of all the appliances in the specified room.

=cut

sub appliances_in_room {
    my ($self, $room) = @_;

    return $self->search( { 'room.name' => $room}, { join => 'room' });
}

=head2 next_appliance

Returns the next available appliance, undef if there isn't one

=cut

sub next_appliance {
    my ($self) = @_;

    return $self->search({ device => undef, })->first || undef;
}

1;
