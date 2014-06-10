use utf8;
package HomeAutomation::Schema::Result::Task;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

HomeAutomation::Schema::Result::Task

=cut

use strict;
use warnings;

=head1 BASE CLASS: L<HomeAutomation::Schema::Base>

=cut

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'HomeAutomation::Schema::Base';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<tasks>

=cut

__PACKAGE__->table("tasks");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 appliance

  data_type: 'varchar'
  is_foreign_key: 1
  is_nullable: 1
  size: 3

=head2 action

  data_type: 'text'
  is_nullable: 1

=head2 time

  data_type: 'text'
  is_nullable: 1

=head2 recurrence_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 day

  data_type: 'date'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "appliance",
  { data_type => "varchar", is_foreign_key => 1, is_nullable => 1, size => 3 },
  "action",
  { data_type => "text", is_nullable => 1 },
  "time",
  { data_type => "text", is_nullable => 1 },
  "recurrence_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "day",
  { data_type => "date", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 appliance

Type: belongs_to

Related object: L<HomeAutomation::Schema::Result::Appliance>

=cut

__PACKAGE__->belongs_to(
  "appliance",
  "HomeAutomation::Schema::Result::Appliance",
  { address => "appliance" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 recurrence

Type: belongs_to

Related object: L<HomeAutomation::Schema::Result::Recurrence>

=cut

__PACKAGE__->belongs_to(
  "recurrence",
  "HomeAutomation::Schema::Result::Recurrence",
  { id => "recurrence_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 recurrences

Type: has_many

Related object: L<HomeAutomation::Schema::Result::Recurrence>

=cut

__PACKAGE__->has_many(
  "recurrences",
  "HomeAutomation::Schema::Result::Recurrence",
  { "foreign.task_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-06-10 23:32:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:uzmtNsU9TawCE1oV1DCwUA

use DateTime;

# You can replace this text with custom code or comments, and it will be preserved on regeneration

=head1 Methods

=over

=item delete_allowed_by

Can the specified user delete the current task?

=cut

sub delete_allowed_by {
    my ($self, $user) = @_;

    # Only allow delete if user has 'schedule' role
    return $user->has_role('schedule');
}

=item all_days

Returns a comma separated list of days

=cut

sub all_days {
    my ($self) = @_;

    return q{} unless $self->recurrence_id;
    my @days;
    for my $day ($self->recurrence->days) {
        push @days, $day->day;
    }
    return join ', ', @days;
}

=item recurrence_expiry

Returns the expiry date of a recurrence, if there is one.

=cut

sub recurrence_expiry {
    my ($self) = @_;

    return q{} unless $self->recurrence_id;
    return $self->recurrence->expires;
}

=item full_calendar(context, start, end)

Returns an arrayref containing a hashref of all the dates
that fall within the start and end date.

=cut

sub full_calendar {
    my($self, $url, $start, $end) = @_;

    my @data;

    # set up a title
    my $action = $self->action . q{_button_text};
    my $title = $self->time . q{: } . $self->appliance->device . q{ } . $self->appliance->$action;

    # if it's a task that is for a specific date
    if($self->day) {
        # just add the relevant data to the arrayref
        # make a ISO 8601 by substituting the time into the value returned for day
        my $time = $self->day;
        my $time_string = $self->time;
        $time =~ s/00:00/$time_string/;
        $time .= q{Z};
        my $result_hash = {title => $title, start => $time, url => $url};
        if( $self->appliance->colour ) {
            $result_hash->{backgroundColor} = $self->appliance->colour;
            $result_hash->{textColor} = $self->appliance->text_colour;
        }
        push @data, $result_hash;
    } else {

        # otherwise it's a recurring schedule so figure out the days
        my $dt = DateTime->from_epoch(epoch => $start, time_zone => 'Europe/London');
        my $dt_end = DateTime->from_epoch(epoch => $end, time_zone => 'Europe/London');

        my %days = map { $_->id => 1 } $self->recurrence->days->all;

        # go through the days adding them to the calendar data until it expires
        while( (!$self->recurrence->expires || $dt < $self->recurrence->expires) && $dt < $dt_end ) {
            if(exists $days{$dt->dow}) {
                my $time = $dt->ymd . q{T} . $self->time . q{:00Z};
                my $result_hash = {title => $title, start => $time, url => $url};
                if( $self->appliance->colour ) {
                    $result_hash->{backgroundColor} = $self->appliance->colour;
                    $result_hash->{textColor} = $self->appliance->text_colour;
                }
                push @data, $result_hash;
            }
            $dt = $dt->add( days => 1 );
        }
    }

    return \@data;
}

=back

=cut

__PACKAGE__->meta->make_immutable;
1;
