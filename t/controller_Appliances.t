use strict;
use warnings;
use Test::More;

BEGIN {
    $ENV{CATALYST_DEBUG} = 0; # turn off debugging for cleaner results
}

use Catalyst::Test 'HomeAutomation';
use HomeAutomation::Controller::Appliances;

ok( request('/appliances')->is_redirect, 'Request should succeed' );
done_testing();
