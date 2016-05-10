package Exception;

use Moo;
with 'Throwable';

=head1 NAME

Exception - Base class for exceptions

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

A base class for all the Exceptions the App uses. If anything errors it should
throw an exception that the app can deal with.

=head1 METHODS

Subclasses should overide the log and stringify functions. Stringify should
return a message suitable for app users, log should return a message suitable
for administrators to debug what caused the issue.

=over

=cut

use overload q{""} => q{stringify}, fallback => 1;

=item stringify

Should return a message suitable for app users.

=cut

sub stringify {
    my ($self) = @_;

    return ref($self) . q{ hasn't implemented stringify method};
}

=item log

Should return a message suitable for administrators to debug what caused the
issue

=cut

sub log {
    my ($self) = @_;

    return ref($self) . q{ hasn't implemented log method};
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
