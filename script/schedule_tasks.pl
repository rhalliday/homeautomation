#!/usr/bin/perl

use strict;
use warnings;

use IO::Socket::INET;

my $socket = IO::Socket::INET->new(
    PeerHost => q{localhost},
    PeerPort => q{4015},
) or die q{ERROR in Socket Creation : },$!,qq{\n};

$socket->send(q{run task} . qq{\n});
sleep(1);
$socket->close();
