package String::Format::Compiled::Moose::String;

# uses #########################################################################    
use Moose;
use MooseX::HasDefaults::RO;

# types ########################################################################
use MooseX::Types::Moose            qw~~;

# roles + inheritance ##########################################################

# attributes ###################################################################    
has value => (
    default     => '',
);

# builders #####################################################################    

# methods ######################################################################
sub render { shift->value }

__PACKAGE__->meta->make_immutable;
no Moose;
1;