use utf8;
package HomeAutomation::Schema::Result::Appliance;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

HomeAutomation::Schema::Result::Appliance

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

=head1 TABLE: C<appliances>

=cut

__PACKAGE__->table("appliances");

=head1 ACCESSORS

=head2 address

  data_type: 'varchar'
  is_nullable: 0
  size: 3

=head2 device

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 room_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 protocol

  data_type: 'char'
  is_nullable: 1
  size: 2

=head2 status

  data_type: 'boolean'
  is_nullable: 1

=head2 setting

  data_type: 'smallint'
  is_nullable: 1

=head2 dimable

  data_type: 'boolean'
  is_nullable: 1

=head2 timings

  data_type: 'smallint'
  is_nullable: 1

=head2 colour

  data_type: 'char'
  is_nullable: 1
  size: 7

=cut

__PACKAGE__->add_columns(
  "address",
  { data_type => "varchar", is_nullable => 0, size => 3 },
  "device",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "room_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "protocol",
  { data_type => "char", is_nullable => 1, size => 2 },
  "status",
  { data_type => "boolean", is_nullable => 1 },
  "setting",
  { data_type => "smallint", is_nullable => 1 },
  "dimable",
  { data_type => "boolean", is_nullable => 1 },
  "timings",
  { data_type => "smallint", is_nullable => 1 },
  "colour",
  { data_type => "char", is_nullable => 1, size => 7 },
);

=head1 PRIMARY KEY

=over 4

=item * L</address>

=back

=cut

__PACKAGE__->set_primary_key("address");

=head1 RELATIONS

=head2 room

Type: belongs_to

Related object: L<HomeAutomation::Schema::Result::Room>

=cut

__PACKAGE__->belongs_to(
  "room",
  "HomeAutomation::Schema::Result::Room",
  { id => "room_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 tasks

Type: has_many

Related object: L<HomeAutomation::Schema::Result::Task>

=cut

__PACKAGE__->has_many(
  "tasks",
  "HomeAutomation::Schema::Result::Task",
  { "foreign.appliance" => "self.address" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-04-30 21:42:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rGpJ1YXTvx6xKJvU4VhJSg


# You can replace this text with custom code or comments, and it will be preserved on regeneration

use Mochad;

=head1 Non-database columns

=over

=item hardware

An object used to interface with the actual hardware

=cut

has q{hardware} => (
    is       => 'ro',
    isa      => 'Mochad',
    required => 1,
    lazy     => 1,
    builder  => '_build_hardware',
);

sub _build_hardware {
    my ($self) = @_;

    return Mochad->new(
        {
            address => $self->address,
            via => $self->protocol
        }
    );
}

=item text_colour

Returns a text colour suitable for the colour

=cut

has q{text_colour} => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    builder => '_build_text_colour',
);

sub _build_text_colour {
    my ($self) = @_;

    # default to white
    return '#FFF' unless $self->colour;

    my $rgb_hex = $self->colour;
    $rgb_hex =~ s/^#//;
    # convert the colour to rgb
    my @rgb = map $_ / 255, unpack 'C*', pack 'H*', $rgb_hex;

    return 0.213 * $rgb[0] + 0.715 * $rgb[1] + 0.072 * $rgb[2] < 0.5 ? '#FFF' : '#000';
}

=back

=head1 Methods

=over

=item clear

Acts as a delete but clears all the fields barring the primary key so it can be used again.

=cut

sub clear {
    my ($self) = @_;

    for my $field (qw/ device protocol status setting timings dimable /) {
        $self->$field(undef);
    }
    $self->update();
    return 1;
}

=item delete_allowed_by

Can the specified user delete the current book?

=cut

sub delete_allowed_by {
    my ($self, $user) = @_;

    # Only allow delete if user has 'admin' role
    return $user->has_role('admin');
}

=item control

Takes an action to perform, sends that action to hardware and updates the record

=cut

sub control {
    my ($self, $action) = @_;

    # if the device should only be on for a specified time
    if ($self->timings) {
        $self->hardware->timer($self->timings);
    } else {

        # send the action to the hardware
        $self->hardware->$action;
    }

    # update self
    if ($action eq q{off}) {
        $self->status(0);
    } else {
        $self->status(1);
    }
    $self->update();

    return 1;
}

=item switch

Changes the status of the appliance

=cut

sub switch {
    my ($self) = @_;

    # if we are on turn us off
    return $self->control(q{off}) if $self->status;

    # otherwise turn us on
    return $self->control(q{on});
}

=back

=cut

__PACKAGE__->meta->make_immutable;
1;
