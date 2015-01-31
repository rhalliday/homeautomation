#!/usr/bin/env perl

use strict;
use warnings;

BEGIN {
    system(q{for file in script/sql/*.sql; do echo ${file}; sqlite3 test.db < ${file}; done;}) == 0
      || die q{Can't create database};
    $ENV{HA_DSN}         = 'dbi:SQLite:test.db';
    $ENV{CATALYST_DEBUG} = 0;
}

# drop the test db on completion
END {
    unlink q{test.db};
}

use Test::Class::Moose::Runner;
# load our test classes
use Test::Class::Moose::Load 't/lib';

Test::Class::Moose::Runner->new(
    test_classes => \@ARGV,    # ignored if empty
)->runtests;

1;
