package Test::HomeAutomation::Controller::UserManagement;

use Test::Class::Moose extends => 'Test::HomeAutomation::Controller';

sub test_basic_user {
    my ($self) = @_;

    $self->login(q{test03});
    my $ua = $self->{ua};
    $ua->get(q{/usermanagement/id/2/deactivate});
    $ua->content_contains(q{Permission Denied}, q{test01 gets permission denied if they try to deactivate a user});

    return 1;
}

sub test_privileged_user {
    my ($self) = @_;

    $self->login(q{test02});
    my $ua = $self->{ua};
    $ua->get(q{/appliances});

    $ua->follow_link_ok({ text => q{Users} }, q{can get to the user management page});
    $ua->title_is(q{User List}, q{check we are on the user management page});
    $ua->content_contains(q{test02}, q{we should be able to see ourselves});
    $ua->content_contains(q{test03}, q{we should be able to see another user});
    $ua->content_lacks(q{test01}, q{we should not be able to see admin users});
    $ua->content_lacks(q{Delete}, q{we aren't allowed to delete anybody});
    $ua->content_lacks(q{Edit}, q{we aren't allowed to edit anybody});
    my @switch_links = $ua->find_all_links(text => 'Active');
    $ua->get_ok($switch_links[0]->url, q{can deactivate a user});
    $ua->content_contains(q{Inactive}, q{user is now inactive});
    @switch_links = $ua->find_all_links(text => 'Inactive');
    $ua->get_ok($switch_links[0]->url, q{can reactivate a user});
    $ua->content_lacks(q{Inactive}, q{all users are now active});
    $ua->get_ok(q{/usermanagement}, q{can get usermanagement base url});
    $ua->title_is(q{User List}, q{base url redirects to user list});
    $ua->get(q{/usermanagement/id/3/delete});
    $ua->content_contains(q{Permission Denied}, q{not allowed to delete users});
    return 1;
}

sub test_admin_user {
    my ($self) = @_;

    $self->login(q{test01});
    my $ua = $self->{ua};
    $ua->get(q{/appliances});
    $ua->follow_link_ok({ text => q{Users} }, q{can get to the user management page});
    $ua->title_is(q{User List}, q{check we are on the user management page});
    $ua->content_contains(q{test02}, q{we should be able to see ourselves});
    $ua->content_contains(q{test03}, q{we should be able to see another user});
    $ua->content_contains(q{test01}, q{we should be able to see admin users});
    $ua->content_contains(q{Delete}, q{we are allowed to delete anybody});
    $ua->content_contains(q{Edit}, q{we are allowed to edit anybody});
    my @switch_links = $ua->find_all_links(text => 'Active');
    $ua->get_ok($switch_links[0]->url, q{can deactivate a user});
    $ua->content_contains(q{Inactive}, q{user is now inactive});
    @switch_links = $ua->find_all_links(text => 'Inactive');
    $ua->get_ok($switch_links[0]->url, q{can reactivate a user});
    $ua->content_lacks(q{Inactive}, q{all users are now active});
    # user doesn't exist
    $ua->get(q{/usermanagement/id/22/edit});
    $ua->content_contains(q{Page not found}, q{trying to edit a user that doesn't exist});

    $ua->get_ok(q{/usermanagement/create}, q{admin user can create other users});
    $ua->title_is(q{Create/Update User}, q{we definitely have the create form});
    $ua->submit_form_ok(
        {
            fields => {
                username      => q{test04},
                password      => q{mypass},
                first_name    => q{bob},
                last_name     => q{e},
                email_address => q{bob.e@example.com},
                active        => 1,
                
            }
        },
        q{can submit the create user form}
    );
    $ua->title_is(q{User List}, q{back on user list form});
    $ua->content_contains(q{test04}, q{did create a test04 user});

    $ua->get_ok(q{/usermanagement/id/4/edit}, q{admin user can edit other users});
    $ua->title_is(q{Create/Update User}, q{we definitely have the edit form});
    $ua->submit_form_ok(
        {
            fields => {
                username      => q{test04},
                password      => q{mypass},
                first_name    => q{bobert},
                last_name     => q{e},
                email_address => q{bob.e@example.com},
                active        => 1,
                
            }
        },
        q{can submit the create user form}
    );
    $ua->title_is(q{User List}, q{back on user list form - after edit});
    $ua->content_contains(q{bobert}, q{did edit test04 user});
    
    $ua->get_ok(q{/usermanagement/id/4/delete}, q{can delete the new user});
    $ua->content_lacks(q{test04}, q{test04 has now gone});

    return 1;
}

1;

__END__

=head1 NAME

Test::HomeAutomation::Controller::UserManagement

=head2 DESCRIPTION

Test class for all the usermanagement tests.

=cut
