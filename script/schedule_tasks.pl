#!/usr/bin/env perl

use strict;
use warnings;

our $VERSION = q{0.01};

use IO::Socket::INET;

my $socket = IO::Socket::INET->new(
    PeerHost => q{localhost},
    PeerPort => q{4015},
);

$socket->send(q{run task} . qq{\n});
my $slept = sleep 1;
$socket->close();
