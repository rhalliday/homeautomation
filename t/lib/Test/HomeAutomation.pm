package Test::HomeAutomation;

use strict;
use warnings;

use Test::Class::Moose;
use FindBin::libs;
use FakeMochad;
use HomeAutomation::Schema;

my $fake_mochad = FakeMochad->new();

use Mochad;

our $VERSION = '1.00';

sub test_startup {

    # connect to the db on startup
    my ($self) = @_;
    my $connect_info = {
        dsn           => $ENV{HA_DSN},
        user          => q{},
        password      => q{},
        on_connect_do => q{PRAGMA foreign_keys = ON},
    };
    $self->{schema} = HomeAutomation::Schema->connect($connect_info);

    $self->{fake_mochad} = $fake_mochad;

    return 1;
}

sub test_shutdown {

    # this would probably happen on end of scope, but
    my ($self) = @_;

    $self->{schema}->storage->disconnect();

    return 1;
}

sub set_up_mochad {
    my ($self, $return) = @_;

    $self->{fake_mochad}->clear_message;
    $self->{fake_mochad}->return($return);
    return 1;
}

1;

__END__

=head1 NAME

Test::HomeAutomation

=head2 DESCRIPTION

Base class for our Test::Class::Moose tests. All our tests should
extend this class so that they can be run from one place.

=cut
