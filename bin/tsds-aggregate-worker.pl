#!/usr/bin/perl

use strict;
use warnings;

use lib '/opt/grnoc/venv/grnoc-tsds-aggregate/lib/perl5';

use GRNOC::TSDS::Aggregate::Aggregator::Worker;
use GRNOC::Config;
use GRNOC::Log;

use Getopt::Long;
use Data::Dumper;

### constants ###

use constant DEFAULT_CONFIG_FILE => '/etc/grnoc/tsds/aggregate/config.xml';
use constant DEFAULT_LOGGING_FILE => '/etc/grnoc/tsds/aggregate/logging.conf';

### command line options ###

my $config = DEFAULT_CONFIG_FILE;
my $logging = DEFAULT_LOGGING_FILE;
my $help;

GetOptions( 'config=s' => \$config,
            'logging=s' => \$logging,
            'help|h|?' => \$help );

sub usage {
    print "Usage: $0 [--config <file path>] [--logging <file path>]\n";
    exit( 1 );
}

usage() if $help;


# create logger object
my $grnoc_log = GRNOC::Log->new( config => $logging );
my $logger = GRNOC::Log->get_logger();

# create config object
my $config_object = GRNOC::Config->new( config_file => $config, force_array => 0 );

# start/daemonize writer
my $worker = GRNOC::TSDS::Aggregate::Aggregator::Worker->new( config => $config_object,
								      logger => $logger );

$worker->start();

### helpers ###

sub usage {

    print "Usage: $0 [--config <file path>] [--logging <file path>]\n";

    exit( 1 );
}