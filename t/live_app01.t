#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;

# Need to specify the name of your app as arg on next line
# Can also do:
#   use Test::WWW::Mechanize::Catalyst "MyApp";

BEGIN { use_ok("Test::WWW::Mechanize::Catalyst" => "HomeAutomation") }

setup_test();

# Create two 'user agents' to simulate two different users ('test01' & 'test02')
my $ua1 = Test::WWW::Mechanize::Catalyst->new;
my $ua2 = Test::WWW::Mechanize::Catalyst->new;

# Use a simplified for loop to do tests that are common to both users
# Use get_ok() to make sure we can hit the base URL
# Second arg = optional description of test (will be displayed for failed tests)
# Note that in test scripts you send everything to 'http://localhost'
$_->get_ok("http://localhost/", "Check redirect of base URL") for $ua1, $ua2;
# Use title_is() to check the contents of the <title>...</title> tags
$_->title_is("Login", "Check for login title") for $ua1, $ua2;
# Use content_contains() to match on text in the html body
$_->content_contains("You need to log in to use this application",
    "Check we are NOT logged in") for $ua1, $ua2;

# Log in as each user
# Specify username and password on the URL
$ua1->get_ok("http://localhost/login?username=test01&password=mypass", "Login 'test01'");
# Could make user2 like user1 above, but use the form to show another way
$ua2->submit_form(
    fields => {
        username => 'test02',
        password => 'mypass',
    });

# Go back to the login page and it should show that we are already logged in
$_->get_ok("http://localhost/login", "Return to '/login'") for $ua1, $ua2;
$_->title_is("Login", "Check for login page") for $ua1, $ua2;
$_->content_contains("Please Note: You are already logged in as ",
    "Check we ARE logged in" ) for $ua1, $ua2;

# 'Click' the 'Logout' link (see also 'text_regex' and 'url_regex' options)
$_->follow_link_ok({n => 4}, "Logout via first link on page") for $ua1, $ua2;
$_->title_is("Login", "Check for login title") for $ua1, $ua2;
$_->content_contains("You need to log in to use this application",
    "Check we are NOT logged in") for $ua1, $ua2;

# Log back in
$ua1->get_ok("http://localhost/login?username=test01&password=mypass",
    "Login 'test01'");
$ua2->get_ok("http://localhost/login?username=test02&password=mypass",
    "Login 'test02'");
# Should be at the Book List page... do some checks to confirm
$_->title_is("Appliance List", "Check for appliance list title") for $ua1, $ua2;

$ua1->get_ok("http://localhost/appliances/list", "'test01' appliance list");
$ua1->get_ok("http://localhost/login", "Login Page");
$ua1->get_ok("http://localhost/appliances/list", "'test01' appliance list");

$_->content_contains("Appliance List", "Check for appliance list title") for $ua1, $ua2;
# Make sure the appropriate logout buttons are displayed
$_->content_contains("/logout\">User Logout</a>",
    "Both users should have a 'User Logout'") for $ua1, $ua2;
$ua1->content_contains("/appliances/create\">Admin Create</a>",
    "'test01' should have a create link");
$ua2->content_lacks("/appliances/create\">Admin Create</a>",
    "'test02' should NOT have a create link");

$ua1->get_ok("http://localhost/appliances/list", "View appliance list as 'test01'");

# User 'test01' should be able to create a book with the "formless create" URL
$ua1->get_ok("http://localhost/appliances/form_create_do?device=Bath&address=B1&protocol=pl&status=1",
    "'test01' create");

$ua1->title_is("Appliance Created", "Appliance created title");
$ua1->content_contains("Added Appliance 'Bath'", "Check device added OK");
$ua1->content_contains("at 'B1'", "Check address added OK");
$ua1->content_contains("using the 'pl' protocol.", "Check protocol added");
$ua1->content_contains("It's current status is set to '1'", "Check status added");

# Make sure the new book shows in the list
$ua1->get_ok("http://localhost/appliances/list", "'test01' appliance list");
$ua1->title_is("Appliance List", "Check logged in and at appliance list");
$ua1->content_contains("Appliance List", "Appliance List page test");
$ua1->content_contains("Bath", "Look for 'Bath'");

# Make sure the new book can be deleted
# Get all the Delete links on the list page
my @delLinks = $ua1->find_all_links(text => 'Delete');
# Use the final link to delete the last book
$ua1->get_ok($delLinks[$#delLinks]->url, 'Delete last appliance');
# Check that delete worked
$ua1->content_contains("Appliance List", "Appliance List page test");
$ua1->content_like(qr/Deleted appliance B1/, "Deleted appliance");

tear_down_test();
done_testing;

sub set_up_test {
    # create a database from the sql
    # create a test01 & test02 user
}

sub tear_down_test {
    # tear down the db
}
