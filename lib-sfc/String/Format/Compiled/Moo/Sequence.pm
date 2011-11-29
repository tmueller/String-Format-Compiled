package String::Format::Compiled::Moo::Sequence;

# uses #########################################################################    
use Moo;

# types ########################################################################

# roles + inheritance ##########################################################

# attributes ###################################################################
# TODO: parameters for coderefs + tests
has character => (
    is          => 'ro',
    required    => 1,
);

has value => (
    is          => 'ro',
    required    => 1,
);

has left_align => (
    is          => 'ro',
    default     => 0, 
);

has min_width => (
    is          => 'ro',
    predicate   => 'has_min_width', 
);

has max_width => (
    is          => 'ro',
    predicate   => 'has_max_width', 
);

has params  => (
    is          => 'ro',
);

has _sprintformat => (
    is          => 'ro',
    lazy        => 1,
    init_arg    => undef,
    default     => sub {
        my $self            = shift;
        my $format  = '%';
        
        $format     .= '-'                      if ($self->left_align);
        $format     .= $self->min_width         if ($self->has_min_width);
        $format     .= '.'. $self->max_width    if ($self->has_max_width);
        
        return $format.'s';
    },
);

has _simple_format => (
    is          => 'ro',
    lazy        => 1,
    init_arg    => undef,
    default     => sub {
        my $self = shift;
        return !$self->has_min_width && !$self->has_max_width;
    },
);

# builders #####################################################################    

# methods ######################################################################
sub render {
    my ($self, $params) = @_;
    $params ||= {};
    
    my $char = $self->character;
    return $self->value unless (defined $params->{$char});
    
    my $result = $params->{$char};
    
    $result = $result->($self->params) if (ref $result eq 'CODE');
    
    return $result if ($self->_simple_format);
    return sprintf($self->_sprintformat, $result);
}



1;