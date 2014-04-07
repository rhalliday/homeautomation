package HomeAutomation;
use 5.014;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
  -Debug
  ConfigLoader
  Static::Simple

  StackTrace

  Authentication
  Authorization::Roles

  Session
  Session::Store::File
  Session::State::Cookie

  StatusMessage
  /;

extends 'Catalyst';

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in homeautomation.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'HomeAutomation',

    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header                      => 1,    # Send X-Catalyst header
);

__PACKAGE__->config(

    # Configure the view
    'View::HTML' => {

        #Set the location for TT files
        INCLUDE_PATH => [ __PACKAGE__->path_to('root', 'src'), ],
        TIMER        => 0,
        WRAPPER      => 'wrapper.tt2',
    },
);

# Configure View JSON
__PACKAGE__->config(
    'View::JSON' => {

        # only json_data in the stash will be exposed
        expose_stash => 'json_data',
    },
);

# Configure SimpleDB Authentication
__PACKAGE__->config(
    'Plugin::Authentication' => {
        default => {
            class         => 'SimpleDB',
            user_model    => 'DB::User',
            password_type => 'self_check',
        },
    },
);

__PACKAGE__->config(default_view => 'HTML');

# Start the application
__PACKAGE__->setup();

=head1 NAME

HomeAutomation - Catalyst based application for controlling devices in the home

=head1 SYNOPSIS

    script/homeautomation_server.pl

=head1 DESCRIPTION

This provides a web site that allows the controlling and scheduling of devices in the home.

=head1 SEE ALSO

L<HomeAutomation::Controller::Root|Root>, L<Catalyst|Catalyst>

=head1 AUTHOR

Rob Halliday

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
