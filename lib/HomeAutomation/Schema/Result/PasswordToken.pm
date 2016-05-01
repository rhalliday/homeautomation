package HomeAutomation::Schema::Result::PasswordToken;
use utf8;

=head1 NAME

HomeAutomation::Schema::Result::PasswordToken

=cut

use strict;
use warnings;

=head1 BASE CLASS: L<Schema::Base|HomeAutomation::Schema::Base>

=cut

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends q{HomeAutomation::Schema::Base};

use DateTime;

our $VERSION = q{0.01};

=head1 COMPONENTS LOADED

=over 4

=item * L<DateTime|DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components(q{InflateColumn::DateTime}, q{TimeStamp});

=head1 TABLE: C<password_tokens>

=cut

__PACKAGE__->table(q{password_tokens});

=head1 ACCESSORS

=head2 token

  data_type: 'text'
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_nullable: 0

=head2 timestamp

  data_type: 'datetime'
  is_nullable: 0

=head2 active

  data_type: 'boolean'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
    q{token},     { data_type => q{text},     is_nullable => 0 },
    q{user_id},   { data_type => q{integer},  is_nullable => 0 },
    q{timestamp}, { data_type => q{datetime}, is_nullable => 0, set_on_create => 1 },
    q{active},    { data_type => q{boolean},  is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</token>

=back

=cut

__PACKAGE__->set_primary_key(q{token});

=head1 RELATIONS

=head2 user

Type: belongs_to

Related object: L<User|HomeAutomation::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
    user => q{HomeAutomation::Schema::Result::User},
    { q{foreign.id} => q{self.user_id} }, { cascade_copy => 0, cascade_delete => 0 },
);

=head2 Methods

=over

=item link($c, $user)

Generates a link for use in the reset emails.
Requires a user and a context object.

=cut

sub link {
    my ($self, $c, $user) = @_;

    return $c->uri_for_action(q{/usermanagement/reset_password},[ $user->id, $self->token ]);
}

=back

=cut

__PACKAGE__->meta->make_immutable;
1;
