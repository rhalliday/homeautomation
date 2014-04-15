package Test::HomeAutomation;

use Test::Class::Moose;
use HomeAutomation::Schema;
use Test::MockObject::Extends;
use IO::Socket;
use Mochad;

my $message = q{};
# set up an IO::Socket object to intercept the messages
my $io_socket = IO::Socket->new();
$io_socket = Test::MockObject::Extends->new($io_socket);
$io_socket->mock(q{print}, sub { my ($this, $msg) = @_; $message = $msg; });

# Mochad has a singleton connection so all our Mochad instances will use this connection
my $mochad = Mochad->new(address => q{H4}, connection => $io_socket);

sub test_startup {

    # connect to the db on startup
    my ($self) = @_;
    my $connect_info = {
        dsn           => $ENV{HA_DSN},
        user          => '',
        password      => '',
        on_connect_do => q{PRAGMA foreign_keys = ON},
    };
    $self->{schema} = HomeAutomation::Schema->connect($connect_info);

    $self->{message} = \$message;
    return 1;
}

sub test_shutdown {

    # this would probably happen on end of scope, but
    my ($self) = @_;

    $self->{schema}->storage->disconnect();

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
