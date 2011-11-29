package String::Format::Compiled::Types;
# ABSTRACT: Types for String-Format-Compiled

use strict;
use warnings;

use MouseX::Types -declare => [qw~
    Char
~];

use MouseX::Types::Mouse qw~Str~;

subtype Char, as Str, where { length $_ == 1 };

return 1;