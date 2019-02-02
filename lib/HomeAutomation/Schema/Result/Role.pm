package HomeAutomation::Schema::Result::Role;
use utf8;

=head1 NAME

HomeAutomation::Schema::Result::Role

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

=head1 TABLE: C<role>

=cut

__PACKAGE__->table(q{role});

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 role

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
    q{id}, { data_type => q{integer}, is_auto_increment => 1, is_nullable => 0 },
    q{role}, { data_type => q{text}, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key(q{id});

=head1 RELATIONS

=head2 user_roles

Type: has_many

Related object: L<UserRole|HomeAutomation::Schema::Result::UserRole>

=cut

__PACKAGE__->has_many(
    q{user_roles}, q{HomeAutomation::Schema::Result::UserRole},
    { q{foreign.role_id} => q{self.id} }, { cascade_copy => 0, cascade_delete => 0 },
);

=head2 users

Type: many_to_many

Composing rels: L<user_roles|/user_roles> -> user

=cut

__PACKAGE__->many_to_many(q{users}, q{user_roles}, q{user});

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
1;
