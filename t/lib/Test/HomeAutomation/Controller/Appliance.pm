package Test::HomeAutomation::Controller::Appliance;

use Test::Class::Moose extends => 'Test::HomeAutomation::Controller';

sub test_user_view {
    my ($self) = @_;

    # save some typing
    my $ua = $self->get_user_agent();

    # test03 is our user with the least privileges
    # should only be able to turn things on and off and look at them

    $ua->get_ok(q{http://localhost/login?username=test03&password=mypass}, q{Login 'test03'});

    $ua->follow_link_ok({n=>3}, q{can get the appliance list});
    $ua->base_like(qr/appliances\/list/, q{we are now on the appliance list page});
    $ua->title_is(q{Appliance List}, q{login redirects to appliance list});
    
    return 1;
}

sub get_user_agent {
    # get to the login page and perform some checks
    # returns a user agent;
    my ($self) = @_;

    my $ua = Test::WWW::Mechanize::Catalyst->new;

    $ua->get_ok(q{http://localhost/}, q{Should redirect to login});

    $ua->title_is(q{Login}, q{Check for login title});

    $ua->content_contains(q{Username}, q{check that the page contains the right information}); 

    return $ua;
}

1;
