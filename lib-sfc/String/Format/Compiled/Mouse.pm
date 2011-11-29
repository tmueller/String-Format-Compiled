package String::Format::Compiled::Mouse;

# uses #########################################################################    
use Mouse 0.97;

use String::Format::Compiled::Mouse::Sequence;
use String::Format::Compiled::Mouse::String;

# types ########################################################################
use MouseX::Types::Mouse qw~Str ClassName ArrayRef Undef~;

# roles + inheritance ##########################################################

# attributes ###################################################################    
has format => (
    is          => 'ro',
    isa         => Str,
    required    => 1,
);

has _compiled_format => (
    traits      => ['Array'],
    is          => 'ro',
    isa         => ArrayRef,
    init_arg    => undef,
    lazy        => 1,
    builder     => '_build_compiled_format',
    handles     => {
        _all_tokens  => 'elements',
    },
);

# builders #####################################################################    
sub _build_compiled_format {
    my $self = shift;
    
    my $format = $self->format;
    my @parts;
    
    # regex stolen from String::Format + enhanced "optional stuff"
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
        push @parts, String::Format::Compiled::Mouse::String::->new(value => $1) if ($1);
        
        my $sequence = String::Format::Compiled::Mouse::Sequence::->new(
            value       => $2,
            left_align  => defined $3 && $3 eq '-',
            ($4 ? (min_width    => $4) : ()),
            ($5 ? (max_width    => $5) : ()),
            ($6 ? (params       => $6) : ()),
            character   => $7,
        );
        
        push @parts, $sequence;
    }
    
    push @parts, String::Format::Compiled::Mouse::String::->new(value => $format) if ($format);    
    
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
    
    $output .= $_->render($params) for ($self->_all_tokens);
    return $output;
}

# TODO: contains-methods for seqs
# method contains

__PACKAGE__->meta->make_immutable;
no Mouse;
1;

__END__

# ABSTRACT: Formats Strings