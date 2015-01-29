#!/usr/bin/env perl

# fake a mochad server so that we can still test on our dev machine
use strict;
use warnings;

our $VERSION = q{0.01};

use IO::Socket::INET;
use Readonly;

Readonly::Scalar my $QUEUE => 5;

my $socket = IO::Socket::INET->new(
    LocalHost => q{127.0.0.1},
    LocalPort => q{1099},
    Proto     => q{tcp},
    Listen    => $QUEUE,
    Reuse     => 1
);

while (1) {
    my $client = $socket->accept();
    while (<$client>) {
        print $_ . qq{\n};
    }
}

$socket->close();
