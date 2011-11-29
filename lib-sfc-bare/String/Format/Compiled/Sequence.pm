package String::Format::Compiled::Sequence;

# uses #########################################################################    
use strict;
use warnings;

sub new {
    my ($class, @params) = @_;      

    my $self = { @params };
    bless($self, $class);
    
    $self->{_sprintformat}  = $self->_build_sprintformat;
    $self->{_simple_format} = !exists $self->{min_width} && !exists $self->{max_width};

    return $self;
}

# attributes ###################################################################
sub _build_sprintformat {
    my $self            = shift;
    my $has_min_width   = exists $self->{min_width};
    my $has_max_width   = exists $self->{max_width};
    
    my $format  = '%';
    
    $format     .= '-'                      if ($self->{left_align});
    $format     .= $self->{min_width}       if ($has_min_width);
    $format     .= '.'. $self->{max_width}  if ($has_max_width);
    
    return $format.'s';
}
# builders #####################################################################    

# methods ######################################################################
sub render {
    my ($self, $params) = @_;
    my $char = $self->{character};
    return $self->{value} unless (defined $params->{$char});
    
    my $result = $params->{$char};
    
    $result = $result->($self->{params}) if (ref $result eq 'CODE');

    return $result if ($self->{_simple_format});
    return sprintf($self->{_sprintformat}, $result);
}


1;