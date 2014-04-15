#!/usr/bin/perl

use strict;
use warnings;

use HomeAutomation::Schema;

my $schema = HomeAutomation::Schema->connect('dbi:SQLite:ha.db');

my @tasks = $schema->resultset('Task')->active_tasks();

for my $task (@tasks) {
    $task->appliance->control($task->action);
}
