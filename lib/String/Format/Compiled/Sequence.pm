package String::Format::Compiled::Sequence;
# ABSTRACT: Sequence Part of a Format, a Placeholder

# uses #########################################################################    
use Mouse;

# types ########################################################################
use MouseX::Types::Mouse            qw~Str Int CodeRef Bool~;
use String::Format::Compiled::Types qw~Char~;

# roles + inheritance ##########################################################

# attributes ###################################################################
# TODO: parameters for coderefs + tests
has character => (
    is          => 'ro',
    isa         => Char,
    required    => 1,
);

has value => (
    is          => 'ro',
    isa         => Str,
    required    => 1,
);

has left_align => (
    is          => 'ro',
    isa         => Bool,
    default     => 0, 
);

has min_width => (
    is          => 'ro',
    isa         => Int,
    predicate   => 'has_min_width', 
);

has max_width => (
    is          => 'ro',
    isa         => Int,
    predicate   => 'has_max_width', 
);

has params  => (
    is          => 'ro',
    isa         => Str,
);

has _sprintformat => (
    is          => 'ro',
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
    is          => 'ro',
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
sub render {
    my ($self, $params) = @_;
    $params ||= {};
    
    my $char = $self->character;

    return $self->value unless (defined $params->{$char}); 

    my $result = $params->{$char};
    #$result = $result->($self->params) if (CodeRef->check($result)); # slow
    $result = $result->($self->params) if (ref $result eq 'CODE');

    
    return $result if ($self->_simple_format);
    return sprintf($self->_sprintformat, $result);
}


__PACKAGE__->meta->make_immutable;
no Mouse;
1;