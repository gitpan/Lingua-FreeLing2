# -*- cperl -*-

use warnings;
use strict;

use Test::More tests => 37;
use Lingua::FreeLing2::Tokenizer;

my $es_tok = Lingua::FreeLing2::Tokenizer->new("es");

# defined
ok($es_tok);

# is a L::FL::Tokenizer
isa_ok($es_tok => 'Lingua::FreeLing2::Tokenizer');

# the tokenizer is of the right class
isa_ok($es_tok => 'Lingua::FreeLing2::Bindings::tokenizer');

# ok, the object can tokenize?
can_ok($es_tok => 'tokenize');

# tokenize of undef/empty string is undef
ok(!$es_tok->tokenize());
ok(!$es_tok->tokenize(""));

my $words = $es_tok->tokenize("Los sindicatos logran que la reforma de las pensiones acordada hoy con el Gobierno tenga en cuenta la debilidad de dos colectivos clave: mujeres y jóvenes");

is(scalar(@$words) => 27);
for my $word (@$words) {
    isa_ok($word => 'Lingua::FreeLing2::Word');
}

my @real_words = map { $_->form } @$words;

is_deeply(\@real_words, [qw"Los sindicatos logran que la reforma de las pensiones acordada hoy con el Gobierno tenga en cuenta la debilidad de dos colectivos clave : mujeres y jóvenes"]);

my $real_words = $es_tok->tokenize("Los sindicatos logran que la reforma de las pensiones acordada hoy con el Gobierno tenga en cuenta la debilidad de dos colectivos clave: mujeres y jóvenes",
                                   to_text => 1);
is(scalar(@$real_words) => 27);
is_deeply($real_words, [qw"Los sindicatos logran que la reforma de las pensiones acordada hoy con el Gobierno tenga en cuenta la debilidad de dos colectivos clave : mujeres y jóvenes"]);


