package String::Format::Compiled::String;

# uses #########################################################################    
use strict;
use warnings;

sub new {
    my ($class, @params) = @_;      

    my $self = { @params };
    bless($self, $class);

    return $self;
}


sub render { shift->{value} }

1;