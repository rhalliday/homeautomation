package HomeAutomation::Schema::Result::Room;
use utf8;

=head1 NAME

HomeAutomation::Schema::Result::Room

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

=head1 TABLE: C<rooms>

=cut

__PACKAGE__->table(q{rooms});

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=cut

__PACKAGE__->add_columns(
    q{id},   { data_type => q{integer}, is_auto_increment => 1, is_nullable => 0 },
    q{name}, { data_type => q{varchar}, is_nullable       => 0, size        => 50 },
);

=head1 PRIMARY KEY

=over 4

=item * L<id|/id>

=back

=cut

__PACKAGE__->set_primary_key(q{id});

=head1 RELATIONS

=head2 appliances

Type: has_many

Related object: L<Appliance|HomeAutomation::Schema::Result::Appliance>

=cut

__PACKAGE__->has_many(
    q{appliances}, q{HomeAutomation::Schema::Result::Appliance},
    { q{foreign.room_id} => q{self.id} }, { cascade_copy => 0, cascade_delete => 0 },
);

# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-06-10 23:32:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:MMGJjHq/pmBENCxjllOnIg

=head2 Methods

=over

=item delete_allowed_by

Can the specified user delete the current book?

=cut

sub delete_allowed_by {
    my ($self, $user) = @_;

    # Only allow delete if user has 'admin' role
    return $user->has_role(q{admin});
}

=back

=cut

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable(inline_constructor => 0);
1;
