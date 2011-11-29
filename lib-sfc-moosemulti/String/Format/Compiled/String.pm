package String::Format::Compiled::String;

# uses #########################################################################    
use Moose;
use MooseX::HasDefaults::RO;
use MooseX::Method::Signatures;

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

__PACKAGE__->meta->make_immutable;
no Moose;
1;