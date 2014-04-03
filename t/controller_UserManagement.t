use strict;
use warnings;
use Test::More;

BEGIN {
    $ENV{CATALYST_DEBUG} = 0; # turn off debugging for cleaner results
}

use Catalyst::Test 'HomeAutomation';
use HomeAutomation::Controller::UserManagement;

ok( request('/usermanagement')->is_redirect, 'Request should redirect' );
done_testing();
