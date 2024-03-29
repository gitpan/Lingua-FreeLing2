package Lingua::FreeLing2::MorphAnalyzer;

use warnings;
use strict;

use 5.010;
use Carp;
use Lingua::FreeLing2;
use File::Spec::Functions 'catfile';
use Lingua::FreeLing2::Bindings;

our $VERSION = "0.01";

=encoding UTF-8

=head1 NAME

Lingua::FreeLing2::MorphAnalyzer - Interface to FreeLing2 Morphological Analyzer

=head1 SYNOPSIS

   use Lingua::FreeLing2::MorphAnalyzer;

   my $morph = Lingua::FreeLing2::MorphAnalyzer->new("es",
    AffixAnalysis         => 1, AffixFile       => 'afixos.dat',
    QuantitiesDetection   => 0, QuantitiesFile  => "",
    MultiwordsDetection   => 1, LocutionsFile => 'locucions.dat',
    NumbersDetection      => 1,
    PunctuationDetection => 1, PunctuationFile => '../common/punct.dat',
    DatesDetection        => 1,
    DictionarySearch      => 1, DictionaryFile  => 'maco.db',
    ProbabilityAssignment => 1, ProbabilityFile => 'probabilitats.dat',
    NERecognition => 'NER_BASIC', NPdataFile => 'np.dat',
  );

  $sentence = $morph->analyze($sentence);

=head1 DESCRIPTION

Interface to the FreeLing2 Morphological Analyzer library.

=head2 C<new>

Object constructor. One argument is required: the languge code
(C<Lingua::FreeLing2> will search for the data file) or the full or
relative path to the data file. It also receives a lot of options that
are explained below.

Returns the morphological analyzer object for that language, or undef
in case of failure.

=over 4

=item C<AffixAnalysis> (boolean)

=item C<MultiwordsDetection> (boolean)

=item C<NumbersDetection> (boolean)

=item C<PunctuationDetection> (boolean)

=item C<DatesDetection> (boolean)

=item C<QuantitiesDetection> (boolean)

=item C<DictionarySearch> (boolean)

=item C<ProbabilityAssignment> (boolean)

=item C<NERecognition> (option)

NER_BASIC / NER_BIO / NER_NONE

=item C<Decimal> (string)

=item C<Thousand> (string)

=item C<LocutionsFile> (file)

=item C<QuantitiesFile> (file)

=item C<AffixFile> (file)

=item C<ProbabilityFile> (file)

=item C<DictionaryFile> (file)

=item C<NPdataFile> (file)

=item C<PunctuationFile> (file)

=item C<ProbabilityThreshold> (real)

=back

=cut

my %maco_valid_option = (
                         AffixAnalysis         => 'BOOLEAN',
                         MultiwordsDetection   => 'BOOLEAN',
                         NumbersDetection      => 'BOOLEAN',
                         PunctuationDetection  => 'BOOLEAN',
                         DatesDetection        => 'BOOLEAN',
                         QuantitiesDetection   => 'BOOLEAN',
                         DictionarySearch      => 'BOOLEAN',
                         ProbabilityAssignment => 'BOOLEAN',
                         NERecognition         => { 'NER_BASIC' => 0,
                                                    'NER_BIO'   => 1,
                                                    'NER_NONE'  => 2 },
                         Decimal               => 'STRING',
                         Thousand              => 'STRING',
                         LocutionsFile         => 'FILE',
                         QuantitiesFile        => 'FILE',
                         AffixFile             => 'FILE',
                         ProbabilityFile       => 'FILE',
                         DictionaryFile        => 'FILE',
                         NPdataFile            => 'FILE',
                         PunctuationFile       => 'FILE',
                         ProbabilityThreshold  => 'REAL',
                         );

sub _check_option {
    my ($self, $value, $type) = @_;

    given ($type) {
        when ("BOOLEAN") {
            return $value ? 1 : 0;
        }
        when ("REAL") {
            return $value =~ /(\d+(?:\.\d+))?/ ? $1 : undef;
        }
        when ("STRING") {
            $value =~ s/(?<!\\)"/\\"/g;
            return '"'.$value.'"';
        }
        when ("FILE") {
            return "" if $value eq "";
            return '"'.$value.'"' if -f $value;
            my $ofile = catfile($self->{prefix} => $value);
            return '"'.$ofile.'"' if -f $ofile;
            return undef;
        }
        when (qr/NER/) {
            return $type->{$value} // undef;
        }
        default {
            return undef;
        }
    }
}

sub new {
    my ($class, $lang, %maco_op) = @_;

    my $dir;
    if ($lang =~ /^[a-z][a-z]$/i) {
        $dir = Lingua::FreeLing2::_search_language_dir($lang);
        $lang = catfile($dir, "tokenizer.dat") if $dir;
    }

    unless (-f $lang) {
        carp "Cannot find tokenizer data file. Tried [$lang]\n";
        return undef;
    }

    my $self = bless {
                      prefix => $dir,
                      maco_options => Lingua::FreeLing2::Bindings::maco_options->new($lang),
                     } => $class;

    for my $op (keys %maco_op) {
        if ($maco_valid_option{$op}) {
            my $option = $maco_op{$op};
            if (defined($option = $self->_check_option($option, $maco_valid_option{$op}))) {
                my $code = "\$self->{maco_options}->swig_${op}_set($option);";
                eval "$code";
            } else {
                carp "Option $op with invalid value: '$maco_op{$op}'.";
            }
        } else {
            carp "Option '$op' not recognized for MorphAnalyzer object."
        }
    }

    $self->{maco} = Lingua::FreeLing2::Bindings::maco->new($self->{maco_options});
    return $self;
}

=head2 C<analyze>

=cut

sub analyze {
    my ($self, $sentences, %opts) = @_;

    unless (Lingua::FreeLing2::_is_sentence_list($sentences)) {
        carp "Error: analyze argument should be a list of sentences";
        return undef;
    }

    $sentences = $self->{maco}->analyze([map { $_->{sentence} } @$sentences]);

    for my $s (@$sentences) {
        $s = Lingua::FreeLing2::Sentence->_new_from_binding($s);
    }

    return $sentences;

}



### TODO: maco_options
#
# *set_active_modules = *Lingua::FreeLing2::Bindingsc::maco_options_set_active_modules;
# *set_nummerical_points = *Lingua::FreeLing2::Bindingsc::maco_options_set_nummerical_points;
# *set_data_files = *Lingua::FreeLing2::Bindingsc::maco_options_set_data_files;
# *set_threshold = *Lingua::FreeLing2::Bindingsc::maco_options_set_threshold;
#
###


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

