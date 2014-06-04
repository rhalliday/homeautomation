use utf8;
package HomeAutomation::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

HomeAutomation::Schema::Result::User

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

=head1 TABLE: C<users>

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 username

  data_type: 'text'
  is_nullable: 1

=head2 password

  data_type: 'text'
  is_nullable: 1

=head2 email_address

  data_type: 'text'
  is_nullable: 1

=head2 first_name

  data_type: 'text'
  is_nullable: 1

=head2 last_name

  data_type: 'text'
  is_nullable: 1

=head2 active

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "username",
  { data_type => "text", is_nullable => 1 },
  "password",
  { data_type => "text", is_nullable => 1 },
  "email_address",
  { data_type => "text", is_nullable => 1 },
  "first_name",
  { data_type => "text", is_nullable => 1 },
  "last_name",
  { data_type => "text", is_nullable => 1 },
  "active",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 user_roles

Type: has_many

Related object: L<HomeAutomation::Schema::Result::UserRole>

=cut

__PACKAGE__->has_many(
  "user_roles",
  "HomeAutomation::Schema::Result::UserRole",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 roles

Type: many_to_many

Composing rels: L</user_roles> -> role

=cut

__PACKAGE__->many_to_many("roles", "user_roles", "role");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2014-03-14 14:13:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4RFpJc37mGCPEt0ibyljQQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration

# Have the 'password' column use a SHA-1 hash and 20-byte salt
# with RFC 2307 encoding; Generate the 'check_password" method
__PACKAGE__->add_columns(
    'password' => {
        passphrase       => 'rfc2307',
        passphrase_class => 'SaltedDigest',
        passphrase_args  => {
            algorithm   => 'SHA-1',
            salt_random => 20,
        },
        passphrase_check_method => 'check_password',
    },
);

=head2 Methods

=over

=item has_role

Check if a user has the specified role

=cut

use Perl6::Junction qw/any/;
sub has_role {
    my ($self, $role) = @_;

    # Does this user posses the required role?
    return any(map { $_->role } $self->roles) eq $role;
}

=item deactivate_allowed_by

Set the user role(s) that are allowed to deactivate users

=cut

sub deactivate_allowed_by {
    my ($self, $user) = @_;

    return $user->has_role('usermanagement');
}

=item delete_allowed_by

Set the user role(s) that are allowed to delete users

=cut

sub delete_allowed_by {
    my ($self, $user) = @_;

    return $user->has_role('admin');
}

=item deactivate

Sets a user to (in)active.

=cut

sub deactivate {
    my ($self) = @_;

    # suppress warnings about the wrong type
    my $active = $self->active ? 0 : 1;
    $self->active($active);
    $self->update;

    return 1;
}

=item full_name

Returns the users first and last name

=cut

sub full_name {
    my ($self) = @_;

    return join q{ }, $self->first_name, $self->last_name;
}

=item role_list
 
Return a comma-separated list of roles for the current user
 
=cut
 
sub role_list {
    my ($self) = @_;
 
    my @roles;
    foreach my $role ($self->roles) {
        push(@roles, $role->role);
    }
 
    return join(', ', @roles);
}

=back

=cut

__PACKAGE__->meta->make_immutable;
1;
