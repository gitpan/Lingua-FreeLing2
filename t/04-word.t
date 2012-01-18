# -*- cperl -*-

use warnings;
use strict;

use Test::More tests => 16;
use Lingua::FreeLing2::Word;

my $word1 = Lingua::FreeLing2::Word->new();

ok($word1);
isa_ok($word1 => 'Lingua::FreeLing2::Word');
isa_ok($word1 => 'Lingua::FreeLing2::Bindings::word');

is($word1->form, "");
$word1->form("gato");
is($word1->form, "gato");




my $word2 = Lingua::FreeLing2::Word->new("cavalo");

ok($word2);
isa_ok($word2 => 'Lingua::FreeLing2::Word');
isa_ok($word2 => 'Lingua::FreeLing2::Bindings::word');

is($word2->form, "cavalo");

my $hash = $word2->to_hash;

is($hash->{form}   => "cavalo");
is($hash->{lemma}  => "");
is($hash->{parole} => "");

is($hash->{lemma}  => $word2->lemma);
is($hash->{parole} => $word2->parole);
is($hash->{form}   => $word2->form);

is_deeply($word2->analysis => []);
