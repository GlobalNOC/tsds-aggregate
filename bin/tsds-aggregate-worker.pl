#!/usr/bin/perl

use strict;
use warnings;

use lib '/opt/grnoc/venv/grnoc-tsds-aggregate/lib/perl5';

use GRNOC::TSDS::Aggregate::Config;
use GRNOC::TSDS::Aggregate::Aggregator::Worker;
use GRNOC::Config;
use GRNOC::Log;

use Getopt::Long;
use Data::Dumper;

### constants ###

use constant DEFAULT_CONFIG_FILE => '/etc/grnoc/tsds/aggregate/config.xml';
use constant DEFAULT_LOGGING_FILE => '/etc/grnoc/tsds/aggregate/logging.conf';

### command line options ###

my $config = '';
my $logging = DEFAULT_LOGGING_FILE;
my $help;

GetOptions(
    'config=s' => \$config,
    'logging=s' => \$logging,
    'help|h|?' => \$help
);

sub usage {
    print "Usage: $0 [--config <file path>] [--logging <file path>]\n";
    exit( 1 );
}

usage() if $help;


# create logger object
my $grnoc_log = GRNOC::Log->new( config => $logging );
my $logger = GRNOC::Log->get_logger();

my $config_obj = new GRNOC::TSDS::Aggregate::Config(
    config_file => $config
);
# start/daemonize writer
my $worker = GRNOC::TSDS::Aggregate::Aggregator::Worker->new(
    config => $config_obj,
    logger => $logger
);

$worker->start();

### helpers ###

sub usage {
    print "Usage: $0 [--config <file path>] [--logging <file path>]\n";
    exit(1);
}
