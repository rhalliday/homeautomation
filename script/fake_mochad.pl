#!/usr/bin/perl

# fake a mochad server so that we can still test on our dev machine
use strict;
use warnings;

use IO::Socket::INET;

my $socket = IO::Socket::INET->new(
    LocalHost => q{127.0.0.1},
    LocalPort => q{1099},
    Proto     => q{tcp},
    Listen    => 5,
    Reuse     => 1
);

while (1) {
    my $client = $socket->accept();
}

$socket->close();
