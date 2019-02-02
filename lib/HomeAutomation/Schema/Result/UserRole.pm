package HomeAutomation::Schema::Result::UserRole;
use utf8;

=head1 NAME

HomeAutomation::Schema::Result::UserRole

=cut

use strict;
use warnings;

=head1 BASE CLASS: L<HomeAutomation::Schema::Base|HomeAutomation::Schema::Base>

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

=head1 TABLE: C<user_role>

=cut

__PACKAGE__->table(q{user_role});

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 role_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
    q{user_id}, { data_type => q{integer}, is_foreign_key => 1, is_nullable => 0 },
    q{role_id}, { data_type => q{integer}, is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L<user_id|/user_id>

=item * L<role_id|/role_id>

=back

=cut

__PACKAGE__->set_primary_key(q{user_id}, q{role_id});

=head1 RELATIONS

=head2 role

Type: belongs_to

Related object: L<Role|HomeAutomation::Schema::Result::Role>

=cut

__PACKAGE__->belongs_to(
    q{role},
    q{HomeAutomation::Schema::Result::Role},
    { id            => q{role_id} },
    { is_deferrable => 0, on_delete => q{CASCADE}, on_update => q{CASCADE} },
);

=head2 user

Type: belongs_to

Related object: L<User|HomeAutomation::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
    q{user},
    q{HomeAutomation::Schema::Result::User},
    { id            => q{user_id} },
    { is_deferrable => 0, on_delete => q{CASCADE}, on_update => q{CASCADE} },
);

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
1;
