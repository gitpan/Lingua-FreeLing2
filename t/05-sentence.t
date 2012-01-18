# -*- cperl -*-

use warnings;
use strict;

use Test::More tests => 1;
use Lingua::FreeLing2::Sentence;

my $sentence = Lingua::FreeLing2::Sentence->new();

ok($sentence);
