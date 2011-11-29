package String::Format::Compiled::Mouse::Types;

use strict;
use warnings;

use MouseX::Types -declare => [qw~
    Char
~];

use MouseX::Types::Mouse qw~Str~;

subtype Char, as Str, where { length $_ == 1 };

return 1;