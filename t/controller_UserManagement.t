use strict;
use warnings;
use Test::More;


use Catalyst::Test 'HomeAutomation';
use HomeAutomation::Controller::UserManagement;

ok( request('/usermanagement')->is_redirect, 'Request should redirect' );
done_testing();
