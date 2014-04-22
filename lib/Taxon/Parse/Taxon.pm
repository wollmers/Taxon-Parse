package Taxon::Parse::Taxon;

use strict;
use warnings;
use utf8;

use parent qw( Taxon::Parse );

sub init {
  my $self = shift;

  my $p = $self->{pattern_parts};

  # l_ - patterns for latin names
  $p->{apostrophe} = qr/[\'´`]/xms;
  $p->{compound_connector} = qr/[-]/xms;
  
  $p->{word}     = qr/
    \b
    [\p{Latin}]+
    \b
  /xms;
  $p->{compound} = qr/
    $p->{word}
    [-]
    $p->{word}
  /xms;
  $p->{group}    = qr/
    \b
    [A-Z][a-z]+
    \b
  /xms;
  $p->{epithet}  = qr/
    [a-z]+
    (?:
      [-]?
      [a-z]+
    )?
  /xms;
  $p->{abbrev}   = qr/
    [\p{Latin}]{1,2}
    [\.]
  /xms;
  $p->{bracketed}    = qr/
    [(\[]
    \s*
    $p->{group}
    \s*
    [)\]]
  /xms;
  $p->{infragenus}  = qr/
    (?:
      $p->{bracketed}
      | ser \. \s* $p->{group}
    )
  /xms;
  
  $p->{genus}    = qr/
    $p->{group}
    (?:
      \s*
      $p->{infragenus}
    )?
  /xms;
  $p->{species}  = qr/
    $p->{genus}
    \s+
    $p->{epithet}
  /xms;
  $p->{species_marker} = qr/
    (?:(?:
      subsp
      |ssp
      |var
      |v
      |subvar
      |subv
      |sv
      |forma
      |form
      |fo
      |f
      |subform
      |subf
      |sf
      |cv
      |hort
      |m
      |morph
      |nat
      |ab
      |aberration
      |agg
      |[xX×]
    )\.?)            
  /xms;
  $p->{sensu} = qr/
    (?:
      (?:
        (?:s\.|sensu\b)\s*
        (?:l\.|str\.|latu\b|strictu?\b)
      )
      |
      (?:
        (?: 
          sec\.?
          |sensu
          |[aA]uct\.?(?: \s* \b non)? 
          |non
        )
      )
    )            
  /xms;
  $p->{list}     = qr/
    $p->{group}
    \s*
    (?:
      [,]\s*
      $p->{group}
    )+
  /xms;
  $p->{name}     = qr/
    $p->{genus}
      (?:
        (?:
          \s+
          $p->{species_marker}
        )?
        \s+
        $p->{epithet}
      )*
      (?:
        \s+
        $p->{sensu}
      )?
  /xms;

  
  my $patterns = $self->{patterns};
  my @patterns = qw< name group genus species list epithet >;
  map { $patterns->{$_} = $p->{$_} } @patterns;
  $self->{scores} = $self->scores();  
}

sub scores {
  my $self = shift;
  
  return {
    group => 0.5,
    species => 1,
    list => 0.75,
    epithet => 0.5,
  };
}

1;
