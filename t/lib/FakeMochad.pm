package FakeMochad;

use Moose;
use namespace::autoclean;
use Test::MockObject;

has message => (
    is      => q{ro},
    isa     => q{Str},
    clearer => q{clear_message},
    default => q{},
);

has return => (
    is      => q{rw},
    isa     => q{ArrayRef},
);

has io_socket => (
    is  => q{ro},
    isa => q{Test::MockObject},
    builder => q{_build_io_socket},
);

sub _build_io_socket {
    my ($self) = @_;
    my $io_socket = Test::MockObject->new();
    $io_socket->fake_module('IO::Socket::INET', new => sub { return $self->io_socket });

    # store printed messages
    $io_socket->mock(q{print}, sub { my ($o, $msg) = @_; $self->{message} .= $msg; });

    $io_socket->mock(q{getline}, sub { return shift @{$self->return}; });

    $io_socket->mock(q{close}, sub { return 1 });
    return $io_socket;
}

__PACKAGE__->meta->make_immutable();

1;
