package String::Format::Compiled;

# uses #########################################################################    
use Moo;

use String::Format::Compiled::Sequence;
use String::Format::Compiled::String;

# types ########################################################################

# roles + inheritance ##########################################################

# attributes ###################################################################    
has format => (
    is          => 'ro',
    required    => 1,
);

has _compiled_format => (
    is          => 'ro',
    init_arg    => undef,
    lazy        => 1,
    builder     => '_build_compiled_format',
);

# builders #####################################################################    
sub _build_compiled_format {
    my $self = shift;
    
    my $format = $self->format;
    my @parts;
    my $regex = qr/
        ([^%]*)             # leading Stringpart
        (%                  # leading '%'
            (-)?            # left-align, rather than right
            (\d*)?          # (optional) minimum field width
            (?:\.(\d*))?    # (optional) maximum field width
            (?:{(.*?)})?    # (optional) stuff inside
            (\S)            # actual format character
        )
    /x;
    
    while ($format =~ s/$regex//) {
        push @parts, String::Format::Compiled::String::->new(value => $1) if ($1);
        
        my $sequence = String::Format::Compiled::Sequence::->new(
            value       => $2,
            left_align  => defined $3 && $3 eq '-',
            ($4 ? (min_width    => $4) : ()),
            ($5 ? (max_width    => $5) : ()),
            ($6 ? (params       => $6) : ()),
            character   => $7,
        );
        
        push @parts, $sequence;
    }
    
    push @parts, String::Format::Compiled::String::->new(value => $format) if ($format);    
    
    return \@parts;
}

# methods ######################################################################
around BUILDARGS => sub {
    my $orig    = shift;
    my $class   = shift;
   
    return $class->$orig(format => $_[0]) if (@_== 1 && !ref $_[0]);
    return $class->$orig(@_);
};


sub BUILD {
    shift->_compiled_format;
}

sub render {
    my ($self, $params) = @_;
    $params ||= {};
    
    my $output = '';
    
    $params->{'n'} = "\n" unless exists $params->{'n'};
    $params->{'t'} = "\t" unless exists $params->{'t'};
    $params->{'%'} = "%"  unless exists $params->{'%'};
    
    $output .= $_->render($params) for (@{ $self->_compiled_format });
    return $output;
}


# TODO: contains-methods for seqs
# method contains

1;