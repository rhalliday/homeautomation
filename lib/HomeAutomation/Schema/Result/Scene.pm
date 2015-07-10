package HomeAutomation::Schema::Result::Scene;
use utf8;

=head1 NAME

HomeAutomation::Schema::Result::Scene

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

=head1 TABLE: C<scenes>

=cut

__PACKAGE__->table(q{scenes});

=head1 ACCESSORS

=head2 scene_id

  data_type: 'integer'
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 room_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 scene

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
    q{scene_id}, { data_type => q{integer}, is_nullable    => 0 },
    q{name},     { data_type => q{varchar}, is_nullable    => 1, size        => 50 },
    q{room_id},  { data_type => q{integer}, is_foreign_key => 1, is_nullable => 1 },
    q{scene},    { data_type => q{text},    is_nullable    => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L<scene_id|/scene_id>

=back

=cut

__PACKAGE__->set_primary_key(q{scene_id});

=head1 RELATIONS

=head2 room

Type: belongs_to

Related object: L<Room|HomeAutomation::Schema::Result::Room>

=cut

__PACKAGE__->belongs_to(
    q{room},
    q{HomeAutomation::Schema::Result::Room},
    { id => q{room_id} },
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
    { q{foreign.scene_id} => q{self.scene_id} },
    { cascade_copy         => 0, cascade_delete => 0 },
);


=head1 Methods

=over

=item delete_allowed_by

Can the specified user delete the current scene

=cut

sub delete_allowed_by {
    my ($self, $user) = @_;

    # Only allow delete if user has 'admin' role
    return $user->has_role(q{admin});
}

=back

=cut

__PACKAGE__->meta->make_immutable;
1;
