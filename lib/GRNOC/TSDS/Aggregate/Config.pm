package GRNOC::TSDS::Aggregate::Config;

use Moo;
use Types::Standard qw(Str Object);

use GRNOC::Config;
use GRNOC::Log;


has config => (
    is  => 'rw',
    isa => Object
);

has config_file => (
    is  => 'rw',
    isa => Str
);


=head2 BUILD

GRNOC::TSDS::Aggregate::Config acts as abstraction to support both ENV
and configuration file based configurations.

The mongo/readwrite user is used for all mongodb_* config file based
results.

=cut
sub BUILD {
    my ($self, $args) = @_;

    if ($args->{config_file}) {
        $self->config(new GRNOC::Config(
            config_file => $args->{config_file},
            force_array => 0
        ));
    } elsif (defined $args->{config}) {
        die "GRNOC::TSDS::Aggregate::Config - 'config' is not a valid argument";
    }

    return $self;
}


=head2 tsds_aggregate_concurrent_measurements

How many measurements to process in a single batch.

=cut
sub tsds_aggregate_concurrent_measurements {
    my $self = shift;

    if ($ENV{TSDS_AGGREGATE_CONCURRENT_MEASUREMENTS}) {
        return $ENV{TSDS_AGGREGATE_CONCURRENT_MEASUREMENTS};
    } elsif ($self->config) {
        return $self->config->get('/config/master/num_concurrent_measurements');
    } else {
        return 10;
    }
}


=head2 tsds_aggregate_message_size

How many measurements to include in a single rabbit message.

=cut
sub tsds_aggregate_message_size {
    my $self = shift;

    if ($ENV{TSDS_AGGREGATE_MESSAGE_SIZE}) {
        return $ENV{TSDS_AGGREGATE_MESSAGE_SIZE};
    } elsif ($self->config) {
        return $self->config->get('/config/master/num_messages');
    } else {
        return 10;
    }
}


=head2 tsds_aggregate_lock_timeout

How long in seconds to hold redis locks (unlikely you should have to
change this).

=cut
sub tsds_aggregate_lock_timeout {
    my $self = shift;

    if ($ENV{TSDS_AGGREGATE_LOCK_TIMEOUT}) {
        return $ENV{TSDS_AGGREGATE_LOCK_TIMEOUT};
    } elsif ($self->config) {
        return $self->config->get('/config/master/lock_timeout');
    } else {
        return 120;
    }
}


=head2 tsds_aggregate_max_docs_per_block

How many documents can be read in a single block. This should be
greater than the num_concurrent_measurements to avoid extra looping.
A single ->find from the data collections will retrieve this many at
most, avoiding timeouts on very large requests if a lot of documents
have been dirtied.

=cut
sub tsds_aggregate_max_docs_per_block {
    my $self = shift;

    if ($ENV{TSDS_AGGREGATE_MAX_DOCS_PER_BLOCK}) {
        return $ENV{TSDS_AGGREGATE_MAX_DOCS_PER_BLOCK};
    } elsif ($self->config) {
        return $self->config->get('/config/master/max_docs_per_block');
    } else {
        return 100;
    }
}


=head2 tsds_aggregate_daemon_pid_file

Where should we write the aggregator master pid file.

=cut
sub tsds_aggregate_daemon_pid_file {
    my $self = shift;

    if ($ENV{TSDS_AGGREGATE_DAEMON_PID_FILE}) {
        return $ENV{TSDS_AGGREGATE_DAEMON_PID_FILE};
    } else {
        return $self->config->get('/config/master/pid-file');
    }
}


=head2 tsds_aggregate_worker_pid_file

Where should we write the aggregator worker pid file.

=cut
sub tsds_aggregate_worker_pid_file {
    my $self = shift;

    if ($ENV{TSDS_AGGREGATE_WORKER_PID_FILE}) {
        return $ENV{TSDS_AGGREGATE_WORKER_PID_FILE};
    } else {
        return $self->config->get('/config/worker/pid-file');
    }
}


=head2 tsds_aggregate_tsds_user

...

=cut
sub tsds_aggregate_tsds_user {
    my $self = shift;

    if ($ENV{TSDS_AGGREGATE_TSDS_USER}) {
        return $ENV{TSDS_AGGREGATE_TSDS_USER};
    } else {
        return $self->config->get('/config/worker/tsds/username');
    }
}


