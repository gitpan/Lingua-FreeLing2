# -*- cperl -*-

use warnings;
use strict;

use Test::More tests => 8;
use Lingua::FreeLing2::Paragraph;
use Lingua::FreeLing2::Sentence;

my $paragraph = Lingua::FreeLing2::Paragraph->new();

ok $paragraph => 'Paragraph is defined';
isa_ok $paragraph => 'Lingua::FreeLing2::Paragraph';
isa_ok $paragraph => 'Lingua::FreeLing2::Bindings::paragraph';
is $paragraph->size => 0, 'Paragraph is empty';

my $sentence = Lingua::FreeLing2::Sentence->new();
$paragraph->push($sentence);
is $paragraph->size => 1, 'Paragraph has one sentence';

my $s = $paragraph->get(0);
isa_ok $s => 'Lingua::FreeLing2::Sentence';

my $ns = Lingua::FreeLing2::Sentence->new();
$paragraph->push($ns);

my @x = $paragraph->sentences();
isa_ok $_ => 'Lingua::FreeLing2::Sentence' for @x;






