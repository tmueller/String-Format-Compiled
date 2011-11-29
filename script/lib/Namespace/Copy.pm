package Namespace::Copy;

# uses #########################################################################    
use v5.10;

use Mouse;

use File::Copy::Recursive qw~dircopy~;
use File::Find::Rule;
use Path::Class::Dir;

# types ########################################################################
use MouseX::Types::Mouse qw~Str~;
use MouseX::Types::Path::Class qw~Dir~;

# roles + inheritance ##########################################################
with 'MouseX::Getopt';

# attributes ###################################################################    
has from => (
    is              => 'ro', 
    isa             => Dir,
    required        => 1,
    coerce          => 1,
    documentation   => 'lib from where to copy',
);

has to => (
    is              => 'ro', 
    isa             => Dir,
    required        => 1,
    coerce          => 1,
    documentation   => 'lib to where to copy',
);

has from_ns => (
    is              => 'ro', 
    isa             => Str,
    required        => 1,
    documentation   => 'copy from this namespace',
);

has to_ns => (
    is              => 'ro', 
    isa             => Str,
    required        => 1,
    documentation   => 'copy to this namespace',
);

has _from_ns_dir => (
    is              => 'ro', 
    isa             => Dir,
    required        => 1,
    default         => sub {
        my $self = shift;
        my $from_ns = $self->from_ns;
        $from_ns =~ s|::|/|g;
        $self->from->subdir( $from_ns );
    },
);

has _to_ns_dir => (
    is              => 'ro', 
    isa             => Dir,
    required        => 1,
    default         => sub {
        my $self = shift;
        my $to_ns = $self->to_ns;
        $to_ns =~ s|::|/|g;
        $self->to->subdir( $to_ns );
    },
);

# builders #####################################################################    

# methods ######################################################################
sub run {
    my $self = shift;
    
    my $from_ns     = $self->from_ns;
    my $to_ns       = $self->to_ns;
    my @packages    = File::Find::Rule->file()->name('*.pm')->in($self->_from_ns_dir->parent->absolute); 
    
    for my $package (@packages) {
        print "copying $package ";
        my $content = Path::Class::File->new($package)->slurp;
        
        $content =~ s/$from_ns/$to_ns/eg;
        my $packagename;
        if ($content =~ /(?:package|class|role)[\s\n\r\t]+([A-Z:]+)[\s\n\r\t]*[\{;]/i) {
            $packagename = $1;
        } else {
            print "cannot find package inside $package";
            next;
        }
        
       
        say "to $packagename";
        
        my @packagepath = split (/::/, $packagename || '');
        
        my $classname   = pop @packagepath;
        my $outdir      = $self->to->subdir(@packagepath);
        my $outfile     = $outdir->file("$classname.pm");
        
        $outdir->mkpath;
        $outfile->touch;
        print { $outfile->openw } $content;
    }
}

__PACKAGE__->meta->make_immutable;
no Mouse;
1;