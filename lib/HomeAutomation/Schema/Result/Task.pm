use utf8;
package HomeAutomation::Schema::Result::Task;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

HomeAutomation::Schema::Result::Task

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::TimeStamp>

=item * L<DBIx::Class::PassphraseColumn>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "PassphraseColumn");

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

=head2 expires

  data_type: 'timestamp'
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
  "expires",
  { data_type => "timestamp", is_nullable => 1 },
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

=head2 tasks_days

Type: has_many

Related object: L<HomeAutomation::Schema::Result::TasksDay>

=cut

__PACKAGE__->has_many(
  "tasks_days",
  "HomeAutomation::Schema::Result::TasksDay",
  { "foreign.task_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 days

Type: many_to_many

Composing rels: L</tasks_days> -> day

=cut

__PACKAGE__->many_to_many("days", "tasks_days", "day");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2014-03-17 20:45:34
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/pHo0iAKD1SLWRgQSJi8Aw


# You can replace this text with custom code or comments, and it will be preserved on regeneration

=head1 delete_allowed_by

Can the specified user delete the current task?

=cut

sub delete_allowed_by {
    my ($self, $user) = @_;

    # Only allow delete if user has 'schedule' role
    return $user->has_role('schedule');
}

=head1 all_days

Returns a comma separated list of days

=cut

sub all_days {
    my ($self) = @_;

    my @days;
    for my $day ($self->days) {
        push @days, $day->day;
    }
    return join ', ', @days;
}

__PACKAGE__->meta->make_immutable;
1;
