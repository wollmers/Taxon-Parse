package Nomen::Parse::Suffix;

use strict;
use warnings;

use parent qw( Nomen::Parse );
use Nomen::Rank::Suffix;

sub init {
  my $self = shift;

  my $p = $self->{pattern_parts};
  
  my $suffix = Nomen::Rank::Suffix->new();
  $self->{patterns} = $suffix->patterns();   
}

1;
