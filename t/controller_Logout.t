use strict;
use warnings;
use Test::More;


use Catalyst::Test 'HomeAutomation';
use HomeAutomation::Controller::Logout;

ok( request('/logout')->is_redirect, 'Request should succeed' );
done_testing();
