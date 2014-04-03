package Test::HomeAutomation;

use Test::Class::Moose;

use HomeAutomation::Schema;

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
}

sub test_shutdown {
    # this would probably happen on end of scope, but
    my ($self) = @_;

    $self->{schema}->storage->disconnect();
}
1;

__END__

=head1 NAME

Test::HomeAutomation

=head2 DESCRIPTION

Base class for our Test::Class::Moose tests. All our tests should
extend this class so that they can be run from one place.

=cut
