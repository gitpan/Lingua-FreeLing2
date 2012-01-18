# -*- cperl -*-
use Test::More tests => 1 + 8 * 2;

use warnings;
use strict;

BEGIN {
    use_ok( 'Lingua::FreeLing2' );
    use_ok( 'Lingua::FreeLing2::Bindings' );
    use_ok( 'Lingua::FreeLing2::Tokenizer' );
    use_ok( 'Lingua::FreeLing2::Splitter' );
    use_ok( 'Lingua::FreeLing2::Word' );
    use_ok( 'Lingua::FreeLing2::Sentence' );
    use_ok( 'Lingua::FreeLing2::MorphAnalyzer' );
    use_ok( 'Lingua::FreeLing2::Word::Analysis' );
    use_ok( 'Lingua::FreeLing2::HMMTagger' );
}

diag( "Testing Lingua::FreeLing2 $Lingua::FreeLing2::VERSION" );

ok($Lingua::FreeLing2::VERSION                 => "version defined for FreeLing2.pm");
ok($Lingua::FreeLing2::Word::Analysis::VERSION => "version defined for Word::Analysis.pm");
ok($Lingua::FreeLing2::Tokenizer::VERSION      => "version defined for Tokenizer.pm");
ok($Lingua::FreeLing2::Splitter::VERSION       => "version defined for Splitter.pm");
ok($Lingua::FreeLing2::Word::VERSION           => "version defined for Word.pm");
ok($Lingua::FreeLing2::Sentence::VERSION       => "version defined for Sentence.pm");
ok($Lingua::FreeLing2::MorphAnalyzer::VERSION  => "version defined for MorphAnalyzer.pm");
ok($Lingua::FreeLing2::HMMTagger::VERSION      => "version defined for HMMTagger.pm");

