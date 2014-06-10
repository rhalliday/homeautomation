use utf8;
package HomeAutomation::Schema::Result::Recurrence;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

HomeAutomation::Schema::Result::Recurrence

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

=head1 TABLE: C<recurrence>

=cut

__PACKAGE__->table("recurrence");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 task_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 expires

  data_type: 'date'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "task_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "expires",
  { data_type => "date", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 task

Type: belongs_to

Related object: L<HomeAutomation::Schema::Result::Task>

=cut

__PACKAGE__->belongs_to(
  "task",
  "HomeAutomation::Schema::Result::Task",
  { id => "task_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 tasks

Type: has_many

Related object: L<HomeAutomation::Schema::Result::Task>

=cut

__PACKAGE__->has_many(
  "tasks",
  "HomeAutomation::Schema::Result::Task",
  { "foreign.recurrence_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 tasks_days

Type: has_many

Related object: L<HomeAutomation::Schema::Result::TasksDay>

=cut

__PACKAGE__->has_many(
  "tasks_days",
  "HomeAutomation::Schema::Result::TasksDay",
  { "foreign.recurrence_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 days

Type: many_to_many

Composing rels: L</tasks_days> -> day

=cut

__PACKAGE__->many_to_many("days", "tasks_days", "day");


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-06-10 23:32:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:oTiLTxUVXrTAGypMjvcheg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
