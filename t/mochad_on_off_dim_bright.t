#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 11;
use Test::MockObject::Extends;
use IO::Socket;

use Mochad;

# set up an IO::Socket object to intercept the messages
my $io_socket = IO::Socket->new();
$io_socket = Test::MockObject::Extends->new($io_socket);
my $message = q{};
$io_socket->mock(q{print}, sub { my ($self, $msg) = @_; $message .= $msg; });

# initialise our object with our mocked object
my $light = Mochad->new(address => q{H4}, can_dim => 1, connection => $io_socket);

$message = q{};
ok $light->on(), q{can turn the light on};
is $message, q{pl H4 on} . "\n", q{light on sends the correct message};

$message = q{};
ok $light->off(), q{can turn the light off};
is $message, q{pl H4 off} . "\n", q{light off sends the correct message};

$message = q{};
ok $light->dim(), q{can dim the light};
is $message, q{pl H4 dim} . "\n", q{light dim sends the correct message};

$message = q{};
ok $light->brighten(), q{can brighten the light};
is $message, q{pl H4 bright} . "\n", q{light brighten sends the correct message};

$message = q{};
my $start = time();
ok $light->timer(1), q{can create a timer event};
my $end = time();
ok $end - $start > 0, q{timer waits for at least 1 second};
is $message, qq{pl H4 on\npl H4 off\n}, q{timer will turn the device on and off};

1;
