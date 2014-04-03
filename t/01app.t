#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

BEGIN { $ENV{CATALYST_DEBUG} = 0; }

use Catalyst::Test 'HomeAutomation';

ok( request('/login')->is_success, 'Request should succeed' );

done_testing();
