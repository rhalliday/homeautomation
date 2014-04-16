package HomeAutomation::Schema::ResultSet::Appliance;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

our $VERSION = '0.01';

=head2 all_appliances

Returns a list of all the appliances ordered by room.

=cut

sub all_appliances {
    my ($self) = @_;

    return $self->search({ device => { q{!=} => undef, }, }, { order_by => q{room_id} });
}

=head2 appliances_in_room

Returns a list of all the appliances in the specified room.

=cut

sub appliances_in_room {
    my ($self, $room) = @_;

    return $self->search({ q{room.name} => $room }, { join => q{room} });
}

=head2 next_appliance

Returns the next available appliance, undef if there isn't one

=cut

sub next_appliance {
    my ($self) = @_;

    return $self->search({ device => undef, })->first || undef;
}

1;
