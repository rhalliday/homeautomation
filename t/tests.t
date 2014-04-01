#!perl

# load our test classes
use Test::Class::Moose::Load 't/lib';

BEGIN {
    system(q{for file in script/sql/*.sql; do echo ${file}; sqlite3 test.db < ${file}; done;}) == 0 || die q{Can't create database};
    $ENV{HA_DSN} = 'dbi:SQLite:test.db';
}

# drop the test db on completion
END {
    unlink q{test.db};
}

# run the tests
# can specify different classes on the command line
# i.e. prove -l tests.t :: Test::HomeAutomation::X
Test::HomeAutomation->new(
    test_classes => \@ARGV, # ignored if empty
)->runtests;
