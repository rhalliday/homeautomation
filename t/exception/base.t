#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Exception;
use Try::Tiny;

use FindBin::libs;
use Exception;

try {
    Exception->throw();
} catch {
    my $e = $_;
    isa_ok $e, q{Exception}, q{it's an exception object};
    is $e->stringify, q{Exception hasn't implemented stringify method}, q{get right stringify message};
    is $e->log, q{Exception hasn't implemented log method}, q{ get the right log message};
    is qq{$e}, q{Exception hasn't implemented stringify method}, q{overloads ""};
};


done_testing();
