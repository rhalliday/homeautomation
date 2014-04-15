#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;
use IO::Socket::INET;

use Mochad;


subtest q{initialise everthing} => sub {
    plan tests => 5;
    my $mochad;
    ok $mochad = Mochad->new(
        {
            address    => q{A2},
            via        => q{rf},
            can_dim    => 1,
            connection => IO::Socket::INET->new(LocalAddr => q{localhost}, LocalPort => 9000, Proto => q{tcp}),
        }
      ),
      q{can initialise with just an address};

    # test the address was set correctly
    is $mochad->address, q{A2}, q{address was set correctly};

    # test the defaults
    is $mochad->via, q{rf}, q{can set via};
    ok $mochad->can_dim, q{can set can_dim};
    isa_ok $mochad->connection, q{IO::Socket::INET}, q{can set the connection to an IO::Socket::INET};
};
