use strict;
use warnings;

use Carp;
use lib 'inc';
use MyBuilder;
use ExtUtils::PkgConfig;

use File::Which;
use File::Spec;
use Cwd 'abs_path';


## Guess prefix
my $prefix = undef;
if ($ENV{FL_PREFIX}) {
    $prefix   = $ENV{FL_PREFIX} if -d $ENV{FL_PREFIX};
    warn "Variable FL_PREFIX value is not a valid directory." if !$prefix;
}
$prefix = guess_prefix() if !$prefix;
print STDERR " - FreeLing prefix: $prefix\n";


## Guess datadir
my $data_dir = undef;
if ($ENV{FL_DATADIR}) {
    $data_dir = $ENV{FL_DATADIR} if -d $ENV{FL_DATADIR};
    warn "Variable FL_DATADIR value is not a valid directory.\n" if !$data_dir;
}
$data_dir = guess_data_dir($prefix) if !$data_dir;
print STDERR " - FreeLing data dir: $data_dir\n";

## Guess pcre
my %pcre = ExtUtils::PkgConfig->find('libpcre');
if (!$pcre{libs}) {
    warn "libcpre not found...?\n";
    exit 0;
}
my $pcre = $pcre{libs};
print STDERR " - pcre lib flags: $pcre\n";


## Builder...
my $builder = MyBuilder->new
  (
   module_name    => 'Lingua::FreeLing2',
   license        => 'perl',
   dist_author    => [
                      'Jorge Cunha Mendes <jorgecunhamendes@gmail.com>',
                      'Alberto Simões <ambs@cpan.org>'
                     ],
   needs_compiler => 1,
   recursive_test_files => 1,
   configure_requires => {
                          'ExtUtils::PkgConfig' => '1.12',
                          'Module::Build' => '0.36',
                          'File::Which' => '0'
                         },
   build_requires => {
                      'Test::Warn' => '0',
                     },
   requires => {
                'Try::Tiny' => '0',
                'Carp' => '0',
               },
   add_to_cleanup => [
                      'FreeLing.o', 'pm_to_blib',
                      qw'*~ */*~ */*/*~ */*/*/*~ */*/*/*/*~'
                     ],
  );


$builder->config_data(fl_prefix  => $prefix);
$builder->config_data(fl_datadir => $data_dir);
$builder->notes(pcre_libs => $pcre);
$builder->create_build_script;



sub guess_prefix {
    my $dicc2phon = abs_path(scalar(which('dicc2phon')));
    if (!-f $dicc2phon) {
        print STDERR "Freeling dicc2phon app not found. Aborting...\n";
        exit 0;
    }
    my ($volume, $dirs, $file) = File::Spec->splitpath($dicc2phon);
    my @dirs = File::Spec->splitdir($dirs);
    pop @dirs while ($dirs[-1] eq "bin" || $dirs[-1] eq "");
    return File::Spec->catpath($volume, File::Spec->catdir(@dirs), '');
}

sub guess_data_dir {
    my $prefix = shift;
    # $file here is topdir folder of prefix, so, keep it
    my ($volume, $dirs, $file) = File::Spec->splitpath($prefix);
    $dirs = File::Spec->catdir($dirs, $file, 'share', 'FreeLing');
    my $data_dir = File::Spec->catpath($volume, $dirs, '');
    if (!-d $data_dir) {
        warn "Could not guess data directory for Freeling.\n";
        exit 0;
    }
    return $data_dir
}
