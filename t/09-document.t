# -*- cperl -*-

use warnings;
use strict;

use Test::More tests => 3;
use Lingua::FreeLing2::Document;

my $doc = Lingua::FreeLing2::Document->new();

ok     $doc => 'Document is defined';
isa_ok $doc => 'Lingua::FreeLing2::Document';
isa_ok $doc => 'Lingua::FreeLing2::Bindings::document';
