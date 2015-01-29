package HomeAutomation::Schema::Result::Recurrence;
use utf8;

=head1 NAME

HomeAutomation::Schema::Result::Recurrence

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

=head1 TABLE: C<recurrence>

=cut

__PACKAGE__->table(q{recurrence});

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
    q{id},      { data_type => q{integer}, is_auto_increment => 1, is_nullable => 0 },
    q{task_id}, { data_type => q{integer}, is_foreign_key    => 1, is_nullable => 1 },
    q{expires}, { data_type => q{date},    is_nullable       => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key(q{id});

=head1 RELATIONS

=head2 task

Type: belongs_to

Related object: L<Task|HomeAutomation::Schema::Result::Task>

=cut

__PACKAGE__->belongs_to(
    q{task},
    q{HomeAutomation::Schema::Result::Task},
    { id => q{task_id} },
    {
        is_deferrable => 0,
        join_type     => q{LEFT},
        on_delete     => q{CASCADE},
        on_update     => q{CASCADE},
    },
);

=head2 tasks

Type: has_many

Related object: L<Task|HomeAutomation::Schema::Result::Task>

=cut

__PACKAGE__->has_many(
    q{tasks},
    q{HomeAutomation::Schema::Result::Task},
    { q{foreign.recurrence_id} => q{self.id} },
    { cascade_copy             => 0, cascade_delete => 0 },
);

=head2 tasks_days

Type: has_many

Related object: L<TasksDay|HomeAutomation::Schema::Result::TasksDay>

=cut

__PACKAGE__->has_many(
    q{tasks_days},
    q{HomeAutomation::Schema::Result::TasksDay},
    { q{foreign.recurrence_id} => q{self.id} },
    { cascade_copy             => 0, cascade_delete => 0 },
);

=head2 days

Type: many_to_many

Composing rels: L<task_days|/tasks_days> -> day

=cut

__PACKAGE__->many_to_many(q{days}, q{tasks_days}, q{day});

__PACKAGE__->meta->make_immutable;
1;
