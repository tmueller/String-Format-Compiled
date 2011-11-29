use strict;
use warnings;

use Benchmark qw(:all);
use String::Format;
use String::Format::Compiled;

my $format = qq(I like %a, %b, and %g, but not %m or %w.) x 10;
my %fruit = (
    'a' => "apples",
    'b' => "bannanas",
    'g' => "grapefruits",
    'm' => "melons",
    'w' => "watermelons",
);


my $compiled_format = String::Format::Compiled->new($format);
my $fruit           = \%fruit;

cmpthese(15000, {
    format          => sub { stringf($format, %fruit) },
    format_compiled => sub { $compiled_format->render($fruit) },
    format_compiled_new_instances => sub {
        # do not use S:F:C like this
        String::Format::Compiled->new($format)->render($fruit)
    },
});