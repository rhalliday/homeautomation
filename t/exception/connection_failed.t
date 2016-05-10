#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Exception;
use Try::Tiny;

use FindBin::libs;
use Exception::ConnectionFailed;

try {
    Exception::ConnectionFailed->throw(
        {
            device     => q{F3},
            message    => q{Connection refused},
            connection => { PeerAddr => q{localhost} },
        }
    );
} catch {
    my $e = $_;

    my $stringify = q{Unable to connect to device};
    isa_ok $e, q{Exception::ConnectionFailed}, q{it's an exception object};
    is $e->stringify, $stringify, q{get right stringify message};
    is qq{$e}, $stringify, q{overloads ""};

    my $device = qr/device:\sF3/;
    my $message = qr/message:\sConnection\srefused/;
    my $connection = qr/connection:\s\$VAR1\s=\s{\s+'PeerAddr'\s=>\s'localhost'\s+};/;
    like $e->log, qr/$device $message $connection/, q{get the right log message};
};

try {
    Exception::ConnectionFailed->throw(
        {
            device     => q{F2},
            message    => q{Connection invalid},
            connection => { PeerPort => 1099 },
        }
    );
} catch {
    my $e = $_;

    my $stringify = q{Unable to connect to device};
    isa_ok $e, q{Exception::ConnectionFailed}, q{it's an exception object};
    is $e->stringify, $stringify, q{get right stringify message};
    is qq{$e}, $stringify, q{overloads ""};

    my $device = qr/device:\sF2/;
    my $message = qr/message:\sConnection\sinvalid/;
    my $connection = qr/connection:\s\$VAR1\s=\s{\s+'PeerPort'\s=>\s1099\s+};/;
    like $e->log, qr/$device $message $connection/, q{get the right log message};
};

done_testing();
