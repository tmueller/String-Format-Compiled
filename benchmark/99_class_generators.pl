use strict;
use warnings;

use Benchmark qw(:all);
use String::Format::Compiled::Bare;
use String::Format::Compiled::Moo;
use String::Format::Compiled::Moose;
use String::Format::Compiled::Mouse;
use String::Format::Compiled::Mxdeclare;
use String::Format::Compiled::Moosemulti;
use String::Format::Compiled::Moosemethsig;
use String::Format;


my $format = qq(I like %a, %b, and %g, but not %m or %w.) x 10;
my %fruit = (
    'a' => "apples",
    'b' => "bannanas",
    'g' => "grapefruits",
    'm' => "melons",
    'w' => "watermelons",
);


my $bare            = String::Format::Compiled::Bare->new($format);
my $moo             = String::Format::Compiled::Moo->new($format);
my $moose           = String::Format::Compiled::Moose->new($format);
my $mouse           = String::Format::Compiled::Mouse->new($format);
my $mxdeclare       = String::Format::Compiled::Mxdeclare->new($format);
my $moosemulti      = String::Format::Compiled::Moosemulti->new($format);
my $moosemethsig    = String::Format::Compiled::Moosemethsig->new($format);

my $fruit = \%fruit;

cmpthese(1000, {
    format      => sub { stringf($format, %fruit) },
    bare        => sub { $bare->render($fruit) },
    moo         => sub { $moo->render($fruit) },
    moose       => sub { $moose->render($fruit) },
    mouse       => sub { $mouse->render($fruit) },
    moosemethsig => sub { $moosemethsig->render($fruit) },
    #moosemulti  => sub { $moosemulti->render($fruit) },
    #mxdeclare   => sub { $mxdeclare->render($fruit) }, # far too slow
});