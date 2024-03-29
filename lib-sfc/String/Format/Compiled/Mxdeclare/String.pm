use MooseX::Declare;

class String::Format::Compiled::Mxdeclare::String {

# uses #########################################################################    
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
method render { $self->value }

}