package Test::HomeAutomation::Controller::ChangePassword;

use Test::Class::Moose extends => 'Test::HomeAutomation::Controller';

sub test_basic_user {
    my ($self) = @_;

    $self->login(q{test03});
    my $ua = $self->{ua};
    $ua->get(q{/appliances});

    $ua->follow_link_ok({ text => q{Change Password} }, q{can get to the change password form});
    $ua->title_is(q{Change Password}, q{check we are actually on the change password page});
    $ua->submit_form(
        fields => {
            current_password  => q{mypass},
            new_password      => q{newpass},
            new_password_conf => q{newpass},
        }
    );
    $ua->get(q{/logout});
    $ua->submit_form(
        fields => {
            username => q{test03},
            password => q{newpass},
        }
    );
    $ua->title_is(q{Appliance List}, q{can change password});
    $ua->follow_link_ok({ text => q{Change Password} }, q{can get to the change password form});
    $ua->submit_form(
        fields => {
            current_password  => q{mypass},
            new_password      => q{newpass},
            new_password_conf => q{newpass},
        }
    );
    $ua->content_contains(q{incorrect password}, q{using old password says they're incorrect});
    $ua->submit_form(
        fields => {
            current_password  => q{newpass},
            new_password      => q{mypass},
            new_password_conf => q{newpass},
        }
    );
    $ua->content_contains(q{The password confirmation does not match the password}, q{password mismatch});
    $ua->submit_form(
        fields => {
            current_password  => q{newpass},
            new_password      => q{mypass},
            new_password_conf => q{mypass},
        }
    );
    $ua->content_contains(q{Password Changed}, q{password changed successfully});

    return 1;
}

sub test_privileged_user {
    my ($self) = @_;

    $self->login(q{test02});
    my $ua = $self->{ua};
    $ua->get(q{/appliances/list});
    $ua->follow_link_ok({ text => q{Change Password} }, q{can get to the change password form});
    $ua->title_is(q{Change Password}, q{check we are actually on the change password page});

    return 1;
}

sub test_admin_user {
    my ($self) = @_;

    $self->login(q{test03});
    my $ua = $self->{ua};
    $ua->get(q{/appliances/list});

    $ua->follow_link_ok({ text => q{Change Password} }, q{can get to the change password form});
    $ua->title_is(q{Change Password}, q{check we are actually on the change password page});

    return 1;
}

1;

__END__

=head1 NAME

Test::HomeAutomation::Controller::ChangePassword

=head2 DESCRIPTION

Test class for all the change password tests.

=cut
