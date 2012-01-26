package Lingua::FreeLing2::Sentence;
use Lingua::FreeLing2::Word;
use Lingua::FreeLing2::ParseTree;
use Lingua::FreeLing2::Bindings;

use warnings;
use strict;

our $VERSION = "0.02";

=encoding UTF-8

=head1 NAME

Lingua::FreeLing2::Sentence - Interface to FreeLing2 Sentence object

=head1 SYNOPSIS

   use Lingua::FreeLing2::Sentence;

   my $words = $sentence->words;

   my $sentence = $sentence->to_text;

=head1 DESCRIPTION

This module is a wrapper to the FreeLing2 Sentence object (a list of
words, that someone has validated as a complete sentence.

=head2 CONSTRUCTOR

=over 4

=item C<new>

The constructor returns a new Sentence object. As no setters are
available (for now), it is not really relevant. Tests are being done
to understand how to set/add words in the sentence.

=back

=cut

# XXX: make this a polymorphic new
sub new {
    my $class = shift;
    my $self = { sentence => Lingua::FreeLing2::Bindings::sentence->new() };
    return bless $self => $class #amen
}

sub _new_from_binding {
    my ($class, $sentence) = @_;

    my $self = bless { sentence => $sentence } => $class;
    if ($sentence->is_parsed) {
        $self->{parse_tree} = Lingua::FreeLing2::ParseTree->_new_from_sentence($self);
    }

    return $self;
}

=head2 ACESSORS

Current sentence acessors are:

=over 4

=item C<words>

Returns a list of L<Lingua::FreeLing2::Word>.

=cut

sub words {
    my $self = shift;
    my $words = $self->{sentence}->get_words;
    return map {
        Lingua::FreeLing2::Word->_new_from_binding($_)
      } @$words;
}

=item C<to_text>

Returns a string with words separated by a blank space.

=cut

sub to_text {
    my $self = shift;
    my $words = $self->{sentence}->get_words;
    return join(" " => map { $_->get_form } @$words);
}


# XXX - TODO
# *set_parse_tree = *Lingua::FreeLing2::Bindingsc::sentence_set_parse_tree;
# *get_parse_tree = *Lingua::FreeLing2::Bindingsc::sentence_get_parse_tree;
# *get_dep_tree = *Lingua::FreeLing2::Bindingsc::sentence_get_dep_tree;
# *set_dep_tree = *Lingua::FreeLing2::Bindingsc::sentence_set_dep_tree;
# *words_begin = *Lingua::FreeLing2::Bindingsc::sentence_words_begin;
# *words_end = *Lingua::FreeLing2::Bindingsc::sentence_words_end;

=item C<parse_tree>

Returns the current parse tree, if there is any.

=cut

sub parse_tree {
    my $self = shift;

    return $self->{parse_tree};
}

=item C<is_dep_parsed>

Checks if the sentence has been parsed by a dependency parser.

=cut

sub is_dep_parsed {
    my $self = shift;
    return $self->{sentence}->is_dep_parsed();
}

=item C<is_parsed>

Checks if the sentence has been parsed by a dependency parser.

=cut

sub is_parsed {
    my $self = shift;
    return $self->{sentence}->is_parsed();
}

1;

__END__

=back

=head1 SEE ALSO

Lingua::FreeLing2(3) for the documentation table of contents. The
freeling library for extra information, or perl(1) itself.

=head1 AUTHOR

Alberto Manuel Brandão Simões, E<lt>ambs@cpan.orgE<gt>

Jorge Cunha Mendes E<lt>jorgecunhamendes@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011-2012 by Projecto Natura

=cut


