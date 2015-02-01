#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 15;
use Test::Exception;
use FindBin::libs;
use FakeMochad;

my $fake_mochad = FakeMochad->new();

use Mochad;

# initialise our object with our mocked object
my $light = Mochad->new(address => q{H4}, can_dim => 1);

$fake_mochad->clear_message;
$fake_mochad->return([ q{10/31 22:06:52 Tx PL HouseUnit: H4}, q{10/31 22:06:52 Tx PL House: H Func: On} ]);
ok $light->on(), q{can turn the light on};
is $fake_mochad->message, q{pl H4 on} . "\n", q{light on sends the correct message};

$fake_mochad->clear_message;
$fake_mochad->return([ q{10/31 22:07:50 Tx PL HouseUnit: H4}, q{10/31 22:07:50 Tx PL House: H Func: Off}, ]);
ok $light->off(), q{can turn the light off};
is $fake_mochad->message, q{pl H4 off} . "\n", q{light off sends the correct message};

$fake_mochad->clear_message;
$fake_mochad->return([ q{10/31 22:06:52 Tx PL HouseUnit: H4}, q{10/31 22:07:50 Tx PL} ]);
ok !$light->on(), q{returns false if we can't turn the light on};

$fake_mochad->clear_message;
$fake_mochad->return([ q{10/31 22:07:50 Tx PL House: H Func: Off}, ]);
ok !$light->on(), q{returns false if we can't turn the light oni only func received};

$fake_mochad->clear_message;
$fake_mochad->return([ q{10/31 22:07:21 Tx PL HouseUnit: H4}, q{10/31 22:07:21 Tx PL House: H Func: Dim(5)}, ]);
ok $light->dim(5), q{can dim the light};
is $fake_mochad->message, q{pl H4 dim 5} . "\n", q{light dim sends the correct message};

$fake_mochad->clear_message;
$fake_mochad->return([ q{10/31 22:07:44 Tx PL House: H Func: Bright(5)}, q{10/31 22:07:44 Tx PL HouseUnit: H4}, ]);
ok $light->brighten(5), q{can brighten the light};
is $fake_mochad->message, q{pl H4 bright 5} . "\n", q{light brighten sends the correct message};

$fake_mochad->clear_message;
$fake_mochad->return(
    [
        q{10/31 22:06:52 Tx PL HouseUnit: H4},
        q{10/31 22:06:52 Tx PL House: H Func: On},
        q{10/31 22:07:50 Tx PL HouseUnit: H4},
        q{10/31 22:07:50 Tx PL House: H Func: Off},
    ]
);
my $start = time();
ok $light->timer(1), q{can create a timer event};
my $end = time();
ok $end - $start > 0, q{timer waits for at least 1 second};
is $fake_mochad->message, qq{pl H4 on\npl H4 off\n}, q{timer will turn the device on and off};

# make connections fail
$fake_mochad->return_object(0);
throws_ok { $light->on() } qr/Connection failed!/, q{croaks if it can't get a connection};
$fake_mochad->return_object(1);

$fake_mochad->clear_message;
$fake_mochad->return([ q{10/31 22:06:52 Tx PL HouseUnit: H1}, q{10/31 22:06:52 Tx PL House: H Func: Off} ]);
ok !$light->on(), q{false message returned if we didn't get the right information};

1;
