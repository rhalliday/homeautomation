package Test::HomeAutomation::Controller::Scenes;

use strict;
use warnings;

use Test::Class::Moose extends => 'Test::HomeAutomation::Controller';
use Readonly;

Readonly::Hash my %CONTENT => (
    schedule_list => q{/schedules/list">Schedules</a>},
    user_list     => q{/usermanagement/list">Users</a>},
    change_pass   => q{/usermanagement/change_password">Change Password</a>},
    logout        => q{/logout">Logout</a>},
    scene_column  => q{<td>evening mode</td>},
    create_button => q{/scenes/create" class="btn btn-primary">Create</a>},
);

Readonly::Hash my %RE => (
    delete_button   => qr{class="btn btn-sm btn-danger hidden-xs"\s*>\s*Delete\s*</a>},
    edit_button     => qr{class="btn btn-sm btn-info hidden-xs"\s*>\s*Edit\s*</a>},
    schedule_button => qr{class="btn btn-sm btn-primary"\s*>\s*Schedule\s*</a>},
);

our $VERSION = '1.00';

sub test_basic_user {
    my ($self) = @_;

    $self->_basic_checks(q{test03}, { create => 0, user => 0, schedule => 0 });

    return 1;
}

sub test_privileged_user {
    my ($self) = @_;

    $self->_basic_checks(q{test02}, { create => 0, user => 1, schedule => 1 });

    my $ua = $self->{ua};
    $ua->get(q{/scenes/1/delete});
    $ua->content_contains(q{Permission Denied}, q{test02 gets permission denied if they try to delete});

    return 1;
}

sub test_admin_user {
    my ($self) = @_;

    $self->_basic_checks(q{test01}, { create => 1, schedule => 1, user => 1 });

    my $ua = $self->{ua};

    # index page
    $ua->get_ok(q{/scenes/list}, q{index redirects to list});
    $ua->title_is(q{Scene List}, q{check the title is correct});

    # create scene
    $ua->get_ok(q{/scenes/create}, q{can create a scene});
    $ua->title_is(q{Create/Update Scene}, q{check we are on the create page});
    $ua->submit_form_ok(
        {
            fields => {
                name  => 'night mode',
                room  => 7,
                scene => <<'EOJ',
[{"dimable":1,"device":"light1","room":"Lounge","address":"F2","state":"off"},{"device":"light2","address":"F6","room":"Lounge","dimable":1,"state":"off"}]
EOJ
            }
        },
        q{can submit the form create}
    );
    $ua->title_is(q{Scene List}, q{get redirected to the scene list});
    $ua->content_contains(q{<td>night mode</td>}, q{new scene is listed});

    $ua->get_ok(q{/scenes/2/edit}, q{can get to the edit page for the new scene});
    $ua->submit_form_ok(
        {
            fields => {
                name  => 'dark mode',
                scene => <<'EOJ',
[{"dimable":1,"device":"light1","room":"Lounge","address":"F2","state":"off"},{"device":"light2","address":"F6","room":"Lounge","dimable":1,"state":"off"}]
EOJ
            }
        },
        q{can submit the edit form}
    );
    $ua->title_is(q{Scene List}, q{get redirected to the scene list after edit});
    $ua->content_contains(q{<td>dark mode</td>}, q{scene name has changed});

    # run a scene
    $self->set_up_mochad([ q{10/31 22:06:52 Tx PL HouseUnit: F2}, q{10/31 22:06:52 Tx PL House: F Func: Off} ]);
    $ua->get_ok(q{/scenes/2/run?selected_room=Lounge}, q{can run the scene});
    is $self->{fake_mochad}->message, q{pl F2 off} . "\n",
      q{dark mode should only trigger one command as F6 doesn't exist};
    $ua->title_is(q{Appliance List}, q{get redirected to the appliance list after run});
    $ua->content_contains(q{<td class="hidden-xs">F1</td>}, q{we are placed back in the lounge});

    # run a broken scene
    $self->{fake_mochad}->return_object(0);
    $ua->get_ok(q{/scenes/2/run?selected_room=Lounge}, q{can run the broken scene});
    $ua->content_like(qr/Unable to connect to device/, q{Error message is displayed});
    $self->{fake_mochad}->return_object(1);

    # schedule a scene
    $ua->get_ok(q{/schedules/create/2/scene_id}, q{can schedule a scene});
    $ua->content_lacks(q{<input type="radio" name="action"}, q{have a form with no action input});

    $ua->get_ok(q{/scenes/2/delete}, q{can delete our new scene});
    $ua->content_lacks(q{<td>dark mode</td>}, q{our new scene no longer exists});

    $ua->get(q{/scenes/2/edit});
    $ua->content_contains(q{Page not found}, q{page not found is returned for an unknown scene});

    return 1;
}

# args should have switches for
# create, user, schedule
sub _basic_checks {
    my ($self, $user, $args) = @_;

    $self->login($user);
    my $ua = $self->{ua};
    $ua->get_ok(q{http://localhost/scenes}, q{Check index page});
    $ua->title_is(q{Scene List}, q{Check redirect to scene list from base});

    if ($args->{schedule}) {
        $ua->content_contains($CONTENT{schedule_list}, q{should be able to see the schedules});
        $ua->content_like($RE{schedule_button}, q{should be able to schedule things});
    } else {
        $ua->content_lacks($CONTENT{schedule_list}, q{should NOT be able to see the schedules});
        $ua->content_unlike($RE{schedule_button}, q{shouldn't be able to schedule anything});
    }

    if ($args->{user}) {
        $ua->content_contains($CONTENT{user_list}, q{should be able to see the other users});
    } else {
        $ua->content_lacks($CONTENT{user_list}, q{should NOT be able to see the other users});
    }

    if ($args->{create}) {
        $ua->content_like($RE{delete_button}, q{should be able to delete appliances});
        $ua->content_like($RE{edit_button},   q{should be able to edit appliances});
        $ua->content_contains($CONTENT{create_button}, q{should be able to create devices});
    } else {
        $ua->content_unlike($RE{delete_button}, q{shouldn't be able to delete appliances});
        $ua->content_unlike($RE{edit_button},   q{shouldn't be able to edit appliances});
        $ua->content_lacks($CONTENT{create_button}, q{shouldn't be able to create devices});
    }

    $ua->content_contains($CONTENT{change_pass},  q{should be able to change their password});
    $ua->content_contains($CONTENT{logout},       q{should be able to logout});
    $ua->content_contains($CONTENT{scene_column}, q{can see the evening mode scene});

    $ua->get_ok(q{http://localhost/scenes/list}, q{back to index page});
    return 1;
}

1;

__END__

=head1 NAME

Test::HomeAutomation::Controller::Scenes

=head2 DESCRIPTION

Test class for all the scenes controller tests.

=cut
