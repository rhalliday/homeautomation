use strict;
use warnings;
use Test::More;


use Catalyst::Test 'HomeAutomation';
use HomeAutomation::Controller::Appliances;

ok( request('/appliances')->is_redirect, 'Request should succeed' );
done_testing();
