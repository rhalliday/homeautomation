package Test::HomeAutomation::Form::ChangePassword;

use Test::Class::Moose extends => 'Test::HomeAutomation::Form';
use HomeAutomation::Form::ChangePassword;

sub test_startup {
    my ($self) = @_;
    $self->next::method;

    my $user_rs = $self->{schema}->resultset(q{User});

    $self->{user} = $user_rs->create(
        {
            username      => q{pwtester},
            password      => q{pwpass},
            email_address => q{pwtester@example.com},
            first_name    => q{pwtester},
            last_name     => q{bill},
            active        => 1,
        }
    );

    return 1;
}

sub test_setup {
    my ($self) = @_;
    $self->next::method;

    $self->{form} = HomeAutomation::Form::ChangePassword->new(user => $self->{user});

    return 1;
}

sub test_teardown {
    my ($self) = @_;

    # make sure we reset any changes to the password
    $self->{user}->update({ password => q{pwpass} });

    $self->{form} = undef;

    $self->next::method;
    return 1;
}

sub test_shutdown {
    my ($self) = @_;

    $self->{user}->delete;
    $self->next::method;

    return 1;
}

sub test_successful_change {
    my ($self) = @_;

    my $params = {
        current_password  => q{pwpass},
        new_password      => q{newpass},
        new_password_conf => q{newpass},
    };

    ok $self->{form}->process(params => $params), q{form processes with correct data};

    return 1;
}

sub test_bad_current_password {
    my ($self) = @_;

    my $params = {
        current_password  => q{pwdpass},
        new_password      => q{newpass},
        new_password_conf => q{newpass},
    };

    ok !$self->{form}->process(params => $params), q{form doesn't process with incorrect current_password};
    ok $self->{form}->field(q{current_password})->has_errors, q{current_password has errors};

    return 1;
}

sub test_mismatch_new_passwords {
    my ($self) = @_;

    my $params = {
        current_password  => q{pwpass},
        new_password      => q{fatfingerewpass},
        new_password_conf => q{newpass},
    };

    ok !$self->{form}->process(params => $params), q{new passwords don't match};
    ok $self->{form}->field(q{new_password_conf})->has_errors, q{mismatch is highlighted};

    return 1;
}

1;

__END__

=head1 NAME

Test::HomeAutomation::Form::ChangePassword

=head2 DESCRIPTION

Test the ChangePassword Form.

=cut
