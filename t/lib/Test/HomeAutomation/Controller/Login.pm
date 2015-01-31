package Test::HomeAutomation::Controller::Login;

use strict;
use warnings;

use Test::Class::Moose extends => 'Test::HomeAutomation::Controller';

our $VERSION = '1.00';

sub test_empty_creds {
    my ($self) = @_;

    my $ua = $self->{ua};
    $ua->get_ok(q{http://localhost/}, q{Check redirect of base URL});
    $ua->title_is(q{Login}, q{Check for login title});
    $ua->submit_form(
        fields => {
            username => q{},
            password => q{},
        }
    );
    $ua->content_contains(q{Empty username or password.}, q{empty username and password gets the right error});

    return 1;
}

sub test_empty_password {
    my ($self) = @_;

    my $ua = $self->{ua};
    $ua->get(q{/login});
    $ua->submit_form(
        fields => {
            username => q{test01},
            password => q{},
        }
    );
    $ua->content_contains(q{Empty username or password.}, q{empty password gets the right error});

    return 1;
}

sub test_empty_username {
    my ($self) = @_;

    my $ua = $self->{ua};
    $ua->get(q{/login});

    $ua->submit_form(
        fields => {
            username => q{},
            password => q{mypass},
        }
    );
    $ua->content_contains(q{Empty username or password.}, q{empty username gets the right error});

    return 1;
}

sub test_bad_user {
    my ($self) = @_;

    my $ua = $self->{ua};
    $ua->get(q{/login});
    $ua->submit_form(
        fields => {
            username => q{test04},
            password => q{mypass},
        }
    );
    $ua->content_contains(q{Bad username or password.}, q{can't login with a user who doesn't exist});

    return 1;
}

sub test_bad_password {
    my ($self) = @_;

    my $ua = $self->{ua};
    $ua->get(q{/login});
    $ua->submit_form(
        fields => {
            username => q{test03},
            password => q{notmypass},
        }
    );
    $ua->content_contains(q{Bad username or password.}, q{can't login with a bad password});

    return 1;
}

1;

__END__

=head1 NAME

Test::HomeAutomation::Controller::Login

=head2 DESCRIPTION

Test class for all the login tests.

=cut
