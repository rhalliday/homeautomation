package Test::HomeAutomation::Form;

use strict;
use warnings;

use Test::Class::Moose extends => q{Test::HomeAutomation};

our $VERSION = '1.00';

sub test_startup {
    my ($self) = @_;

    $self->next::method();

    return 1;
}

1;

__END__

=head1 NAME

Test::HomeAutomation::Form

=head2 DESCRIPTION

Base class for the form tests.

=cut
