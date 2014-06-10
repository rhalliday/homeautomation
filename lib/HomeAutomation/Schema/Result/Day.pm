use utf8;
package HomeAutomation::Schema::Result::Day;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

HomeAutomation::Schema::Result::Day

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

=head1 TABLE: C<days>

=cut

__PACKAGE__->table("days");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 day

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "day",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 tasks_days

Type: has_many

Related object: L<HomeAutomation::Schema::Result::TasksDay>

=cut

__PACKAGE__->has_many(
  "tasks_days",
  "HomeAutomation::Schema::Result::TasksDay",
  { "foreign.day_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 recurrences

Type: many_to_many

Composing rels: L</tasks_days> -> recurrence

=cut

__PACKAGE__->many_to_many("recurrences", "tasks_days", "recurrence");


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-06-10 23:32:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5jOgadV2D9nJNW1zg08sTw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
