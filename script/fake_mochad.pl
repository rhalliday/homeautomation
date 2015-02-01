#!/usr/bin/env perl

# fake a mochad server so that we can still test on our dev machine
use strict;
use warnings;

our $VERSION = q{0.02};

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
    my @commands;
    my $data = <$client>;
    print $data . qq{\n};
    if ($data =~ /([A-Z]\d+) ([a-z]+)/) {
        my $house_unit = uc $1;
        my $command = ucfirst $2;
        my $house_code = substr $house_unit, 0, 1;
        @commands = (
            qq{10/31 22:06:52 Tx PL HouseUnit: $house_unit\n},
            qq{10/31 22:06:52 Tx PL House: $house_code Func: $command\n},
        );
    }
    for my $cmd (@commands) {
        print $client $cmd;
    }
}

$socket->close();
