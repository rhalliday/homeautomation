#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use Catalyst::Test 'HomeAutomation';

ok( request('/login')->is_success, 'Request should succeed' );

done_testing();
