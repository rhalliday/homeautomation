package Test::HomeAutomation::Controller::Rooms;

use strict;
use warnings;

use Test::Class::Moose extends => 'Test::HomeAutomation::Controller';
use Readonly;

Readonly::Hash my %CONTENT => (
    change_pass   => q{/usermanagement/change_password">Change Password</a>},
    logout        => q{/logout">Logout</a>},
    room_column   => q{<td>Lounge</td>},
    create_button => q{/rooms/create" class="btn btn-primary">Create</a>},
);

Readonly::Hash my %RE => (
    delete_button => qr{class="btn btn-sm btn-danger"\s*>\s*Delete\s*</a>},
    edit_button   => qr{class="btn btn-sm btn-info"\s*>\s*Edit\s*</a>},
);

our $VERSION = '1.00';

sub test_basic_user {
    my ($self) = @_;

    $self->_basic_checks(q{test03}, { create => 0 });

    return 1;
}

sub test_privileged_user {
    my ($self) = @_;

    $self->_basic_checks(q{test02}, { create => 0 });

    my $ua = $self->{ua};
    $ua->get(q{/rooms/1/delete});
    $ua->content_contains(q{Permission Denied}, q{test02 gets permission denied if they try to delete});

    return 1;
}

sub test_admin_user {
    my ($self) = @_;

    $self->_basic_checks(q{test01}, { create => 1, schedule => 1, user => 1 });

    my $ua = $self->{ua};

    # index page
    $ua->get_ok(q{/rooms/list}, q{get the rooms list});
    $ua->title_is(q{Room List}, q{check the title is correct});

    # create appliance
    $ua->get_ok(q{/rooms/create}, q{can create a room});
    $ua->title_is(q{Create/Update Room}, q{check we are on the create page});
    $ua->submit_form_ok(
        {
            fields => {
                name => q{Ballroom},
            }
        },
        q{can submit the form create}
    );
    $ua->title_is(q{Room List}, q{get redirected to the room list});
    $ua->content_contains(q{<td>Ballroom</td>}, q{new room is listed});

    my $id = $self->{room_count} + 1;
    $ua->get_ok(qq{/rooms/$id/edit}, q{can get to the edit page for the new room});
    $ua->submit_form_ok(
        {
            fields => {
                name => 'Dance Floor',
            }
        },
        q{can submit the edit form}
    );
    $ua->title_is(q{Room List}, q{get redirected to the room list after edit});
    $ua->content_contains(q{<td>Dance Floor</td>}, q{room name has changed});

    $ua->get_ok(qq{/rooms/$id/delete}, q{can delete our new room});
    $ua->content_lacks(q{<td>Dance Floor</td>}, q{our new room no longer exists});

    $ua->get(qq{/rooms/$id/edit});
    $ua->content_contains(q{Page not found}, q{page not found is returned for an unknown room});

    return 1;
}

# args should have switches for
# create
sub _basic_checks {
    my ($self, $user, $args) = @_;

    $self->login($user);
    my $ua = $self->{ua};
    $ua->get_ok(q{http://localhost/rooms}, q{Check index page});
    $ua->title_is(q{Room List}, q{Check redirect to room list});

    if ($args->{create}) {
        $ua->content_like($RE{delete_button}, q{should be able to delete rooms});
        $ua->content_like($RE{edit_button},   q{should be able to edit rooms});
        $ua->content_contains($CONTENT{create_button}, q{should be able to create rooms});
    } else {
        $ua->content_unlike($RE{delete_button}, q{shouldn't be able to delete rooms});
        $ua->content_unlike($RE{edit_button},   q{shouldn't be able to edit rooms});
        $ua->content_lacks($CONTENT{create_button}, q{shouldn't be able to create rooms});
    }

    $ua->content_contains($CONTENT{change_pass}, q{should be able to change their password});
    $ua->content_contains($CONTENT{logout},      q{should be able to logout});
    $ua->content_contains($CONTENT{room_column}, q{can see the Lounge});

    return 1;
}

1;

__END__

=head1 NAME

Test::HomeAutomation::Controller::Rooms

=head2 DESCRIPTION

Test class for all the rooms controller tests.

=cut
