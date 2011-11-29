use strict;
use warnings;

use Benchmark qw(:all);
use String::Format;
use String::Format::Compiled;

my $format = qq(I like %-30.2a, %-10.5b, and %{bitter}g, but not %10m or %.2w.%n) x 10;
my %fruit = (
    'a' => "apples",
    'b' => "bannanas",
    'g' => sub { $_[0] .' grapefruit' },
    'm' => "melons",
    'w' => "watermelons",
);


my $compiled_format = String::Format::Compiled->new($format);
my $fruit           = \%fruit;

# Actually S:F prints something different here, I should contact the author
cmpthese(15000, {
    format          => sub { stringf($format, %fruit) },
    format_compiled => sub { $compiled_format->render($fruit) },
    format_compiled_new_instances => sub {
        # do not use S:F:C like this
        String::Format::Compiled->new($format)->render($fruit)
    },
});