use strict;
use warnings;
use Test::More;

BEGIN {
    $ENV{CATALYST_DEBUG} = 0; # turn off debugging for cleaner results
}

use Catalyst::Test 'HomeAutomation';
use HomeAutomation::Controller::Logout;

ok( request('/logout')->is_redirect, 'Request should succeed' );
done_testing();
