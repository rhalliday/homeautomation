#!/usr/bin/env perl

use strict;
use warnings;

our $VERSION = q{0.01};

use Catalyst::ScriptRunner;
Catalyst::ScriptRunner->run('HomeAutomation', 'Create');

1;

=head1 NAME

homeautomation_create.pl - Create a new Catalyst Component

=head1 SYNOPSIS

homeautomation_create.pl [options] model|view|controller name [helper] [options]

 Options:
   --force        don't create a .new file where a file to be created exists
   --mechanize    use Test::WWW::Mechanize::Catalyst for tests if available
   --help         display this help and exits

 Examples:
   homeautomation_create.pl controller My::Controller
   homeautomation_create.pl --mechanize controller My::Controller
   homeautomation_create.pl view My::View
   homeautomation_create.pl view HTML TT
   homeautomation_create.pl model My::Model
   homeautomation_create.pl model SomeDB DBIC::Schema MyApp::Schema create=dynamic\
   dbi:SQLite:/tmp/my.db
   homeautomation_create.pl model AnotherDB DBIC::Schema MyApp::Schema create=static\
   [Loader opts like db_schema, naming] dbi:Pg:dbname=foo root 4321
   [connect_info opts like quote_char, name_sep]

 See also:
   perldoc Catalyst::Manual
   perldoc Catalyst::Manual::Intro
   perldoc Catalyst::Helper::Model::DBIC::Schema
   perldoc Catalyst::Model::DBIC::Schema
   perldoc Catalyst::View::TT

=head1 DESCRIPTION

Create a new Catalyst Component.

Existing component files are not overwritten.  If any of the component files
to be created already exist the file will be written with a '.new' suffix.
This behavior can be suppressed with the C<-force> option.

=head1 AUTHORS

Catalyst Contributors, see Catalyst.pm

=head1 COPYRIGHT

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
