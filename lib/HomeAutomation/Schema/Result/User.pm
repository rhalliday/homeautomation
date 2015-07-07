package HomeAutomation::Schema::Result::User;
use utf8;

=head1 NAME

HomeAutomation::Schema::Result::User

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

=head1 TABLE: C<users>

=cut

__PACKAGE__->table(q{users});

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
    q{id}, { data_type => q{integer}, is_auto_increment => 1, is_nullable => 0 },
    q{username},      { data_type => q{text},    is_nullable => 1 },
    q{password},      { data_type => q{text},    is_nullable => 1 },
    q{email_address}, { data_type => q{text},    is_nullable => 1 },
    q{first_name},    { data_type => q{text},    is_nullable => 1 },
    q{last_name},     { data_type => q{text},    is_nullable => 1 },
    q{active},        { data_type => q{integer}, is_nullable => 1 },
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
    user_roles => q{HomeAutomation::Schema::Result::UserRole},
    { q{foreign.user_id} => q{self.id} }, { cascade_copy => 0, cascade_delete => 0 },
);

=head2 roles

Type: many_to_many

Composing rels: L</user_roles> -> role

=cut

__PACKAGE__->many_to_many(q{roles}, q{user_roles}, q{role});

# Have the 'password' column use a SHA-1 hash and 20-byte salt
# with RFC 2307 encoding; Generate the 'check_password' method
__PACKAGE__->add_columns(
    q{password} => {
        passphrase       => q{rfc2307},
        passphrase_class => q{SaltedDigest},
        passphrase_args  => {
            algorithm   => q{SHA-1},
            salt_random => 20,
        },
        passphrase_check_method => q{check_password},
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

    return unless $self->active;

    # Does this user posses the required role?
    return any(map { $_->role } $self->roles) eq $role;
}

=item deactivate_allowed_by

Set the user role(s) that are allowed to deactivate users

=cut

sub deactivate_allowed_by {
    my ($self, $user) = @_;

    return $user->has_role(q{usermanagement});
}

=item delete_allowed_by

Set the user role(s) that are allowed to delete users

=cut

sub delete_allowed_by {
    my ($self, $user) = @_;

    return $user->has_role(q{admin});
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

    return join(q{, }, @roles);
}

=back

=cut

__PACKAGE__->meta->make_immutable;
1;
