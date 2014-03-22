use strict;
use warnings;
use Test::More;


use Catalyst::Test 'HomeAutomation';
use HomeAutomation::Controller::UserManagement;

ok( request('/usermanagement')->is_success, 'Request should succeed' );
done_testing();
