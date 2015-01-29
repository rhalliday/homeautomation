#!/usr/bin/env perl
use strict;
use warnings;

our $VERSION = q{0.01};

use Catalyst::ScriptRunner;
Catalyst::ScriptRunner->run('HomeAutomation', 'CGI');

1;

=head1 NAME

homeautomation_cgi.pl - Catalyst CGI

=head1 SYNOPSIS

See L<Manual|Catalyst::Manual>

=head1 DESCRIPTION

Run a Catalyst application as a cgi script.

=head1 AUTHORS

Catalyst Contributors, see Catalyst.pm

=head1 COPYRIGHT

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

