package HomeAutomation::Schema::ResultSet::Task;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

use DateTime;

our $VERSION = '0.01';

=head2 Methods

=over

=item scheduled_tasks($start, $end)

Returns a list of all the tasks that will occur between $start and $end,
where $start and $end is the epoch.

=cut

sub scheduled_tasks {
    my ($self, $start, $end) = @_;

    my $dt_start = DateTime->from_epoch(epoch => $start, time_zone => q{Europe/London})->ymd;
    my $dt_end   = DateTime->from_epoch(epoch => $end,   time_zone => q{Europe/London})->ymd;
    return $self->search(
        {
            -or => [
                day => { -between => [ $dt_start, $dt_end ] },
                'recurrence.expires' => [ { '>=' => $dt_start }, { '=' => undef } ],
            ]
        },
        { join => 'recurrence' }
    );
}

=item active_tasks

Returns all the tasks that are due to start at this time.

=cut

sub active_tasks {
    my ($self) = @_;

    my $dt = DateTime->now(time_zone => q{Europe/London});
    my $time = sprintf('%02d:%02d', $dt->hour, $dt->minute);

    return $self->search(
        {
            time => $time,
            -or  => [
                day  => $dt->ymd,
                -and => [
                    'recurrence.expires' => { '>=' => $dt->ymd },
                    'tasks_days.day_id'  => $dt->dow,
                ],
            ],
        },
        { join => { recurrence => 'tasks_days' } }
    );
}

=back

=cut

1;
