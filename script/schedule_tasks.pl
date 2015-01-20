#!/usr/bin/env perl

use strict;
use warnings;

use IO::Socket::INET;

my $socket = IO::Socket::INET->new(
    PeerHost => q{localhost},
    PeerPort => q{4015},
);

$socket->send(q{run task} . qq{\n});
sleep(1);
$socket->close();
