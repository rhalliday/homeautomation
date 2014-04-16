package Test::HomeAutomation::Form::User;

use strict;
use warnings;

use Test::Class::Moose extends => 'Test::HomeAutomation::Form';
use HomeAutomation::Form::User;

our $VERSION = '1.00';

sub test_startup {
    my ($self) = @_;
    $self->next::method;

    my $user_rs = $self->{schema}->resultset(q{User});

    $self->{dupe_user} = $user_rs->create(
        {
            username      => q{rob},
            password      => q{mypass},
            first_name    => q{rob},
            last_name     => q{e},
            email_address => q{rob.e@example.com},
            active        => 1,
        }
    );

    $self->{user} = $user_rs->new_result({});

    return 1;
}

sub test_setup {
    my ($self) = @_;
    $self->next::method;

    $self->{form} = HomeAutomation::Form::User->new(item => $self->{user});

    return 1;
}

sub test_teardown {
    my ($self) = @_;

    $self->{form} = undef;

    $self->next::method;
    return 1;
}

sub test_shutdown {
    my ($self) = @_;

    $self->{user}->delete;
    $self->{dupe_user}->delete;
    $self->next::method;

    return 1;
}

sub test_successful_change {
    my ($self) = @_;

    my $params = {
        username      => q{bob},
        password      => q{mypass},
        first_name    => q{bob},
        last_name     => q{e},
        email_address => q{bob.e@example.com},
        active        => 1,
    };

    ok $self->{form}->process(params => $params), q{form processes with correct data}
      or diag(join("\n", $self->{form}->errors));

    return 1;
}

sub test_bad_username {
    my ($self) = @_;

    my $params = {
        username      => undef,
        password      => q{mypass},
        first_name    => q{bob},
        last_name     => q{e},
        email_address => q{bob.e@example.com},
        active        => 1,
    };

    ok !$self->{form}->process(params => $params), q{form fails with no username};

    ok $self->{form}->field(q{username})->has_errors, q{username field has errors};
    eq_or_diff $self->{form}->field(q{username})->errors, [q{Username field is required}],
      q{username has the right message};

    $params = {
        username      => q{rob},
        password      => q{mypass},
        first_name    => q{bob},
        last_name     => q{e},
        email_address => q{bob.e@example.com},
        active        => 1,
    };

    ok !$self->{form}->process(params => $params), q{form fails with dupe username};

    ok $self->{form}->field(q{username})->has_errors, q{username field has errors - dupe};
    eq_or_diff $self->{form}->field(q{username})->errors, [q{Duplicate value for Username}],
      q{username has the right message - dupe};

    return 1;
}

sub test_bad_password {
    my ($self) = @_;

    my $params = {
        username      => q{bob},
        password      => undef,
        first_name    => q{bob},
        last_name     => q{e},
        email_address => q{bob.e@example.com},
        active        => 1,
    };

    ok !$self->{form}->process(params => $params), q{form fails with no password};

    ok $self->{form}->field(q{password})->has_errors, q{password field has errors};
    eq_or_diff $self->{form}->field(q{password})->errors, [q{Please enter a password in this field}],
      q{password has the right message};

    $params = {
        username      => q{bob},
        password      => 1234,
        first_name    => q{bob},
        last_name     => q{e},
        email_address => q{bob.e@example.com},
        active        => 1,
    };

    ok !$self->{form}->process(params => $params), q{form fails with all digit password};
    ok $self->{form}->field(q{password})->has_errors, q{password field has errors - all digit};
    eq_or_diff $self->{form}->field(q{password})->errors, [q{Must not be all digits}],
      q{password has the right message - all digit};

    $params = {
        username      => q{bob},
        password      => q{hey dude},
        first_name    => q{bob},
        last_name     => q{e},
        email_address => q{bob.e@example.com},
        active        => 1,
    };

    ok !$self->{form}->process(params => $params), q{form fails with all spaced password};
    ok $self->{form}->field(q{password})->has_errors, q{password field has errors - spaced};
    eq_or_diff $self->{form}->field(q{password})->errors, [q{Must not contain spaces}],
      q{password has the right message - spaced};

    return 1;
}

sub test_bad_email {
    my ($self) = @_;

    my $params = {
        username      => q{bob},
        password      => q{mypass},
        first_name    => q{bob},
        last_name     => q{e},
        email_address => q{bob.e},
        active        => 1,
    };

    ok !$self->{form}->process(params => $params), q{form fails with bad email};

    ok $self->{form}->field(q{email_address})->has_errors, q{email field has errors};
    eq_or_diff $self->{form}->field(q{email_address})->errors, [q{Email is not valid}],
      q{email_address has the right message};

    $params = {
        username      => q{bob},
        password      => q{mypass},
        first_name    => q{bob},
        last_name     => q{e},
        email_address => undef,
        active        => 1,
    };

    ok !$self->{form}->process(params => $params), q{form fails with no email};

    ok $self->{form}->field(q{email_address})->has_errors, q{email field has errors - no email};
    eq_or_diff $self->{form}->field(q{email_address})->errors, [q{Email address field is required}],
      q{email_address has the right message - no email};

    return 1;
}

1;

__END__

=head1 NAME

Test::HomeAutomation::Form::User

=head2 DESCRIPTION

Test the User Form.

=cut

