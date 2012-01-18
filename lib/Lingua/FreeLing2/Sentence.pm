package Lingua::FreeLing2::Sentence;
use Lingua::FreeLing2::Word;
use Lingua::FreeLing2::Bindings;
use parent -norequire, 'Lingua::FreeLing2::Bindings::sentence';

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
    my $self = $class->SUPER::new();
    return bless $self => $class #amen
}

sub _new_from_binding {
    my ($class, $sentence) = @_;
    return bless $sentence => $class #amen
}

=head2 ACESSORS

Current sentence acessors are:

=over 4

=item C<words>

Returns a reference to a list of L<Lingua::FreeLing2::Word>.

=cut

sub words {
    my $self = shift;
    my $words = $self->SUPER::get_words;
    for (@$words) {
        $_ = Lingua::FreeLing2::Word->_new_from_binding($_);
    }
    return $words;
}

=item C<is_parsed>

Returns a boolean value stating if the sentence has been parsed or
not.

=cut

# This should be directly called to the superclass
# sub is_parsed {
#     my $self = shift;
#     return $self->SUPER::{sentence}->is_parsed;
# }


=item C<to_text>

Returns a string with words separated by a blank space.

=cut

sub to_text {
    my $self = shift;
    my $words = $self->SUPER::get_words;
    return join(" " => map { $_->get_form } @$words);
}


# XXX - TODO
# *set_parse_tree = *Lingua::FreeLing2::Bindingsc::sentence_set_parse_tree;
# *get_parse_tree = *Lingua::FreeLing2::Bindingsc::sentence_get_parse_tree;
# *get_dep_tree = *Lingua::FreeLing2::Bindingsc::sentence_get_dep_tree;
# *set_dep_tree = *Lingua::FreeLing2::Bindingsc::sentence_set_dep_tree;
# *is_dep_parsed = *Lingua::FreeLing2::Bindingsc::sentence_is_dep_parsed;
# *words_begin = *Lingua::FreeLing2::Bindingsc::sentence_words_begin;
# *words_end = *Lingua::FreeLing2::Bindingsc::sentence_words_end;

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

Copyright (C) 2011 by Projecto Natura

=cut


