package HomeAutomation::Model::DB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

# control db connection through env variables
my $dsn  = $ENV{HA_DSN}  || 'dbi:SQLite:ha.db';
my $usr  = $ENV{HA_USER} || '';
my $pass = $ENV{HA_PASS} || '';

__PACKAGE__->config(
    schema_class => 'HomeAutomation::Schema',

    connect_info => {
        dsn           => $dsn,
        user          => $usr,
        password      => $pass,
        on_connect_do => q{PRAGMA foreign_keys = ON},
    }
);

=head1 NAME

HomeAutomation::Model::DB - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<HomeAutomation>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<HomeAutomation::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.6

=head1 AUTHOR

Rob Halliday

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
