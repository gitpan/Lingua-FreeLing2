# -*- cperl -*-

use warnings;
use strict;

use utf8;

use Data::Dumper;

use Test::More tests => 16;
use Test::Warn;
use Lingua::FreeLing2::RelaxTagger;
use Lingua::FreeLing2::MorphAnalyzer;
use Lingua::FreeLing2::Tokenizer;
use Lingua::FreeLing2::Splitter;

my $tagger = Lingua::FreeLing2::RelaxTagger->new("es");

# defined
ok($tagger);
isa_ok($tagger => 'Lingua::FreeLing2::RelaxTagger');
isa_ok($tagger => 'Lingua::FreeLing2::Bindings::relax_tagger');

warning_is
  { ok(!$tagger->analyze()) }
  { carped => "Error: analyze argument isn't a list of sentences" };

warning_is
  { ok(!$tagger->analyze("foo")) }
  { carped => "Error: analyze argument isn't a list of sentences" };

warning_is
  { ok(!$tagger->analyze("")) }
  { carped => "Error: analyze argument isn't a list of sentences" };

warning_is
  { ok(!$tagger->analyze([qw"foo bar zbr ugh"])) }
  { carped => "Error: analyze argument isn't a list of sentences" };

my $text = <<EOT;
Con el fin del toque de queda, a las ocho de la mañana (una hora menos
en la España peninsular), las calles de El Cairo y otras ciudades
egipcias han recuperado una tensa calma, después de una noche de
saqueos y vandalismo que sucedieron a las protestas masivas y las
concentraciones. A la luz del día, la tensión es mayor que en días
anteriores de multitudinaria protesta contra el presidente, Hosni
Mubarak. Al contrario que ayer, los militares entorpecen el paso de
los ciudadanos a los puntos neurálgicos de la revuelta en el centro de
El Cairo, con muros de hormigón y cacheos e incluso han disparado al
aire para dispersar a la multitud. Pese a ello, dos horas antes del
inicio del nuevo toque de queda, a las cuatro de la tarde, miles de
personas llenan otra vez la plaza Tahrir. Los partidos opositores que
hasta las últimas elecciones tenían presencia parlamentaria, incluidos
los Hermanos Musulmanes, están reunidos en este momento para tratar de
buscar una salida a la crisis, mientras que el Ministerio de
Información ha acallado a Al Yazira, la única cadena de televisión que
retransmitía en directo de forma continua la revuelta.
EOT

my $tokenizer = Lingua::FreeLing2::Tokenizer->new('es');
ok $tokenizer => "we have a tokenizer";

my $splitter  = Lingua::FreeLing2::Splitter->new('es');
ok $splitter  => "we have a splitter";

my $tokens    = $tokenizer->tokenize($text);
my $sentences = $splitter->split($tokens);

my $analyzer  = Lingua::FreeLing2::MorphAnalyzer->new("es",
                                                     AffixAnalysis   => 1,
                                                     AffixFile       => 'afixos.dat',
                                                     MultiwordsDetection => 1,
                                                     NumbersDetection => 1,
                                                     DatesDetection  => 1,
                                                     PunctuationDetection => 1,
                                                     DictionarySearch => 1,
                                                     ProbabilityAssignment => 1,
                                                     QuantitiesDetection => 0,
                                                     NERecognition   => 'NER_BASIC',
                                                     PunctuationFile => '../common/punct.dat',
                                                     LocutionsFile   => 'locucions.dat',
                                                     ProbabilityFile => 'probabilitats.dat',
                                                     DictionaryFile  => 'maco.db',
                                                     NPdataFile      => 'np.dat',
                                                     QuantitiesFile  => "",
                                               );
ok($analyzer  => "we have an analyzer");

$sentences = $analyzer->analyze($sentences);

# is(ref($sentences) => "ARRAY");
# isa_ok($sentences->[0] => 'Lingua::FreeLing2::Sentence');

# # is($sentences->[0]->is_parsed, 0);

# my @words = $sentences->[0]->words;
# my $word_before = $words[6];
# isa_ok($word_before => "Lingua::FreeLing2::Word");

#use Data::Dumper;
#print STDERR Dumper(($sentences->[0]->words)[$_]->as_hash) for (0..6);

$sentences = $tagger->analyze($sentences);
is ref($sentences) => "ARRAY";
isa_ok $sentences->[0] => 'Lingua::FreeLing2::Sentence';


#print STDERR Dumper(($sentences->[0]->words)[$_]->as_hash) for (0..6);

# #is($sentences->[0]->is_parsed, 1); ## freeling bug

# my $word_after = ($sentences->[0]->words)[6];
# isa_ok($word_after => "Lingua::FreeLing2::Word");

