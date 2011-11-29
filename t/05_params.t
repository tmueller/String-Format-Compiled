#!perl
use strict;
use warnings;
use Test::More tests => 4;

use String::Format::Compiled;

my $test_sfc = String::Format::Compiled->new('%{TEST}a');
my $rendered = $test_sfc->render({
    a => sub {
        is($_[0], 'TEST');
        return $_[0].'A';
    }
});

is ($rendered, 'TESTA');

my $rendered_untouched = $test_sfc->render({});
is ($rendered_untouched, '%{TEST}a');

my $rendered_nosub  = $test_sfc->render({ a => 'A' });
is ($rendered_nosub, 'A');