=head2 tsds_aggregate_tsds_pass

...

=cut
sub tsds_aggregate_tsds_pass {
    my $self = shift;

    if ($ENV{TSDS_AGGREGATE_TSDS_PASS}) {
        return $ENV{TSDS_AGGREGATE_TSDS_PASS};
    } else {
        return $self->config->get('/config/worker/tsds/password');
    }
}


=head2 tsds_aggregate_tsds_realm

...

=cut
sub tsds_aggregate_tsds_realm {
    my $self = shift;

    if ($ENV{TSDS_AGGREGATE_TSDS_REALM}) {
        return $ENV{TSDS_AGGREGATE_TSDS_REALM};
    } else {
        return $self->config->get('/config/worker/tsds/realm');
    }
}


=head2 tsds_aggregate_tsds_url

...

=cut
sub tsds_aggregate_tsds_url {
    my $self = shift;

    if ($ENV{TSDS_AGGREGATE_TSDS_URL}) {
        return $ENV{TSDS_AGGREGATE_TSDS_URL};
    } else {
        return $self->config->get('/config/worker/tsds/url');
    }
}


=head2 tsds_aggregate_tsds_cloud

...

=cut
sub tsds_aggregate_tsds_cloud {
    my $self = shift;

    if ($ENV{TSDS_AGGREGATE_TSDS_CLOUD}) {
        return $ENV{TSDS_AGGREGATE_TSDS_CLOUD};
    } else {
        return $self->config->get('/config/worker/tsds/cloud');
    }
}


sub mongodb_uri {
    my $self = shift;
    return $ENV{MONGODB_URI};
}


sub mongodb_user {
    my $self = shift;

    if (!defined $self->config) {
        return $ENV{MONGODB_USER};
    } else {
        return $self->config->get('/config/master/mongo/username');
    }
}


sub mongodb_pass {
    my $self = shift;

    if (!defined $self->config) {
        return $ENV{MONGODB_PASS};
    } else {
        return $self->config->get('/config/master/mongo/password');
    }
}


sub mongodb_host {
    my $self = shift;

    if (!defined $self->config) {
        return $ENV{MONGODB_HOST};
    } else {
        return $self->config->get('/config/master/mongo/host');
    }
}


sub mongodb_port {
    my $self = shift;

    if (!defined $self->config) {
        return $ENV{MONGODB_PORT};
    } else {
        return $self->config->get('/config/master/mongo/port');
    }
}


sub rabbitmq_user {
    my $self = shift;
    return $ENV{RABBITMQ_USER};
}


sub rabbitmq_pass {
    my $self = shift;
    return $ENV{RABBITMQ_PASS};
}


sub rabbitmq_host {
    my $self = shift;

    if (!defined $self->config) {
        return $ENV{RABBITMQ_HOST};
    } else {
        return $self->config->get('/config/rabbit/host');
    }
}


sub rabbitmq_port {
    my $self = shift;

    if (!defined $self->config) {
        return $ENV{RABBITMQ_PORT};
    } else {
        return $self->config->get('/config/rabbit/port');
    }
}


sub rabbitmq_pending_queue {
    my $self = shift;

    if (!defined $self->config) {
        return $ENV{RABBITMQ_PENDING_QUEUE};
    } else {
        return $self->config->get('/config/rabbit/pending-queue');
    }
}


sub rabbitmq_failed_queue {
    my $self = shift;

    if (!defined $self->config) {
        return $ENV{RABBITMQ_FAILED_QUEUE};
    } else {
        return $self->config->get('/config/rabbit/failed-queue');
    }
}


sub rabbitmq_finished_queue {
    my $self = shift;

    if (!defined $self->config) {
        return $ENV{RABBITMQ_FINISHED_QUEUE};
    } else {
        return $self->config->get('/config/rabbit/finished-queue');
    }
}


sub redis_host {
    my $self = shift;

    if (!defined $self->config) {
        return $ENV{REDIS_HOST};
    } else {
        return $self->config->get('/config/redis/@host');
    }
}


sub redis_port {
    my $self = shift;

    if (!defined $self->config) {
        return $ENV{REDIS_PORT};
    } else {
        return $self->config->get('/config/redis/@port');
    }
}

1;
