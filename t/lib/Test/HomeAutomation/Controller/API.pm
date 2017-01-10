package Test::HomeAutomation::Controller::API;

use strict;
use warnings;
our $VERSION = '1.00';

use Test::Class::Moose extends => 'Test::HomeAutomation::Controller';
use MIME::Base64 qw/encode_base64/;
use Readonly;

Readonly my $ENDPOINT  => q{/api};
Readonly my $OK_STATUS => 200;

sub test_startup {
    my ($self) = @_;

    $self->next::method();

    my $role_rs = $self->{schema}->resultset(q{Role});

    # inactive user
    $self->{schema}->resultset(q{User})->create(
        {
            username      => q{test04},
            password      => q{mypass},
            email_address => q{test04@example.com},
            first_name    => q{test04},
            last_name     => q{Cameron},
            active        => 0,
            user_roles    => [ map { { role_id => $_->id } } $role_rs->search({ role => [q{user}] })->all ],
        },
    );

    # empty scene
    $self->{schema}->resultset(q{Scene})->create({ name => q{api scene} });

    return 1;
}

sub test_invalid_method {
    my ($self) = @_;

    my $ua = $self->{ua};

    $ua->get_ok($ENDPOINT, q{get returns 200});
    $ua->content_contains(q{Invalid method}, q{but the message says invalid method});
    return 1;
}

sub test_no_auth {
    my ($self) = @_;

    my $ua = $self->{ua};

    $ua->post($ENDPOINT);
    is $ua->status, $OK_STATUS, q{post returns a 200 OK};
    $ua->content_contains(q{Invalid user}, q{but the message is invalid user});

    return 1;
}

sub test_inactive_user {
    my ($self) = @_;

    $self->_make_post(q{test04:mypass});
    $self->{ua}->content_contains(q{Invalid user}, q{but the message is invalid user});

    return 1;
}

sub test_invalid_pass {
    my ($self) = @_;

    $self->_make_post(q{test01:notmypass});
    $self->{ua}->content_contains(q{Invalid user}, q{but the message is invalid user});

    return 1;
}

sub test_no_pass {
    my ($self) = @_;
    $self->_make_post(q{test01});
    $self->{ua}->content_contains(q{Invalid user}, q{the message is invalid user});

    return 1;
}

sub test_valid_user_and_scene {
    my ($self) = @_;

    $self->_make_post(q{test01:mypass});
    $self->{ua}->content_contains(q{Running api scene}, q{get running scene message});

    return 1;
}

sub test_invalid_body_data {
    my ($self) = @_;

    $self->_make_post(q{test01:mypass}, { content => q{} });

    my $ua = $self->{ua};
    $ua->content_contains(q{Invalid body request}, q{get an error message});

    $self->_make_post(q{test01:mypass}, { content => q/{"message":"this will not work"}/ });
    $ua->content_contains(q{Invalid body request}, q{get error message if json doesn't have a scene});
    return 1;
}

sub test_no_scene {
    my ($self) = @_;

    my $scene_rs = $self->{schema}->resultset(q{Scene});

    # store a copy of all the scenes so that we can remove them and add them back in
    my @scenes = $scene_rs->all;
    $scene_rs->delete_all;
    $self->_make_post(q{test01:mypass});
    $self->{ua}->content_contains(q{Failed to find scene api scene}, q{get running scene message});

    # add the scenes back into the db
    for my $scene (@scenes) {
        $scene->discard_changes;
        $scene->insert;
    }
    return 1;
}

sub _make_post {
    my ($self, $lp_string, $args) = @_;

    $args //= {};
    my $content = exists $args->{content} ? $args->{content} : q/{"scene":"api scene"}/;
    my $lp = encode_base64 $lp_string;

    my $ua = $self->{ua};
    $ua->post($ENDPOINT, Authorization => q{Basic } . $lp, q{Content-Type} => q{application/json}, Content => $content);
    is $ua->status, $OK_STATUS, q{post returns a 200 OK};
    return 1;
}

1;

__END__

=head1 NAME

Test::HomeAutomation::Controller::API

=head2 DESCRIPTION

Test class for all the api tests.

=cut
