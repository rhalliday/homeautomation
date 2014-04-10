package Test::HomeAutomation::Schema::User;

use Test::Class::Moose extends => 'Test::HomeAutomation::Schema';

use Readonly;

Readonly my @ROLES => (qw(admin schedule user usermanagement));

sub test_startup {
    my ($self) = @_;

    $self->next::method();

    $self->{resultset} = $self->{schema}->resultset(q{User});

    return 1;
}

sub test_admin_role {
    my ($self) = @_;

    $self->_role_test(q{admin});

    return 1;
}

sub test_user_role {
    my ($self) = @_;

    $self->_role_test(q{user});

    return 1;
}

sub test_usermanagement_role {
    my ($self) = @_;

    $self->_role_test(q{usermanagement});

    return 1;
}

sub test_schedule_role {
    my ($self) = @_;

    $self->_role_test(q{schedule});

    return 1;
}

sub test_all_roles {
    my ($self) = @_;

    # create a user with the user role
    my $user = $self->{resultset}->create(
        {
            username => q{test},
            password => q{mypass},
            email_address => q{test@example.com},
            first_name => q{test},
            last_name => q{user},
            active => 1,
        }
    );


    my @roles = $self->{schema}->resultset('Role')->all;
    $user->set_roles(\@roles);

    for my $role (@ROLES) {
        ok $user->has_role($role), q{user has role } . $role;
    }

    is $user->role_list, join(q{, }, @ROLES), q{correct role list is returned};

    ok $user->deactivate_allowed_by($user), q{usermanagement can deactivate a user};
    ok $user->delete_allowed_by($user), q{admin can delete a user};

    $user->delete;
    return 1;
}

sub _role_test {
    my ($self, $role) = @_;

    my $user = $self->{resultset}->create(
        {
            username => $role,
            password => q{mypass},
            email_address => $role . q{@example.com},
            first_name => $role,
            last_name => q{user},
            active => 1,
        }
    );

    my $role_rs = $self->{schema}->resultset('Role')->find({role => $role});
    $user->add_to_roles($role_rs);

    # run the same test on each role
    ok $user->has_role($role), $role . q{ user has the correct role};
    ok !$user->has_role(q{test}), q{ user doesn't have the test role};

    $user->deactivate;
    ok !$user->active, q{deactivate deactivates the user};
    $user->deactivate;
    ok $user->active, q{deactivate can also reactivate the user};

    is $user->full_name, $role . q{ user}, q{correct full name is returned};
    is $user->role_list, $role, q{correct role list is returned};

    if ( $role eq q{usermanagement} ) {
        ok $user->deactivate_allowed_by($user), q{only usermanagement can deactivate a user};
    } else {
        ok !$user->deactivate_allowed_by($user), q{only usermanagement can deactivate a user};
    }

    if ( $role eq q{admin} ) {
        ok $user->delete_allowed_by($user), q{only admin can delete a user};
    } else {
        ok !$user->delete_allowed_by($user), q{only admin can delete a user};
    }

    $user->delete;

    return 1;
}

1;
