# -*- cperl -*-

use warnings;
use strict;

use Test::More tests => 29;
use Test::Warn;
use Lingua::FreeLing2::MorphAnalyzer;
use Lingua::FreeLing2::Tokenizer;
use Lingua::FreeLing2::Splitter;
use Data::Dumper;

my $maco = Lingua::FreeLing2::MorphAnalyzer->new("es",
                                                AffixAnalysis => 1,
                                                AffixFile => 'afixos.dat',
                                                MultiwordsDetection => 1,
                                                NumbersDetection => 1,
                                                DatesDetection => 1,
                                                PunctuationDetection => 1,
                                                DictionarySearch => 1,
                                                ProbabilityAssignment => 1,
                                                QuantitiesDetection => 0,
                                                NERecognition => 'NER_BASIC',
                                                PunctuationFile => '../common/punct.dat',
                                                LocutionsFile => 'locucions.dat',
                                                ProbabilityFile => 'probabilitats.dat',
                                                DictionaryFile => 'maco.db',
                                                NPdataFile => 'np.dat',
                                                QuantitiesFile => "",
                                               );

# defined
ok($maco);
isa_ok($maco => 'Lingua::FreeLing2::MorphAnalyzer');
ok(exists($maco->{maco}));
ok(exists($maco->{prefix}));
ok(exists($maco->{maco_options}));
isa_ok($maco->{maco}         => 'Lingua::FreeLing2::Bindings::maco');
isa_ok($maco->{maco_options} => 'Lingua::FreeLing2::Bindings::maco_options');

warning_is
  { ok(!$maco->analyze()) }
  { carped => "Error: analyze argument isn't a list of sentences" };

warning_is
  { ok(!$maco->analyze("")) }
  { carped => "Error: analyze argument isn't a list of sentences" };

warning_is
  { ok(!$maco->analyze("foo")) }
  { carped => "Error: analyze argument isn't a list of sentences" };

warning_is
  { ok(!$maco->analyze(["foo","bar"])) }
  { carped => "Error: analyze argument isn't a list of sentences" };

my $text = <<EOT;
2010 quedará como el año en el que la "economía española escapó", a
duras penas, de la Gran Recesión. Pero también, como el año en el que
la tasa de paro se instaló en el 20%. Además, la última cosecha
estadística de la Encuesta de Población Activa (EPA) certifica lo que
no fue: para dar por acabada la brutal destrucción de empleo que
acompaña a la crisis habrá que esperar. Tras encadenar dos trimestres
con "un leve aumento en la creación de puestos de trabajo", el mercado
laboral volvió, entre octubre y diciembre, a dar su peor cara. En el
trimestre de cierre de 2010, la EPA registró 138.600 personas ocupadas
menos, de las que 16.700 optaron por no seguir buscando trabajo. Las
otras 121.900 personas que perdieron el empleo engrosaron la lista del
paro.
EOT

my $tok = Lingua::FreeLing2::Tokenizer->new('es');
my $spl = Lingua::FreeLing2::Splitter->new('es');

my $tokens = $tok->tokenize($text);
my $sentences = $spl->split($tokens);

isa_ok($sentences->[0] => 'Lingua::FreeLing2::Sentence');
#is($sentences->[0]->is_parsed, 0);

$sentences = $maco->analyze($sentences);

isa_ok($sentences->[0] => 'Lingua::FreeLing2::Sentence');
#is($sentences->[0]->is_parsed, 0);

my $sentence = $sentences->[0];
my $words_have_lemma = 1;
for my $word (@{$sentence->words}) {
    $words_have_lemma = 0 unless $word->lemma;
}

## -- año --

my $random_word = $sentence->words->[4];
is($random_word->form  => "año");
is($random_word->lemma => "año");

my $analysis = $random_word->analysis;
is(scalar(@$analysis) => 1);

isa_ok($analysis => "ARRAY");
isa_ok($analysis->[0] => "Lingua::FreeLing2::Word::Analysis");

is($analysis->[0]->lemma  => "año");
is($analysis->[0]->parole => "NCMS000");
like($analysis->[0]->prob => qr/^\d(?:\.\d+)?$/);

ok(!$analysis->[0]->retokenizable);

## -- quedará -- ##

my $other_word = $sentence->words->[1];
is($other_word->form => "quedará");
$analysis=$other_word->analysis;
is(scalar(@$analysis) => 1);
ok(!$analysis->[0]->retokenizable);
