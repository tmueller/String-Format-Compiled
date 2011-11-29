use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Namespace::Copy;
use File::Find::Rule;

my $project_dir = "$FindBin::Bin/..";
my $target_dir  = "$project_dir/lib-sfc";

for my $dirname (File::Find::Rule->directory->maxdepth(1)->name(qr~lib-sfc-~)->in($project_dir)) {
    next unless ($dirname =~ /lib-sfc-([^-]+)$/);
    my $shortname = ucfirst $1;
    
    Namespace::Copy->new(
        to      => $target_dir,
        from    => $dirname,
        from_ns => 'String::Format::Compiled',
        to_ns   => "String::Format::Compiled::$shortname",
    )->run;
}

Namespace::Copy->new(
    to      => $target_dir,
    from    => "$project_dir/lib",
    from_ns => 'String::Format::Compiled',
    to_ns   => "String::Format::Compiled::Mouse",
)->run;