package MIDI::Util;

# ABSTRACT: MIDI Utilities

our $VERSION = '0.0100';

use strict;
use warnings;

use MIDI::Simple;
use Music::Tempo;

=head1 SYNOPSIS

  use MIDI::Util;
  my $score = MIDI::Util::setup_midi( bpm => 120, etc => '...', );
  # ...
  MIDI::Util::set_chan_patch( $score, 0, 1 );

=head1 DESCRIPTION

C<MIDI::Util> comprises a couple handy MIDI utilities.

=cut

=head1 FUNCTIONS

=head2 setup_midi()

  $score = MIDI::Util::setup_midi(
    lead_in => 4,
    volume  => 120,
    bpm     => 100,
    channel => 16,
    patch   => 42,
    octave  => 4,
  );

Set basic MIDI parameters and return a MIDI score object.  If given a B<lead_in>,
play a hi-hat for that many beats.

Named parameters and defaults:

  lead_in: 4
  volume:  120
  bpm:     100
  channel: 0
  patch:   0
  octave:  4

=cut

sub setup_midi {
    my %args = (
        lead_in => 4,
        volume  => 120,
        bpm     => 100,
        channel => 0,
        patch   => 0,
        octave  => 4,
        @_,
    );

    my $score = MIDI::Simple->new_score();

    $score->set_tempo( bpm_to_ms($args{bpm}) * 1000 );

    $score->Channel(9);
    $score->n( 'qn', 42 ) for 1 .. $args{lead_in};

    $score->Volume($args{volume});
    $score->Channel($args{channel});
    $score->Octave($args{octave});
    $score->patch_change( $args{channel}, $args{patch} );

    return $score;
}

=head2 set_chan_patch()

  MIDI::Util::set_chan_patch( $score, $channel, $patch );

Set the MIDI channel and patch.

Positional parameters and defaults:

  score:   undef (required)
  channel: 0
  patch:   0

=cut

sub set_chan_patch {
    my ( $score, $channel, $patch ) = @_;
    $channel //= 0;
    $patch   //= 0;
    $score->patch_change( $channel, $patch );
    $score->noop( 'c' . $channel );
}

1;
__END__

=head1 SEE ALSO

L<MIDI::Simple>

L<Music::Tempo>

=cut
