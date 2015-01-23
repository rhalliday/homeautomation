#!/usr/bin/env perl

use strict;
use warnings;

use FindBin::libs;
use HomeAutomation::Schema;
use IO::Socket::INET;

sub run_tasks {
    my ($schema) = @_;
    my @tasks = $schema->resultset('Task')->active_tasks();

    for my $task (@tasks) {
        $task->appliance->control($task->action);
    }
}

my $schema = HomeAutomation::Schema->connect('dbi:SQLite:ha.db');
my $socket = IO::Socket::INET->new(
    LocalHost => q{localhost},
    LocalPort => q{4015},
    Listen    => 5,
    Reuse     => 1,
) or die q{ERROR in Socket Creation : },$!,qq{\n};

while(1) {
    # wait for a client to connect
    my $client_socket = $socket->accept();

    # send a message to acknowledge connection
    $client_socket->send(q{Hello, awaiting command:} . qq{\n});

    # get the command
    my $data;
    $client_socket->recv($data,1024);
    print q{recieved: },$data;
    if($data =~ /run task/i) {
        $client_socket->send(q{running tasks} . qq{\n});
        run_tasks($schema);
    } else {
        $client_socket->send(q{unknown command} . qq{\n});
    }
}

$socket->close();
