package HomeAutomation::Schema::Result::Task;
use utf8;

=head1 NAME

HomeAutomation::Schema::Result::Task

=cut

use strict;
use warnings;

=head1 BASE CLASS: L<Schema::Base|HomeAutomation::Schema::Base>

=cut

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'HomeAutomation::Schema::Base';

use DateTime;

our $VERSION = q{0.01};

=head1 COMPONENTS LOADED

=over 4

=item * L<DateTime|DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components(q{InflateColumn::DateTime});

=head1 TABLE: C<tasks>

=cut

__PACKAGE__->table(q{tasks});

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

=head2 scene_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
    q{id}, { data_type => q{integer}, is_auto_increment => 1, is_nullable => 0 },
    q{appliance}, { data_type => q{varchar}, is_foreign_key => 1, is_nullable => 1, size => 3 },
    q{action},        { data_type => q{text},    is_nullable    => 1 },
    q{time},          { data_type => q{text},    is_nullable    => 1 },
    q{recurrence_id}, { data_type => q{integer}, is_foreign_key => 1, is_nullable => 1 },
    q{day},           { data_type => q{date},    is_nullable    => 1 },
    q{scene_id},      { data_type => q{integer}, is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key(q{id});

=head1 RELATIONS

=head2 appliance

Type: belongs_to

Related object: L<Appliance|HomeAutomation::Schema::Result::Appliance>

=cut

__PACKAGE__->belongs_to(
    q{appliance},
    q{HomeAutomation::Schema::Result::Appliance},
    { address => q{appliance} },
    {
        is_deferrable => 0,
        join_type     => q{LEFT},
        on_delete     => q{CASCADE},
        on_update     => q{CASCADE},
    },
);

=head2 scene

Type: belongs_to

Related object: L<Scene|HomeAutomation::Schema::Result::Scene>

=cut

__PACKAGE__->belongs_to(
    q{scene},
    q{HomeAutomation::Schema::Result::Scene},
    { scene_id => q{scene_id} },
    {
        is_deferrable => 0,
        join_type     => q{LEFT},
        on_delete     => q{CASCADE},
        on_update     => q{CASCADE},
    },
);

=head2 recurrence

Type: belongs_to

Related object: L<Recurrence|HomeAutomation::Schema::Result::Recurrence>

=cut

__PACKAGE__->belongs_to(
    q{recurrence},
    q{HomeAutomation::Schema::Result::Recurrence},
    { id => q{recurrence_id} },
    {
        is_deferrable => 0,
        join_type     => q{LEFT},
        on_delete     => q{NO ACTION},
        on_update     => q{NO ACTION},
    },
);

=head2 recurrences

Type: has_many

Related object: L<Recurrence|HomeAutomation::Schema::Result::Recurrence>

=cut

__PACKAGE__->has_many(
    q{recurrences}, q{HomeAutomation::Schema::Result::Recurrence},
    { q{foreign.task_id} => q{self.id} }, { cascade_copy => 0, cascade_delete => 0 },
);

# You can replace this text with custom code or comments, and it will be preserved on regeneration

=head1 Methods

=over

=item delete_allowed_by

Can the specified user delete the current task?

=cut

sub delete_allowed_by {
    my ($self, $user) = @_;

    # Only allow delete if user has 'schedule' role
    return $user->has_role(q{schedule});
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
    return join q{, }, @days;
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
    my ($self, $url, $start, $end) = @_;

    my @data;

    # set up a title
    my $action = $self->action . q{_button_text}
        if $self->action;

    my $title =
        $self->appliance
      ? $self->time . q{: } . $self->appliance->device . q{ } . $self->appliance->$action
      : $self->time . q{: } . $self->scene->name;

    # if it's a task that is for a specific date
    if ($self->day) {

        # just add the relevant data to the arrayref
        # make a ISO 8601 by substituting the time into the value returned for day
        my $time        = $self->day;
        my $time_string = $self->time;
        $time =~ s/00:00/$time_string/;
        $time .= q{Z};
        my $result_hash = $self->_get_result_hash({ title => $title, start => $time, url => $url });
        push @data, $result_hash;
    } else {

        # otherwise it's a recurring schedule so figure out the days
        my $dt     = DateTime->from_epoch(epoch => $start, time_zone => q{Europe/London});
        my $dt_end = DateTime->from_epoch(epoch => $end,   time_zone => q{Europe/London});

        my %days = map { $_->id => 1 } $self->recurrence->days->all;

        # go through the days adding them to the calendar data until it expires
        while ((!$self->recurrence->expires || $dt < $self->recurrence->expires) && $dt < $dt_end) {
            if (exists $days{ $dt->dow }) {
                my $time = $dt->ymd . q{T} . $self->time . q{:00Z};
                my $result_hash = $self->_get_result_hash({ title => $title, start => $time, url => $url });
                push @data, $result_hash;
            }
            $dt = $dt->add(days => 1);
        }
    }

    return \@data;
}

sub _get_result_hash {
    my ($self, $result_hash) = @_;

    if ($self->appliance && $self->appliance->colour) {
        $result_hash->{backgroundColor} = $self->appliance->colour;
        $result_hash->{textColor}       = $self->appliance->text_colour;
    }
    return $result_hash;
}

=back

=cut

__PACKAGE__->meta->make_immutable;
1;
