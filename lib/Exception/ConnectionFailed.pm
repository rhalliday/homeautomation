package Exception::ConnectionFailed;

use Moo;
extends 'Exception';
with 'Throwable';

use Data::Dumper;

=head1 NAME

Exception::ConnectionFailed - class for connection failures

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Throws exceptions when trying to connect to a device.

=head1 ATTRIBUTES

=over

=cut

=item connection

Hashref containing the details used to connect to the device.

=cut

has connection => (is => q{ro},);

=item device

Address of the device

=cut

has device => (is => q{ro},);

=item message

Error message for the log

=cut

has message => (is => q{ro},);

=back

=head1 METHODS

=over

=cut

=item stringify

returns a message suitable for app users.

=cut

sub stringify {
    my ($self) = @_;

    return q{Unable to connect to device};
}

=item log

Should return a message suitable for administrators to debug what caused the
issue

=cut

sub log {
    my ($self) = @_;

    return
      join(q{ }, q{device:}, $self->device, q{message:}, $self->message, q{connection:}, Dumper($self->connection));
}

=back

=cut

1;    # End of Exception

__END__

=head1 AUTHOR

Rob Halliday, C<< <robh at cpan.org> >>

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
