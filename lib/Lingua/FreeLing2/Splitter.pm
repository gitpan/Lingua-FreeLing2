package Lingua::FreeLing2::Splitter;

use 5.010;

use warnings;
use strict;

use Carp;
use Lingua::FreeLing2;
use File::Spec::Functions 'catfile';
use Lingua::FreeLing2::Bindings;
use Lingua::FreeLing2::Sentence;

use parent -norequire, 'Lingua::FreeLing2::Bindings::splitter';

our $VERSION = "0.02";

=encoding UTF-8

=head1 NAME

Lingua::FreeLing2::Splitter - Interface to FreeLing2 Splitter

=head1 SYNOPSIS

   use Lingua::FreeLing2::Splitter;
   use Lingua::FreeLing2::Tokenizer;

   my $pt_tok = Lingua::FreeLing2::Tokenizer->new("pt");
   my $pt_split = Lingua::FreeLing2::Splitter->new("pt");

   # compute list of Lingua::FreeLing2::Words
   my $list_of_words = $pt_tok->tokenize( $text );
   my $list_of_sentences = $pt_split->split($list_of_words);

=head1 DESCRIPTION

Interface to the FreeLing2 splitter library.

=head2 C<new>

Object constructor. One argument is required: the languge code
(C<Lingua::FreeLing2> will search for the splitter data file) or
the full or relative path to the splitter data file.

Returns the splitter object for that language, or undef in case of
failure.

=cut

sub new {
    my ($class, $lang) = @_;

    if ($lang =~ /^[a-z][a-z]$/i) {
        my $dir = Lingua::FreeLing2::_search_language_dir($lang);
        $lang = catfile($dir, "splitter.dat") if $dir;
    }

    unless (-f $lang) {
        carp "Cannot find splitter data file. Tried [$lang]\n";
        return undef;
    }

    # my $self = {
    #             datafile  => $lang,
    #             splitter => Lingua::FreeLing2::Bindings::splitter->new($lang),
    #            };
    my $self = $class->SUPER::new($lang);
    return bless $self => $class
}

=head2 C<split>

This is the only available method for the splitter object. It receives
a list of L<Lingua::FreeLing2::Word> objects (you can obtain one using
the L<Lingua::FreeLing2::Tokenizer>), and splits the text to a list of
sentences.

Without any further configuration option, it will return a reference
to a list of L<Lingua::FreeLing2::Sentence>. The option C<to_text> can
be set, and it will return a reference to a list of strings, where the
words/tokens will be separated by a simple space.

 $list_of_sentences = $pt_split->split($list_of_words, to_text => 1 )

The C<buffered> option can also be set to the value C<0> if the
function should not buffer tokens while processing. The default is to
buffer.

 $list_of_sentences = $pt_split->split($list_of_words, buffered => 0 )

B<NOTE:> Before exiting, your application you B<should> run the split
method without the buffered feature, so that all the text is really
processed!

=cut

sub split {
    my ($self, $tokens, %opts) = @_;

    unless (Lingua::FreeLing2::_is_word_list($tokens)) {
        carp "Error: split argument should be a list of words";
        return undef;
    }

    my $buffered = $opts{buffered} // 1;
    my $result = $self->SUPER::split($tokens, $buffered);

    for my $s (@$result) {
        $s = Lingua::FreeLing2::Sentence->_new_from_binding($s);
        $s = $s->to_text if $opts{to_text};
    }

    return $result;
}

1;

__END__

=head1 SEE ALSO

Lingua::FreeLing2(3) for the documentation table of contents. The
freeling library for extra information, or perl(1) itself.

=head1 AUTHOR

Alberto Manuel Brandão Simões, E<lt>ambs@cpan.orgE<gt>

Jorge Cunha Mendes E<lt>jorgecunhamendes@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Projecto Natura

=cut
