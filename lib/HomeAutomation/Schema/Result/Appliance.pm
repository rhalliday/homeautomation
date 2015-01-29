package HomeAutomation::Schema::Result::Appliance;
use utf8;

=head1 NAME

HomeAutomation::Schema::Result::Appliance

=cut

use strict;
use warnings;

=head1 BASE CLASS: L<Schema::Base|HomeAutomation::Schema::Base>

=cut

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends q{HomeAutomation::Schema::Base};

use Mochad;
use Readonly;

our $VERSION = q{0.01};

Readonly::Scalar my $MAX_RGB_INT    => 255;
Readonly::Scalar my $RED_ADJUST     => 0.213;
Readonly::Scalar my $GREEN_ADJUST   => 0.715;
Readonly::Scalar my $BLUE_ADJUST    => 0.072;
Readonly::Scalar my $TEXT_THRESHOLD => 0.5;

=head1 COMPONENTS LOADED

=over 4

=item * L<DateTime|DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components(q{InflateColumn::DateTime});

=head1 TABLE: C<appliances>

=cut

__PACKAGE__->table(q{appliances});

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

=head2 on_button_text

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=head2 off_button_text

  data_type: 'varchar'
  is_nullable: 1
  size: 10

=cut

__PACKAGE__->add_columns(
    q{address},  { data_type => q{varchar}, is_nullable    => 0, size        => 3 },
    q{device},   { data_type => q{varchar}, is_nullable    => 1, size        => 50 },
    q{room_id},  { data_type => q{integer}, is_foreign_key => 1, is_nullable => 1 },
    q{protocol}, { data_type => q{char},    is_nullable    => 1, size        => 2 },
    q{status},   { data_type => q{boolean}, is_nullable    => 1 },
    q{setting},         { data_type => q{smallint}, is_nullable => 1 },
    q{dimable},         { data_type => q{boolean},  is_nullable => 1 },
    q{timings},         { data_type => q{smallint}, is_nullable => 1 },
    q{colour},          { data_type => q{char},     is_nullable => 1, size => 7 },
    q{on_button_text},  { data_type => q{varchar},  is_nullable => 1, size => 10 },
    q{off_button_text}, { data_type => q{varchar},  is_nullable => 1, size => 10 },
);

=head1 PRIMARY KEY

=over 4

=item * L<address|/address>

=back

=cut

__PACKAGE__->set_primary_key(q{address});

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
    { q{foreign.appliance} => q{self.address} },
    { cascade_copy         => 0, cascade_delete => 0 },
);

=head1 Non-database columns

=over

=item hardware

An object used to interface with the actual hardware

=cut

has q{hardware} => (
    is       => q{ro},
    isa      => q{Mochad},
    required => 1,
    lazy     => 1,
    builder  => q{_build_hardware},
);

sub _build_hardware {
    my ($self) = @_;

    return Mochad->new(
        {
            address => $self->address,
            via     => $self->protocol
        }
    );
}

=item text_colour

Returns a text colour suitable for the colour

=cut

has q{text_colour} => (
    is      => q{ro},
    isa     => q{Str},
    lazy    => 1,
    builder => q{_build_text_colour},
);

sub _build_text_colour {
    my ($self) = @_;

    # default to white
    return q{#FFF} unless $self->colour;

    my $rgb_hex = $self->colour;
    $rgb_hex =~ s/^#//;

    # convert the colour to rgb
    my @rgb = map { $_ / $MAX_RGB_INT } unpack q{C*}, pack q{H*}, $rgb_hex;

    return $RED_ADJUST * $rgb[0] + $GREEN_ADJUST * $rgb[1] + $BLUE_ADJUST * $rgb[2] < $TEXT_THRESHOLD
      ? q{#FFF}
      : q{#000};
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
    return $user->has_role(q{admin});
}

=item control

Takes an action to perform, sends that action to hardware and updates the record

=cut

sub control {
    my ($self, $action) = @_;

    # if the device should only be on for a specified time
    if ($self->timings) {

        # with a timings device we only want to send the message if
        # the status is opposite of the action. This is because no
        # matter what the action is we turn it on and off.
        if (   ($action eq q{off} && $self->status)
            || ($action eq q{on} && !$self->status))
        {
            $self->hardware->timer($self->timings);
        }
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

=item dim

Takes a dim setting, and dims/brightens the device.

=cut

sub dim {
    my ($self, $dim) = @_;

    # just return if we can't dim
    return unless $self->dimable();

    # get the difference between the setting and the specified dim
    my $diff = $dim - $self->setting;

    # don't do anything if they're the same
    return unless $diff;

    if ($diff < 0) {

        # dim the device
        $self->hardware->dim(abs($diff));
    } else {

        # brighten the device
        $self->hardware->brighten($diff);
    }

    # update our setting
    $self->setting($dim);
    $self->update;

    return 1;
}

=back

=cut

__PACKAGE__->meta->make_immutable;
1;
