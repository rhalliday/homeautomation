package Mochad;

use 5.014002;
use Moose;
use namespace::autoclean;
use IO::Socket::INET;
use Carp;

=head1 NAME

Mochad - OO interface to mochad!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Mochad is a daemon that sends messages to a CM15 module that will then forward
those messages using the X10 protocol over your power lines or via radio
frequency. This module allows you to create objects for your appliances and
use these objects to send messages more easily.

    use Mochad;

    my $lamp = Mochad->new({address => 'a1', via => 'pl', can_dim => 1, connection => $connection);
    $lamp->on();
    $lamp->dim();
    $lamp->bright();
    $lamp->off();

=head1 ATTRIBUTES

=over 4

=item address

The address code for the appliance i.e. H4

=cut

has q{address} => (
    is       => q{ro},
    isa      => q{Str},
    required => 1,
);

=item via

The medium to send the message by. Can be one of:
pl
rf

defaults to pl

=cut

has q{via} => (
    is      => q{ro},
    isa     => q{Str},
    default => q{pl},
);

=item can_dim

Boolean indicating if the brightness of the device can be set.

Defaults to false.
 
=cut

has q{can_dim} => (
    is      => q{ro},
    isa     => q{Bool},
    default => 0,
);

=item connection

HashRef of connection information.

=cut

has q{connection} => (
    is      => q{ro},
    isa     => q{HashRef},
    builder => q{_connection_builder},
);

sub _connection_builder {
    return {
        PeerAddr => q{localhost},
        PeerPort => 1099,
        Proto    => q{tcp},
    };
}

=back

=head1 METHODS

=head2 on

$lamp->on();

Turns the appliance on.

=cut

sub on {
    my ($self) = @_;

    return $self->_send_message(q{on});
}

=head2 off

$lamp->off();

Turns the appliance off.

=cut

sub off {
    my ($self) = @_;

    return $self->_send_message(q{off});
}

=head2 dim

$lamp->dim($amount);

Dims the appliance if the appliance has that feature.

=cut

sub dim {
    my ($self, $dim) = @_;
    return $self->_send_message(qq{dim $dim});
}

=head2 brighten

$lamp->brighten($amount);

Brightens the appliance if the appliance has that feature.

=cut

sub brighten {
    my ($self, $bright) = @_;
    return $self->_send_message(qq{bright $bright});
}

=head2 timer

$lamp->timer($time_in_seconds);

Sends the on message, waits for $time_in_seconds, then sends the off message

=cut

sub timer {
    my ($self, $time) = @_;

    $self->on();
    my $sleep = sleep($time);
    return $self->off();
}

sub _send_message {
    my ($self, $type) = @_;

    my $sock = IO::Socket::INET->new(%{ $self->connection })
      or croak 'Connection failed! ', $@;

    # send the message
    $sock->print(join(q{ }, $self->via, $self->address, $type) . qq{\n});

    if ($type =~ /(\w+) /) {
        $type = $1;
    }

    # wait for the response
    my $seen_unit = 0;
    my $seen_func = 0;

    while (my $data = $sock->getline) {
        if ($data =~ /HouseUnit: (\w+)/) {
            $seen_unit = 1 if uc($1) eq uc($self->address);
        } elsif ($data =~ /Func: (\w+)/) {
            $seen_func = 1 if uc($1) eq uc($type);
        }
        last if ($seen_unit and $seen_func);
    }
    $sock->close();
    return ($seen_unit and $seen_func);
}

__PACKAGE__->meta->make_immutable;

1;    # End of Mochad

__END__

=head1 AUTHOR

Rob Halliday, C<< <robh at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-mochad at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Mochad>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Mochad


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Mochad>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Mochad>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Mochad>

=item * Search CPAN

L<http://search.cpan.org/dist/Mochad/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2014 Rob Halliday.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

