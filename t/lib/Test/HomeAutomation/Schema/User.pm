package Test::HomeAutomation::Schema::User;

use Test::Class::Moose extends => 'Test::HomeAutomation::Schema';

sub test_startup {
    my ($self) = @_;

    $self->next::method();

    $self->{resultset} = $self->{schema}->resultset(q{User});

    # get a list of role id's
    my @roles = $self->{schema}->resultset(q{Role})->all;
    $self->{roles} = {};
    for my $role (@roles) {
        $self->{roles}{$role->role} = $role->id;
    }

    return 1;
}

sub test_admin_role {
    my ($self) = @_;

    my $role = q{admin};

    # create a user with the admin role
    my $user = $self->{resultset}->create(
        {
            username => $role,
            password => q{mypass},
            email_address => $role . q{@example.com},
            first_name => $role,
            last_name => q{user},
            active => 1,
            user_roles => [ { role_id => $self->{roles}->{$role} } ],
        }
    );

    $self->_role_test($user, $role);

    $user->delete;
    return 1;
}

sub test_user_role {
    my ($self) = @_;

    my $role = q{user};

    # create a user with the user role
    my $user = $self->{resultset}->create(
        {
            username => $role,
            password => q{mypass},
            email_address => $role . q{@example.com},
            first_name => $role,
            last_name => q{user},
            active => 1,
            user_roles => [ { role_id => $self->{roles}->{$role} } ],
        }
    );

    $self->_role_test($user, $role);

    $user->delete;
    return 1;
}

sub test_usermanagement_role {
    my ($self) = @_;

    my $role = q{usermanagement};

    # create a user with the user role
    my $user = $self->{resultset}->create(
        {
            username => $role,
            password => q{mypass},
            email_address => $role . q{@example.com},
            first_name => $role,
            last_name => q{user},
            active => 1,
            user_roles => [ { role_id => $self->{roles}->{$role} } ],
        }
    );

    $self->_role_test($user, $role);

    $user->delete;
    return 1;
}

sub test_schedule_role {
    my ($self) = @_;

    my $role = q{schedule};

    # create a user with the user role
    my $user = $self->{resultset}->create(
        {
            username => $role,
            password => q{mypass},
            email_address => $role . q{@example.com},
            first_name => $role,
            last_name => q{user},
            active => 1,
            user_roles => [ { role_id => $self->{roles}->{$role} } ],
        }
    );

    $self->_role_test($user, $role);

    $user->delete;
    return 1;
}

sub test_all_roles {
    my ($self) = @_;

    my @user_roles;
    my @roles;
    for my $role (keys %{$self->{roles}}) {
        push @user_roles, { role_id => $self->{roles}{$role} };
        push @roles, $role;
    }

    @roles = sort @roles;

    # create a user with the user role
    my $user = $self->{resultset}->create(
        {
            username => q{test},
            password => q{mypass},
            email_address => q{test@example.com},
            first_name => q{test},
            last_name => q{user},
            active => 1,
            user_roles => \@user_roles,
        }
    );

    for my $role (@roles) {
        ok $user->has_role($role), q{user has role } . $role;
    }

    is $user->role_list, join(q{, }, @roles), q{correct role list is returned};

    ok $user->deactivate_allowed_by($user), q{usermanagement can deactivate a user};
    ok $user->delete_allowed_by($user), q{admin can delete a user};

    $user->delete;
    return 1;
}

sub _role_test {
    my ($self, $user, $role) = @_;
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

    return 1;
}

1;
