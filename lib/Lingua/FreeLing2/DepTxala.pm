package Lingua::FreeLing2::DepTxala;

use warnings;
use strict;

use Carp;
use Lingua::FreeLing2;
use File::Spec::Functions 'catfile';
use Lingua::FreeLing2::Bindings;
use Lingua::FreeLing2::Sentence;
use Lingua::FreeLing2::ChartParser;

our $VERSION = "0.01";


=encoding UTF-8

=head1 NAME

Lingua::FreeLing2::DepTxala - Interface to FreeLing2 DetTxala

=head1 SYNOPSIS

   use Lingua::FreeLing2::DepTxala;

   my $pt_parser = Lingua::FreeLing2::DepTxala->new("pt");

   $taggedListOfSentences = $pt_parser->analyze($listOfSentences);

=head1 DESCRIPTION

Interface to the FreeLing2 txala parser library.

=head2 C<new>

Object constructor. One argument is required: the languge code
(C<Lingua::FreeLing2> will search for the parser and the txala data
files) or the full or relative path to the dependencies file together
with the full or relative path to the chart parser data file.

=cut

sub new {
    my $class = shift;
    my $lang = shift;

    my $chart_parser_file;
    my $dep_txala_file;

    if ($lang =~ /^[a-z]{2}$/i) {
        # lets guess everything
        my $dir = Lingua::FreeLing2::_search_language_dir(lc $lang);
        if ($dir) {
            $chart_parser_file = catfile($dir, "grammar-dep.dat");
            $dep_txala_file = catfile($dir, "dep", "dependences.dat");
        }
    } else {
        $dep_txala_file = $lang;
        $chart_parser_file = shift;
    }
    my %ops = @_;

    unless (-f $chart_parser_file) {
        carp "Cannot find chart parser data file. Tried [$chart_parser_file]\n";
        return undef;
    }

    unless (-f $dep_txala_file) {
        carp "Cannot find txala data file. Tried [$dep_txala_file]\n";
        return undef;
    }

    my $self =
      {
       txala_file => $dep_txala_file,
       chart_file => $chart_parser_file,
      };
    return bless $self => $class
}


=head2 C<analyze>

Receives a list of sentences, and returns that same list of sentences
after tagging process, enriching each sentence with a parse tree.

=cut

sub analyze {
    my ($self, $sentences, %opts) = @_;

    unless (Lingua::FreeLing2::_is_sentence_list($sentences)) {
        carp "Error: analyze argument isn't a list of sentences";
        return undef;
    }

    my $junk = Lingua::FreeLing2::Bindings::dep_txala->new($self->{txala_file},"bar");
    $sentences = $junk->my_analyze($self->{txala_file},
                                   $self->{chart_file},
                                   [ map { $_->{sentence} } @$sentences]);
    for my $s (@$sentences) {
        $s = Lingua::FreeLing2::Sentence->_new_from_binding($s);
    }
    return $sentences;
}


1;

__END__

=head1 SEE ALSO

Lingua::FreeLing2 (3), freeling, perl(1)

=head1 AUTHOR

Alberto Manuel Brandão Simões, E<lt>ambs@cpan.orgE<gt>

Jorge Cunha Mendes E<lt>jorgecunhamendes@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Projecto Natura

=cut
