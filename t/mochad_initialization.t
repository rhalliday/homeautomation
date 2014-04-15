#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;
use Test::Exception;

use Mochad;

can_ok q{Mochad}, qw( new );
throws_ok { Mochad->new() } qr/Attribute \(address\) is required/, 'address is a required argument';

subtest q{basic initialisation} => sub {
    plan tests => 5;
    my $mochad;
    ok $mochad = Mochad->new({ address => q{A1} }), q{can initialise with just an address};

    # test the address was set correctly
    is $mochad->address, q{A1}, q{address was set correctly};

    # test the defaults
    is $mochad->via, q{pl}, q{via defaults to pl};
    ok !$mochad->can_dim, q{can_dim defaults to false};
    isa_ok $mochad->connection, q{IO::Socket}, q{defaults to an IO::Socket (or subclass)};
};

