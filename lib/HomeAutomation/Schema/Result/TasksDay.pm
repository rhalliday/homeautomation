package HomeAutomation::Schema::Result::TasksDay;
use utf8;

=head1 NAME

HomeAutomation::Schema::Result::TasksDay

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

=head1 TABLE: C<tasks_day>

=cut

__PACKAGE__->table(q{tasks_day});

=head1 ACCESSORS

=head2 recurrence_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 day_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
    q{recurrence_id}, { data_type => q{integer}, is_foreign_key => 1, is_nullable => 0 },
    q{day_id},        { data_type => q{integer}, is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L<recurrence_id|/recurrence_id>

=item * L<day_id|/day_id>

=back

=cut

__PACKAGE__->set_primary_key(q{recurrence_id}, q{day_id});

=head1 RELATIONS

=head2 day

Type: belongs_to

Related object: L<Day|HomeAutomation::Schema::Result::Day>

=cut

__PACKAGE__->belongs_to(
    q{day},
    q{HomeAutomation::Schema::Result::Day},
    { id            => q{day_id} },
    { is_deferrable => 0, on_delete => q{CASCADE}, on_update => q{CASCADE} },
);

=head2 recurrence

Type: belongs_to

Related object: L<Recurrence|HomeAutomation::Schema::Result::Recurrence>

=cut

__PACKAGE__->belongs_to(
    q{recurrence},
    q{HomeAutomation::Schema::Result::Recurrence},
    { id            => q{recurrence_id} },
    { is_deferrable => 0, on_delete => q{CASCADE}, on_update => q{CASCADE} },
);

__PACKAGE__->meta->make_immutable;
1;
