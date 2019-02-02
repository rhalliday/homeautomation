package HomeAutomation::Schema::Result::Day;
use utf8;

=head1 NAME

HomeAutomation::Schema::Result::Day

=cut

use strict;
use warnings;

=head1 BASE CLASS: L<Schema::Base|HomeAutomation::Schema::Base>

=cut

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends q{HomeAutomation::Schema::Base};

our $VERSION = q{0.01};

=head1 COMPONENTS LOADED

=over 4

=item * L<DateTime|DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components(q{InflateColumn::DateTime});

=head1 TABLE: C<days>

=cut

__PACKAGE__->table(q{days});

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
    q{id}, { data_type => q{integer}, is_auto_increment => 1, is_nullable => 0 },
    q{day}, { data_type => q{text}, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L<id|/id>

=back

=cut

__PACKAGE__->set_primary_key(q{id});

=head1 RELATIONS

=head2 tasks_days

Type: has_many

Related object: L<TasksDay|HomeAutomation::Schema::Result::TasksDay>

=cut

__PACKAGE__->has_many(
    q{tasks_days}, q{HomeAutomation::Schema::Result::TasksDay},
    { q{foreign.day_id} => q{self.id} }, { cascade_copy => 0, cascade_delete => 0 },
);

=head2 recurrences

Type: many_to_many

Composing rels: L<tasks_days|/tasks_days> -> recurrence

=cut

__PACKAGE__->many_to_many(q{recurrences}, q{tasks_days}, q{recurrence});

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
1;
