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
    $ua->title_is(q{Login}, q{empty username and password stays on the login page});

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
    $ua->title_is(q{Login}, q{empty password stays on the login page});

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
    $ua->title_is(q{Login}, q{empty username stays on the login page});

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

sub test_inactive_user {
    my ($self) = @_;

    my $user = $self->{schema}->resultset(q{User})->create(
        {
            username      => q{test04},
            password      => q{mypass},
            email_address => q{test03@example.com},
            first_name    => q{test04},
            last_name     => q{Inactive},
            active        => 0,
            user_roles    => [ map { { role_id => $_->id } } $self->{schema}->resultset(q{Role})->search({ role => [q{user}] })->all ],
        },
    );
    my $ua = $self->{ua};
    $ua->get(q{/login});
    $ua->submit_form(
        fields => {
            username => q{test04},
            password => q{mypass},
        }
    );
    $ua->content_contains(q{You no longer have access to this awesome application}, q{can't login if not active});

    $user->delete;
    return 1;
}

sub test_redirect {
    my ($self) = @_;

    my $ua  = $self->{ua};
    my $url = q{/appliances/list?room=Amber};
    $ua->get($url);
    $ua->title_is(q{Login}, q{Check for login title});
    $ua->submit_form(
        fields => {
            username => q{test03},
            password => q{mypass},
        }
    );
    $url =~ s/[?]/[?]/;    #escape the ?
    $ua->content_like(qr{<li class="active">\s*<a href="http://localhost$url">}, q{get redirected to Amber's room});

    return 1;
}

1;

__END__

=head1 NAME

Test::HomeAutomation::Controller::Login

=head2 DESCRIPTION

Test class for all the login tests.

=cut
