#!perl
use strict;
use warnings;
use Test;
BEGIN { plan tests => 1 }

use Lingua::TT::Yanalif; 

ok( cyr2lat("җитсә") eq "citsä" );

exit;