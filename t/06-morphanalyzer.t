# -*- cperl -*-

use warnings;
use strict;

use Test::More tests => 35;
use Test::Warn;
use Lingua::FreeLing2::MorphAnalyzer;
use Lingua::FreeLing2::Tokenizer;
use Lingua::FreeLing2::Splitter;
use Data::Dumper;

my %options = (
               AffixAnalysis         => 1,
               AffixFile             => 'afixos.dat',
               MultiwordsDetection   => 1,
               NumbersDetection      => 1,
               DatesDetection        => 1,
               PunctuationDetection  => 1,
               DictionarySearch      => 1,
               ProbabilityAssignment => 1,
               QuantitiesDetection   => 0,
               NERecognition         => 'NER_BASIC',
               PunctuationFile       => '../common/punct.dat',
               LocutionsFile         => 'locucions.dat',
               ProbabilityFile       => 'probabilitats.dat',
               DictionaryFile        => 'maco.db',
               NPdataFile            => 'np.dat',
               QuantitiesFile        => "",
              );


my $maco = Lingua::FreeLing2::MorphAnalyzer->new("es", %options);

# defined
ok     $maco => 'We have a morphological analyzer';
isa_ok $maco => 'Lingua::FreeLing2::MorphAnalyzer';

ok exists($maco->{maco})         => 'Object has "maco" field';
ok exists($maco->{prefix})       => 'Object has "prefix" field';
ok exists($maco->{maco_options}) => 'Object has "maco_options" field';

isa_ok $maco->{maco}         => 'Lingua::FreeLing2::Bindings::maco';
isa_ok $maco->{maco_options} => 'Lingua::FreeLing2::Bindings::maco_options';

warning_is
  { ok !$maco->analyze() => "Can't analyze nothing" }
  { carped => "Error: analyze argument should be a list of sentences" },
  "Warning is issued";

warning_is
  { ok !$maco->analyze("") => "Can't analyze empty string" }
  { carped => "Error: analyze argument should be a list of sentences" },
  "Warning is issued";

warning_is
  { ok !$maco->analyze("foo") => "Can't analyze a string" }
  { carped => "Error: analyze argument should be a list of sentences" },
  "Warning is issued";

warning_is
  { ok !$maco->analyze(["foo","bar"])  => "Can't analyze a list of strings" }
  { carped => "Error: analyze argument should be a list of sentences" },
  "Warning is issued";

my $text = <<EOT;
2010 quedar� como el a�o en el que la "econom�a espa�ola escap�", a
duras penas, de la QHFdjhfdfsD. Pero tambi�n, como el a�o en el que
la tasa de paro se instal� en el 20%. Adem�s, la �ltima cosecha
estad�stica de la Encuesta de Poblaci�n Activa (EPA) certifica lo que
no fue: para dar por acabada la brutal destrucci�n de empleo que
acompa�a a la crisis habr� que esperar. Tras encadenar dos trimestres
con "un leve aumento en la creaci�n de puestos de trabajo", el mercado
laboral volvi�, entre octubre y diciembre, a dar su peor cara. En el
trimestre de cierre de 2010, la EPA registr� 138.600 personas ocupadas
menos, de las que 16.700 optaron por no seguir buscando trabajo. Las
otras 121.900 personas que perdieron el empleo engrosaron la lista del
paro.
EOT

my $tok = Lingua::FreeLing2::Tokenizer->new('es');
my $spl = Lingua::FreeLing2::Splitter->new('es');

my $tokens = $tok->tokenize($text);
my $sentences = $spl->split($tokens);
isa_ok $sentences->[0] => 'Lingua::FreeLing2::Sentence';

$sentences = $maco->analyze($sentences);
isa_ok $sentences->[0] => 'Lingua::FreeLing2::Sentence';

my $sentence = $sentences->[0];
my $words_have_lemma = 1;
for my $word ($sentence->words) {
    $words_have_lemma = 0 unless $word->lemma;
}
ok $words_have_lemma => 'All analyzed words have a lemma';

## -- a�o --

my $random_word = ($sentence->words)[4];
is $random_word->form  => "a�o", 'fifth word is "a�o"';
is $random_word->lemma => "a�o", 'fifth word lemma is also "a�o"';

my $analysis = $random_word->analysis;
is scalar(@$analysis) => 1, "'a�o' has just one analysis";

isa_ok $analysis => "ARRAY", "analysis";
isa_ok $analysis->[0] => "Lingua::FreeLing2::Word::Analysis", "Each analysis";

is $analysis->[0]->lemma  => "a�o", 'analysis lemma is "a�o"';
is $analysis->[0]->parole => "NCMS000", 'POS';
like $analysis->[0]->prob => qr/^\d(?:\.\d+)?$/, "probability is a number";

ok !$analysis->[0]->retokenizable, "This analysis is not retokenizable";

## -- el -- ##

my $other_word = ($sentence->words)[7];
is $other_word->form => "que", "Seventh word is 'que'";
#XXX - ok $other_word->in_dict;
$analysis = $other_word->analysis;
is scalar(@$analysis) => 2, "'que' has two possible analysis";

for my $a (@$analysis) {
    isa_ok $a => 'Lingua::FreeLing2::Word::Analysis', "Each analysis";
    is $a->lemma, "que", "both lemma are 'que'";
}
isnt $analysis->[0]->parole, $analysis->[1]->parole, "POS differ for the two analysis";

## -- QHFdjhfdfsD -- ##
my $nonword = ($sentence->words)[19];
is $nonword->form => "QHFdjhfdfsD", "twentieth word is 'QHFdjhfdfsD'";
#XXX - ok $nonword->in_dict;
