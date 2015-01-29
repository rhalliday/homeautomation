package HomeAutomation::Schema::Base;
use utf8;

=head1 NAME

HomeAutomation::Schema::Base

=head1 DESCRIPTION

Base class for loading in components

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends q{DBIx::Class::Core};

our $VERSION = q{0.01};

=head1 COMPONENTS LOADED

=over 4

=item * L<DateTime|DBIx::Class::InflateColumn::DateTime>

=item * L<TimeStamp|DBIx::Class::TimeStamp>

=item * L<PassphraseColumn|DBIx::Class::PassphraseColumn>

=back

=cut

__PACKAGE__->load_components(q{InflateColumn::DateTime}, q{TimeStamp}, q{PassphraseColumn});

__PACKAGE__->meta->make_immutable;
1;
