package HomeAutomation::Schema;
use utf8;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
extends q{DBIx::Class::Schema};

our $VERSION = q{0.01};
__PACKAGE__->load_namespaces;

=head1 NAME

HomeAutomation::Schema

=head1 Description

Base class for the resultsets.

=cut

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
1;
