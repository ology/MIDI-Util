#!/usr/bin/env perl
use strict;
use warnings;

use Test::More;

use_ok 'MIDI::Util';

my $score = MIDI::Util::setup_score();
isa_ok $score, 'MIDI::Simple', 'score';

is $score->Tempo, 96, 'Tempo';
is $score->Volume, 120, 'Volume';
is $score->Channel, 0, 'Channel';
is $score->Octave, 4, 'Octave';

MIDI::Util::set_chan_patch( $score, 1, 1 );
is $score->Channel, 1, 'Channel';

done_testing();
