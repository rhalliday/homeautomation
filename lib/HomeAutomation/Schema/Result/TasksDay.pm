use utf8;
package HomeAutomation::Schema::Result::TasksDay;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

HomeAutomation::Schema::Result::TasksDay

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

=head1 TABLE: C<tasks_day>

=cut

__PACKAGE__->table("tasks_day");

=head1 ACCESSORS

=head2 task_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 day_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "task_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "day_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</task_id>

=item * L</day_id>

=back

=cut

__PACKAGE__->set_primary_key("task_id", "day_id");

=head1 RELATIONS

=head2 day

Type: belongs_to

Related object: L<HomeAutomation::Schema::Result::Day>

=cut

__PACKAGE__->belongs_to(
  "day",
  "HomeAutomation::Schema::Result::Day",
  { id => "day_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 task

Type: belongs_to

Related object: L<HomeAutomation::Schema::Result::Task>

=cut

__PACKAGE__->belongs_to(
  "task",
  "HomeAutomation::Schema::Result::Task",
  { id => "task_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2014-03-14 14:13:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XVn0MDikOA06oCkyT4/B6g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
