#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 3;
use Test::Exception;
use Test::Differences;
use IO::Socket::INET;

use Mochad;

can_ok q{Mochad}, qw( new );
throws_ok { Mochad->new() } qr/Attribute \(address\) is required/, 'address is a required argument';

subtest q{basic initialisation} => sub {
    plan tests => 5;
    my $server = IO::Socket::INET->new(
        LocalHost => q{localhost},
        LocalPort => q{1099},
        Proto     => q{tcp},
        Listen    => 1,
        Reuse     => 1,
    ) or diag(q{something is already connected to 1099});

    my $mochad;
    ok $mochad = Mochad->new({ address => q{A1} }), q{can initialise with just an address};

    # test the address was set correctly
    is $mochad->address, q{A1}, q{address was set correctly};

    # test the defaults
    is $mochad->via, q{pl}, q{via defaults to pl};
    ok !$mochad->can_dim, q{can_dim defaults to false};
    eq_or_diff $mochad->connection,
      {
        PeerAddr => q{localhost},
        PeerPort => 1099,
        Proto    => q{tcp},
      },
      q{default IO::Socket settings};
};

1;
