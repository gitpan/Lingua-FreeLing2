package Lingua::FreeLing2::ChartParser;

use warnings;
use strict;

use Carp;
use Lingua::FreeLing2;
use File::Spec::Functions 'catfile';
use Lingua::FreeLing2::Bindings;
use Lingua::FreeLing2::Sentence;

use parent -norequire, 'Lingua::FreeLing2::Bindings::chart_parser';

our $VERSION = "0.01";


=encoding UTF-8

=head1 NAME

Lingua::FreeLing2::ChartParser - Interface to FreeLing2 ChartParser

=head1 SYNOPSIS

   use Lingua::FreeLing2::ChartParser;

   my $pt_tagger = Lingua::FreeLing2::ChartParser->new("pt");

   $taggedListOfSentences = $pt_tagger->analyze($listOfSentences);

=head1 DESCRIPTION

Interface to the FreeLing2 chart tagger library.

=head2 C<new>

Object constructor. One argument is required: the languge code
(C<Lingua::FreeLing2> will search for the tagger data file) or the full
or relative path to the dependencies file.

=cut

sub new {
    my ($class, $lang, %ops) = @_;

    my $language;
    if ($lang =~ /^[a-z]{2}$/i) {
        $language = lc($lang);
        my $dir = Lingua::FreeLing2::_search_language_dir($lang);
        $lang = catfile($dir, "grammar-dep.dat") if $dir;
    }

    unless (-f $lang) {
        carp "Cannot find chart tagger data file. Tried [$lang]\n";
        return undef;
    }

    my $self = $class->SUPER::new($lang);
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

    $sentences = $self->SUPER::analyze([map { $_->{sentence} } @$sentences]);

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

Copyright (C) 2011-2012 by Projecto Natura

=cut
