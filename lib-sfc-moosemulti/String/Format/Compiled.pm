package String::Format::Compiled;

# uses #########################################################################    
use Moose;
use MooseX::HasDefaults::RO;
use MooseX::Method::Signatures;
use MooseX::MultiMethods;

use String::Format::Compiled::Sequence;
use String::Format::Compiled::String;

# types ########################################################################
use MooseX::Types::Moose qw~Str ClassName ArrayRef Undef~;

# roles + inheritance ##########################################################

# attributes ###################################################################    
has format => (
    isa         => Str,
    required    => 1,
);

has _compiled_format => (
    traits      => ['Array'],
    isa         => ArrayRef,
    init_arg    => undef,
    lazy        => 1,
    builder     => '_build_compiled_format',
    handles     => {
        _all_tokens  => 'elements',
    },
);

# builders #####################################################################    
method _build_compiled_format {
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
multi method BUILDARGS (ClassName $class: Str $format) {
    return $class->BUILDARGS(format => $format);
}

method BUILD {
    $self->_compiled_format;
}

multi method render (HashRef $params) {
    my $output = '';
    
    $params->{'n'} = "\n" unless exists $params->{'n'};
    $params->{'t'} = "\t" unless exists $params->{'t'};
    $params->{'%'} = "%"  unless exists $params->{'%'};
    
    $output .= $_->render($params) for ($self->_all_tokens);
    return $output;
}

multi method render (Undef $u) { $self->render({}) }

# TODO: contains-methods for seqs
# method contains

__PACKAGE__->meta->make_immutable;
no Moose;
1;