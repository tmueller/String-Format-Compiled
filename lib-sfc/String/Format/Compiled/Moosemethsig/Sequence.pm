package String::Format::Compiled::Moosemethsig::Sequence;

# uses #########################################################################    
use Moose;
use MooseX::HasDefaults::RO;
use MooseX::Method::Signatures;

# types ########################################################################
use MooseX::Types::Moose            qw~Str HashRef Int CodeRef Bool~;
use String::Format::Compiled::Moosemethsig::Types qw~Char~;

# roles + inheritance ##########################################################

# attributes ###################################################################
# TODO: parameters for coderefs + tests
has character => (
    isa         => Char,
    required    => 1,
);

has value => (
    isa         => Str,
    required    => 1,
);

has left_align => (
    isa         => Bool,
    default     => 0, 
);

has min_width => (
    isa         => Int,
    predicate   => 'has_min_width', 
);

has max_width => (
    isa         => Int,
    predicate   => 'has_max_width', 
);

has params  => (
    isa         => Str,
);

has _sprintformat => (
    isa         => Str,
    lazy        => 1,
    init_arg    => undef,
    default     => sub {
        my $self    = shift;
        my $format  = '%';
        
        $format     .= '-'                      if ($self->left_align);
        $format     .= $self->min_width         if ($self->has_min_width);
        $format     .= '.'. $self->max_width    if ($self->has_max_width);
        
        return $format.'s';
    },
);

has _simple_format => (
    isa         => Bool,
    lazy        => 1,
    init_arg    => undef,
    default     => sub {
        my $self = shift;
        return !$self->has_min_width && !$self->has_max_width;
    }
);

# builders #####################################################################    

# methods ######################################################################
method render (HashRef $params) {
    my $char = $self->character;
    return $self->value unless (defined $params->{$char});
    
    my $result = $params->{$char};
    #$result = $result->($self->params) if (CodeRef->check($result)); # slow
    $result = $result->($self->params) if (ref $result eq 'CODE');
    
    return $result if ($self->_simple_format);
    return sprintf($self->_sprintformat, $result);
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;