use strict;
use warnings;

use HomeAutomation;

my $app = HomeAutomation->apply_default_middlewares(HomeAutomation->psgi_app);
$app;

