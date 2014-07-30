package Taxon::Parse::Suffix;

use strict;
use warnings;

use parent qw( Taxon::Parse );

our $VERSION = 0.001;

# TODO

=comment

use Taxon::Rank::Suffix;

sub init {
  my $self = shift;

  my $p = $self->{pattern_parts};
  
  my $suffix = Taxon::Rank::Suffix->new();
  $self->{patterns} = $suffix->patterns();   
}

=cut

1;
