package Test::HomeAutomation::Controller::Schedules;

use Test::Class::Moose extends => 'Test::HomeAutomation::Controller';
use DateTime;

sub test_basic_user {
    my ($self) = @_;

    $self->login(q{test03});
    my $ua = $self->{ua};

    $ua->get(q{/schedules/id/2/view});
    $ua->content_contains(q{Permission Denied}, q{test01 gets permission denied if they try to look at a schedule});
    return 1;
}

sub test_privileged_user {
    my ($self) = @_;

    $self->login(q{test02});
    my $ua = $self->{ua};
    $ua->get(q{/appliances});

    $ua->title_is(q{Appliance List}, q{make sure we're on the appliance page});
    $ua->follow_link_ok({ text => q{Schedule} }, q{can get to the schedule page});
    $ua->title_is(q{Create/Update Schedule}, q{check we are on the right page});

    $ua->get_ok(q{/schedules}, q{getting schedules index});
    $ua->title_is(q{Schedule List}, q{have the right page});

    return 1;
}

sub test_admin_user {
    my ($self) = @_;

    $self->login(q{test01});
    my $ua = $self->{ua};
    $ua->get(q{/appliances});
    $ua->title_is(q{Appliance List}, q{make sure we're on the appliance page});
    $ua->follow_link_ok({ text => q{Schedule} }, q{can get to the schedule page});
    $ua->title_is(q{Create/Update Schedule}, q{check we are on the right page});
    my $today = DateTime->now(time_zone => 'Europe/London');
    my $last_week = $today->subtract(weeks => 1);
    my $next_week = $today->add(weeks => 1);
    $ua->submit_form_ok(
        {
            fields => {
                action    => 'on',
                time      => '16:00',
                day       => $today->dmy('/'),
            }
        },
        q{can submit the schedule create form}
    );
    $ua->title_is(q{Schedule List}, q{redirected to the schedule list after creation});
    $ua->get_ok(q{/schedules/id/1/view}, q{can view a schedule});
    $ua->title_is(q{Schedule View}, q{viewing a schedule});
    $ua->get_ok(q{/schedules/id/1/edit}, q{can edit a schedule});
    $ua->title_is(q{Create/Update Schedule}, q{editing a schedule});

    my $event_url = q{/schedules/event_data?start=} . $last_week->epoch . q{&end=} . $next_week->epoch;
    $ua->get_ok($event_url, q{can get the event data});

    $event_url = q{/schedules/event_data?start=} . $last_week->epoch;
    $ua->get($event_url);
    $ua->content_contains(q{Page not found}, q{missing end param results in an error});

    $event_url = q{/schedules/event_data?end=} . $last_week->epoch;
    $ua->get($event_url);
    $ua->content_contains(q{Page not found}, q{missing start param results in an error});
    
    $ua->get_ok(q{/schedules/id/1/delete}, q{can delete a schedule});
    $ua->title_is(q{Schedule List}, q{deleting a schedule});
    $ua->get(q{/schedules/id/22322/edit});
    $ua->content_contains(q{Page not found}, q{redirect to default if schedule doesn't exist});

    return 1;
}

1;

__END__

=head1 NAME

Test::HomeAutomation::Controller::Appliances

=head2 DESCRIPTION

Test class for all the appliance tests.

=cut
