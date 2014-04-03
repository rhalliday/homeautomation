use strict;
use warnings;
use Test::More;

BEGIN {
    $ENV{CATALYST_DEBUG} = 0; # turn off debugging for cleaner results
}

use Catalyst::Test 'HomeAutomation';
use HomeAutomation::Controller::Login;

ok( request('/login')->is_success, 'Request should succeed' );
done_testing();
