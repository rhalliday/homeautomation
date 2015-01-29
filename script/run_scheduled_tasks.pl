#!/usr/bin/env perl

use strict;
use warnings;

our $VERSION = q{0.01};

use HomeAutomation::Schema;

my $schema = HomeAutomation::Schema->connect('dbi:SQLite:ha.db');

my @tasks = $schema->resultset('Task')->active_tasks();

for my $task (@tasks) {
    $task->appliance->control($task->action);
}
