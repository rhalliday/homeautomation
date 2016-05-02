#!/usr/bin/env perl

use strict;
use warnings;

our $VERSION = q{0.01};

use FindBin::libs;
use HomeAutomation::Schema;
use IO::Socket::INET;
use Readonly;

Readonly::Scalar my $KB         => 1024;
Readonly::Scalar my $QUEUE_SIZE => 5;

sub run_tasks {
    my ($schema) = @_;
    my @tasks = $schema->resultset('Task')->active_tasks();

    for my $task (@tasks) {
        if ($task->scene_id) {
            $task->scene->run();
        } else {
            $task->appliance->control($task->action);
        }
    }
    return 1;
}

my $schema = HomeAutomation::Schema->connect('dbi:SQLite:/home/pi/homeautomation/ha.db');
my $socket = IO::Socket::INET->new(
    LocalHost => q{localhost},
    LocalPort => q{4015},
    Listen    => $QUEUE_SIZE,
    Reuse     => 1,
) or die q{ERROR in Socket Creation : }, $!, qq{\n};

while (1) {

    # wait for a client to connect
    my $client_socket = $socket->accept();

    # send a message to acknowledge connection
    $client_socket->send(q{Hello, awaiting command:} . qq{\n});

    # get the command
    my $data;
    $client_socket->recv($data, $KB);
    if ($data =~ /run task/i) {
        $client_socket->send(q{running tasks} . qq{\n});
        run_tasks($schema);
    } else {
        $client_socket->send(q{unknown command} . qq{\n});
    }
}

$socket->close();
