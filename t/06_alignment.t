#!perl
use strict;
use warnings;
use Test::More tests => 2;

use String::Format::Compiled;

my $test_sfc = String::Format::Compiled->new('%-30.2X|');
my $rendered = $test_sfc->render({ X => 'Test' });
is ($rendered, 'Te                            |');

$test_sfc = String::Format::Compiled->new('%-X|'); # maybe emit a warning?
$rendered = $test_sfc->render({ X => 'Test' });
is ($rendered, 'Test|');

