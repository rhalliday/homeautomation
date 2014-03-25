package HomeAutomation::Schema::ResultSet::Task;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

use DateTime;

=head2 scheduled_tasks($start, $end)

Returns a list of all the tasks that will occur between $start and $end,
where $start and $end is the epoch.

=cut

sub scheduled_tasks {
    my ($self, $start, $end) = @_;

    my $dt_start = DateTime->from_epoch(epoch => $start, time_zone => 'Europe/London')->ymd;
    my $dt_end   = DateTime->from_epoch(epoch => $end,   time_zone => 'Europe/London')->ymd;
    return $self->search(
        {
            -or => [
                day                  => { -between => [ $dt_start, $dt_end ] },
                'recurrence.expires' => { '>='     => $dt_start },
            ]
        },
        { join => 'recurrence' }
    );
}

1;
