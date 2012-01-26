package Lingua::FreeLing2;

use strict;
use warnings;

use v5.10;

use Carp;
use Try::Tiny;
use Lingua::FreeLing2::ConfigData;
use File::Spec::Functions 'catfile';

our $VERSION = "0.01_03";

sub _validate_option {
    my ($value, $type, $default) = @_;
    if (defined($value) && exists($type->{$value})) {
        return $type->{$value};
    } else {
        carp "Option '$value' not valid." if defined $value;
        return $type->{$default};
    }
}

sub _validate_bool {
    my ($value, $default) = @_;
    if (defined($value)) {
        return $value ? 1 : 0;
    } else {
        return $default;
    }
}

sub _validate_integer {
    my ($value, $default) = @_;
    if (defined($value) && $value =~ /^\d+$/) {
        $value
    } else {
        carp "Setting weird value as integer." if defined $value;
        return $default;
    }
}

sub _validate_real {
    my ($value, $default) = @_;
    if (defined($value) && $value =~ /^\d+(?:\.\d+)?|\d*\.\d+$/) {
        $value
    } else {
        carp "Setting weird value as a real." if defined $value;
        return $default;
    }
}

sub _validate_prob {
    my ($value, $default) = @_;
    if (defined($value) && $value =~ /(\d+(?:\.\d+)? | \.\d+)/x && $1 >= 0 && $1 <= 1) {
        return $1
    } else {
        carp "Setting weird value as a probability value." if defined $value;
        return $default;
    }
}

sub _search_language_dir {
    my $lang = lc(shift @_);
    my $fl_datadir = Lingua::FreeLing2::ConfigData->config('fl_datadir');
    my $supposed_dir = catfile($fl_datadir, $lang);
    return (-d $supposed_dir) ? $supposed_dir : undef;
}

sub _is_word_list {
    my $l = shift;
    return undef unless ref($l) eq "ARRAY";
    for my $w (@$l) {
        try {
            return 0 unless $w->isa("Lingua::FreeLing2::Bindings::word");
        } catch {
            return 0;
        }
    }
    return 1;
}

sub _is_sentence_list {
    my $l = shift;
    return undef unless ref($l) eq "ARRAY";
    for my $w (@$l) {
        my $fail = 0;
        try {
            $fail = 1 unless $w->isa("Lingua::FreeLing2::Sentence");
        } catch {
            $fail = 1;
        };
        return 0 if $fail
    }
    return 1;
}

1

__END__

=head1 NAME

Lingua::FreeLing2 - a library for language analysis.

=head1 DESCRIPTION

This module is a Perl wrapper to FreeLing C++ library.
You can check the details on this library visiting its webpage
L<http://nlp.lsi.upc.edu/freeling/>.

The module is divided into different submodules, each with different
purposes.

=head1 SEE ALSO

L<Lingua::FreeLing2::Word>

L<Lingua::FreeLing2::Splitter>

L<Lingua::FreeLing2::Sentence>

L<Lingua::FreeLing2::Tokenizer>

L<Lingua::FreeLing2::Word::Analysis>

L<Lingua::FreeLing2::HMMTagger>

L<Lingua::FreeLing2::MorphAnalyzer>

=cut

