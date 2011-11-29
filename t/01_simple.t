use strict;

use Test::More tests => 11;
use String::Format::Compiled;

sub stringf {
    my ($template, $params) = @_;
    String::Format::Compiled->new($template)->render($params);
}

{
    # testing instantiation with normal constructor
    my $formatter = String::Format::Compiled->new(format => 'empty though');
    isa_ok($formatter, 'String::Format::Compiled');
}

{
    # testing instantiation with normal constructor
    my $formatter = String::Format::Compiled->new('empty though');
    isa_ok($formatter, 'String::Format::Compiled');
}


# ======================================================================
# Lexicals.  $orig is the original format string.
# ======================================================================
my ($orig, $target, $result);
my %fruit = (
    'a' => "apples",
    'b' => "bannanas",
    'g' => "grapefruits",
    'm' => "melons",
    'w' => "watermelons",
);

# ======================================================================
# Test 1
# Standard test, with all elements in place.
# ======================================================================
$orig   = qq(I like %a, %b, and %g, but not %m or %w.);
$target = "I like apples, bannanas, and grapefruits, ".
          "but not melons or watermelons.";
$result = stringf $orig, \%fruit;
is $result, $target;

# ======================================================================
# Test 2
# Test where some of the elements are missing.
# ======================================================================
delete $fruit{'b'};
$target = "I like apples, %b, and grapefruits, ".
          "but not melons or watermelons.";
$result = stringf $orig, \%fruit;
is $result, $target;

# ======================================================================
# Test 2a
# Test where some of the elements are empty.
# ======================================================================
$target = "I like apples, , and grapefruits, ".
          "but not melons or watermelons.";
$result = stringf $orig, { %fruit, b => '' };
is $result, $target;

# ======================================================================
# Test 3
# Upper and lower case of same char
# ======================================================================
$orig   = '%A is not %a';
$target = 'two is not one';
$result = stringf $orig, { "a" => "one", "A" => "two" };
is $result, $target;


# ======================================================================
# Test 4
# Field width
# ======================================================================
$orig   = "I am being %.5r.";
$target = "I am being trunc.";
$result = stringf $orig, { "r" => "truncated" };
is $result, $target;


# ======================================================================
# Test 5
# Alignment
# ======================================================================
$orig   = "I am being %30e.";
$target = "I am being                      elongated.";
$result = stringf $orig, { "e" => "elongated" };
is $result, $target;


# ======================================================================
# Test 6 - 8
# Testing of non-alphabet characters
# ======================================================================
# Test 6 => '/'
# ======================================================================
$orig   = "holy shit %/.";
$target = "holy shit w00t.";
$result = stringf $orig, { '/' => "w00t" };
is $result, $target;


# ======================================================================
# Test 7 => numbers
# ======================================================================
$orig   = '%1 %2 %3';
$target = "1 2 3";
$result = stringf $orig, { '1' => 1, '2' => 2, '3' => 3 };
is $result, $target;


# ======================================================================
# Test 8 => perl sigils ($@&)
# ======================================================================
# Note: The %$ must be single quoted so it does not interpolate!
# This was causing this test to unexpenctedly fail.
# ======================================================================
$orig   = '%$ %@ %&';
$target = "1 2 3";
$result = stringf $orig, { '$' => 1, '@' => 2, '&' => 3 };
is $result, $target;



done_testing;