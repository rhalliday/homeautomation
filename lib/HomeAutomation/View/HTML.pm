package HomeAutomation::View::HTML;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt2',
    render_die => 1,
);

=head1 NAME

HomeAutomation::View::HTML - TT View for HomeAutomation

=head1 DESCRIPTION

TT View for HomeAutomation.

=head1 SEE ALSO

L<HomeAutomation>

=head1 AUTHOR

Rob Halliday,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
