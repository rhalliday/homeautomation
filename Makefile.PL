#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install 1.02;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'HomeAutomation';
all_from 'lib/HomeAutomation.pm';

requires 'Catalyst::Runtime' => '5.90018';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Plugin::StackTrace';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Authentication::Realm::SimpleDB';
requires 'Catalyst::Plugin::Authorization::Roles';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::Store::File';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::StatusMessage';
requires 'Catalyst::View::JSON';
requires 'Catalyst::View::TT';
requires 'Catalyst::Model::DBIC::Schema';
requires 'DBIx::Class';
requires 'DBIx::Class::TimeStamp';
requires 'DBIx::Class::PassphraseColumn';
requires 'HTML::FormHandler::Model::DBIC';
requires 'HTML::FormHandler::Widget::Theme::Bootstrap3';
requires 'Perl6::Junction';
requires 'Moose';
requires 'namespace::autoclean';
requires 'Config::General'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats
test_requires 'Test::More' => '0.88';
test_requires 'Test::Class::Moose';
test_requires 'Test::MockObject::Extends';
test_requires 'Test::WWW::Mechanize::Catalyst';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
