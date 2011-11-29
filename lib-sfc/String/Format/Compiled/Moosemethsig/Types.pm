package String::Format::Compiled::Moosemethsig::Types;

use strict;
use warnings;

use MooseX::Types -declare => [qw~
    Char
~];

use MooseX::Types::Moose qw~Str~;

subtype Char, as Str, where { length $_ == 1 };

return 1;