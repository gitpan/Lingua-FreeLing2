# -*- cperl -*-
use Test::More;

use warnings;
use strict;

my @modules;

BEGIN {
    @modules = qw(Lingua::FreeLing2
                  Lingua::FreeLing2::Word
                  Lingua::FreeLing2::Splitter
                  Lingua::FreeLing2::Sentence
                  Lingua::FreeLing2::Document
                  Lingua::FreeLing2::DepTxala
                  Lingua::FreeLing2::Paragraph
                  Lingua::FreeLing2::HMMTagger
                  Lingua::FreeLing2::Tokenizer
                  Lingua::FreeLing2::ParseTree
                  Lingua::FreeLing2::ChartParser
                  Lingua::FreeLing2::RelaxTagger
                  Lingua::FreeLing2::MorphAnalyzer
                  Lingua::FreeLing2::Word::Analysis);

    plan tests => 1 + scalar(@modules)*2;

    use_ok 'Lingua::FreeLing2::Bindings';
    use_ok "$_" for @modules;


}

diag( "Testing Lingua::FreeLing2 $Lingua::FreeLing2::VERSION" );

ok("${_}::VERSION" => "version defined for $_") for @modules;

