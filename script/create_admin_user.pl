#!/usr/bin/env perl

use strict;
use warnings;

use HomeAutomation::Schema;

my $schema = HomeAutomation::Schema->connect('dbi:SQLite:ha.db');

my $user = $schema->resultset('User')->create(
    {
        username => 'admin',
        password => 'password;1',
        email_address => 'admin@example.com',
        active   => 1,
        user_roles => [
            { role_id => 1, },
            { role_id => 2, },
            { role_id => 3, },
        ],
    }
);

print 'done!',"\n";
