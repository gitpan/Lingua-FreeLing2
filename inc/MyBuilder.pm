package MyBuilder;
use base 'Module::Build';

use warnings;
use strict;

use Config;
use Carp;

use ExtUtils::PkgConfig;
use ExtUtils::Mkbootstrap;
use Config::AutoConf;

use File::Spec::Functions qw.catdir catfile.;
use File::Path qw.mkpath.;

sub ACTION_code {
    my $self = shift;
    $self->dispatch("create_objects");
    $self->dispatch("compile_xscode");
    $self->SUPER::ACTION_code;
}

sub ACTION_compile_xscode {
    my $self = shift;
    my $cbuilder = $self->cbuilder;
    my $archdir  = catdir( $self->blib, 'arch', 'auto', 'Lingua', 'FreeLing2', 'Bindings');
    mkpath( $archdir, 0, 0777 ) unless -d $archdir;

    my $object = 'FreeLing.o';

    my $bs_file = catfile( $archdir => "Bindings.bs" );
    if ( !$self->up_to_date( $object, $bs_file ) ) {
        ExtUtils::Mkbootstrap::Mkbootstrap($bs_file);
        if ( !-f $bs_file ) {
            # Create file in case Mkbootstrap didn't do anything.
            open( my $fh, '>', $bs_file ) or confess "Can't open $bs_file: $!";
        }
        utime( (time) x 2, $bs_file );    # touch
    }

    # .o => .(a|bundle)
    my $lib_file = catfile( $archdir => "Bindings.$Config{dlext}" );
    if ( !$self->up_to_date( [ $object, $bs_file ], $lib_file ) ) {

        my %pcre = ExtUtils::PkgConfig->find('libpcre');
        if (!$pcre{libs}) {
            warn "libcpre not found...?\n";
            exit 1;
        }
        my $pcre = $pcre{libs};

        #        my $boost_mt = Config::AutoConf->check_lib("boost_filesystem-mt","init");
        # $boost_mt = $boost_mt ? "-mt" : "";

        $cbuilder->link(
                        module_name => 'Lingua::FreeLing2::Bindings',
#                         ($^O !~ /darwin/)?
#                         (extra_linker_flags => "-Lbtparse/src -Wl,-R${btparselibdir} -lbtparse "):
#                         (extra_linker_flags => "-Lbtparse/src -lbtparse "),
                        extra_linker_flags => qq{-g -lmorfo -ldb_cxx $pcre
                                                 -lfries -lomlet
                                                 -lboost_filesystem-mt},
                        objects     => [$object],
                        lib_file    => $lib_file,
                       );
    }
}

sub ACTION_create_objects {
    my $self = shift;
    my $cbuilder = $self->cbuilder;

    die "Do not have a C++ compiler" unless $cbuilder->have_cplusplus;

    my $file = catfile('swig','FreeLing_wrap.cxx');
    my $object = 'FreeLing.o';
    return if $self->up_to_date($file, $object);
    $cbuilder->compile(object_file  => $object,
                       extra_compiler_flags => '-g',
                       source       => $file,
                       'C++'        => 1);
}

1;
