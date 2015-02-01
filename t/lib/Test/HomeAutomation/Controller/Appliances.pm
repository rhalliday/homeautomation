package Test::HomeAutomation::Controller::Appliances;

use strict;
use warnings;

use Test::Class::Moose extends => 'Test::HomeAutomation::Controller';
use Readonly;

Readonly::Scalar my $FIRST_FREE    => 3;
Readonly::Scalar my $TOTAL_DEVICES => 16;

Readonly::Scalar my $TV_SWITCH_LINK => q{http://localhost/appliances/address/F1/switch};
Readonly::Scalar my $DIM_LINK       => q{http://localhost/appliances/address/F2/dim/5};

Readonly::Hash my %CONTENT => (
    schedule_list => q{/schedules/list">Schedules</a>},
    user_list     => q{/usermanagement/list">Users</a>},
    change_pass   => q{/usermanagement/change_password">Change Password</a>},
    logout        => q{/logout">Logout</a>},
    tv_column     => q{<td><span class="device-icon" style="background:#FFFFFF"></span>T.V.</td>},
    tv_address    => q{<td>F1</td>},
    create_button => q{/appliances/create" class="btn btn-primary">Create</a>},
    lights        => q{<td><span class="device-icon" style="background:#000000"></span>Lights</td>},
    no_device     => q{<p>No devices in this room</p>},
);

Readonly::Hash my %RE => (
    tv_switch_off   => qr{onclick="FreezeScreen[(]'$TV_SWITCH_LINK'[)]"\s*/>},
    tv_switch_on    => qr{onclick="FreezeScreen[(]'$TV_SWITCH_LINK'[)]"\s*checked\s*/>},
    delete_button   => qr{class="btn btn-sm btn-danger"\s*>\s*Delete\s*</a>},
    edit_button     => qr{class="btn btn-sm btn-info"\s*>\s*Edit\s*</a>},
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
    $ua->get(q{/appliances/address/F1/delete});
    $ua->content_contains(q{Permission Denied}, q{test02 gets permission denied if they try to delete});

    return 1;
}

sub test_admin_user {
    my ($self) = @_;

    $self->_basic_checks(q{test01}, { create => 1, schedule => 1, user => 1 });

    my $ua = $self->{ua};

    # index page
    $ua->get_ok(q{/appliances}, q{index redirects to list});
    $ua->title_is(q{Appliance List}, q{check the title is correct});

    # create appliance
    $ua->get_ok(q{/appliances/create}, q{can create an appliance});
    $ua->title_is(q{Create/Update Appliance}, q{check we are on the create page});
    $ua->submit_form_ok(
        {
            fields => {
                device   => 'Lights',
                room     => 7,
                status   => 1,
                protocol => 'pl',
                colour   => '#000001',
            }
        },
        q{can submit the form create}
    );
    $ua->title_is(q{Appliance List}, q{get redirected to the appliance list});
    $ua->content_contains(q{<td><span class="device-icon" style="background:#000001"></span>Lights</td>},
        q{new device is listed});
    $ua->content_contains(q{<td>F3</td>}, q{new device is listed at address F3});

    $ua->get_ok(q{/appliances/address/F3/edit}, q{can get to the edit page for the new appliance});
    $ua->submit_form_ok(
        {
            fields => {
                device   => 'Lighters',
                room     => 7,
                status   => 1,
                protocol => 'pl',
            }
        },
        q{can submit the edit form}
    );
    $ua->title_is(q{Appliance List}, q{get redirected to the appliance list after edit});
    $ua->content_contains(q{<td><span class="device-icon" style="background:#000001"></span>Lighters</td>},
        q{device name has changed});

    $ua->get_ok(q{/appliances/address/F3/delete}, q{can delete our new device});
    $ua->content_lacks(q{<td>F3</td>}, q{our new device no longer exists});

    $ua->get(q{/appliances/address/F30/edit});
    $ua->content_contains(q{Page not found}, q{page not found is returned for an unknown device});

    # fill up all the devices
    for my $address ($FIRST_FREE .. $TOTAL_DEVICES) {
        $ua->get_ok(qq{/appliances/address/F$address/edit}, qq{getting F$address});
        $ua->submit_form(
            fields => {
                device   => 'blah',
                room     => 7,
                status   => 1,
                protocol => 'pl',
            }
        );
    }

    # check a redirect for no more devices
    $ua->get(q{/appliances/create});

    #TODO: need to change what happens when we run out
    $ua->content_contains(q{Page not found}, q{page not found is returned when we run out of devices});

    # clear the devices
    for my $address ($FIRST_FREE .. $TOTAL_DEVICES) {
        $ua->get(qq{/appliances/address/F${address}/delete});
    }

    return 1;
}

# args should have switches for
# create, user, schedule
sub _basic_checks {
    my ($self, $user, $args) = @_;

    $self->login($user);
    my $ua = $self->{ua};
    $ua->get_ok(q{http://localhost/}, q{Check index page});
    $ua->title_is(q{Appliance List}, q{Check redirect to appliance list after log in});

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
        $ua->content_contains($CONTENT{tv_address}, q{should be able to see the address});
        $ua->content_like($RE{delete_button}, q{should be able to delete appliances});
        $ua->content_like($RE{edit_button},   q{should be able to edit appliances});
        $ua->content_contains($CONTENT{create_button}, q{should be able to create devices});
    } else {
        $ua->content_lacks($CONTENT{tv_address}, q{shouldn't be able to see the address});
        $ua->content_unlike($RE{delete_button}, q{shouldn't be able to delete appliances});
        $ua->content_unlike($RE{edit_button},   q{shouldn't be able to edit appliances});
        $ua->content_lacks($CONTENT{create_button}, q{shouldn't be able to create devices});
    }

    $ua->content_contains($CONTENT{change_pass}, q{should be able to change their password});
    $ua->content_contains($CONTENT{logout},      q{should be able to logout});
    $ua->content_contains($CONTENT{tv_column},   q{can see the T.V appliance});
    $ua->content_like($RE{tv_switch_on}, q{can see the switch for the T.V.});

    # user switch
    $self->set_up_mochad([ q{10/31 22:06:52 Tx PL HouseUnit: F1}, q{10/31 22:06:52 Tx PL House: F Func: Off} ]);
    $ua->get_ok($TV_SWITCH_LINK, q{can click the switch 'button'});
    $ua->content_like($RE{tv_switch_off}, q{T.V. switch is now set to off});
    $self->set_up_mochad([ q{10/31 22:06:52 Tx PL HouseUnit: F1}, q{10/31 22:06:52 Tx PL House: F Func: On} ]);
    $ua->get_ok($TV_SWITCH_LINK, q{can click the switch 'button' again});
    $ua->content_like($RE{tv_switch_on}, q{T.V. switch is now set to on});

    # dim stuff
    $self->set_up_mochad([ q{10/31 22:06:52 Tx PL HouseUnit: F2}, q{10/31 22:06:52 Tx PL House: F Func: Bright} ]);
    $self->{appliances}[1]->status(1);    # make sure the light is on
    $ua->get_ok($DIM_LINK, q{can dim/brighten the light});

    # room with another device
    $ua->get_ok(q{/appliances/list?room=Imogen}, q{can go to another room});
    $ua->content_contains($CONTENT{lights}, q{Imogen's room has a lights device});

    # room with no device
    $ua->get_ok(q{/appliances/list?room=Master}, q{can get to the master room});
    $ua->content_contains($CONTENT{no_device}, q{master room has no devices});

    $ua->get_ok(q{http://localhost/}, q{back to index page});
    return 1;
}

1;

__END__

=head1 NAME

Test::HomeAutomation::Controller::Appliances

=head2 DESCRIPTION

Test class for all the appliance tests.

=cut
