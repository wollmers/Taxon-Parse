package Taxon::Parse::Author;

use strict;
use warnings;

use parent qw( Taxon::Parse );

our $VERSION = 0.004;

sub init {
  my $self = shift;

  my $p = $self->{pattern_parts};

  # a_ - patterns for author names
  $p->{apostrophe} = qr/[\'´`\x{2019}]/xms;
  $p->{compound_connector} = qr/[-]/xms;
  $p->{prefix} = qr/
    (?:
      [vV](?:an)(?:[ -](?:den|der))?
      |[vV]on (?:[ -](?:den|der|dem))?
      |v\.?
      |[vV]\.?\s*d\.?\s*
      |(?:del|[Dd]es|De|de|di|Di|da|du|N)[`' _]?
      |le 
      |[Dd] $p->{apostrophe}
      |[Dd]e (?:[ ][lL]a)? 
      |Mac
      |Mc
      |Le
      |St\.?
      |Ou
      |O'
      |'t
    )
  /xms;
  $p->{suffix} = qr/
    (?:
      (?:
        f|fil|j|jr|jun|junior|sr|sen|senior|ms
      )
      \.?
    )
  /xms;
  $p->{team_connector} = qr/
    (?:
      &|et|and|und|,|;
    )
  /xms;
  $p->{reference_relation} = qr/
    (?:
      ex\.?|in
    )
  /xms;  
  $p->{word}     = qr/
    [\p{IsUpper}\'][\p{IsLower}\'´`]+
  /xms;
  $p->{compound} = qr/
    $p->{word}
    $p->{compound_connector}
    $p->{word}
  /xms;
  $p->{initial} = qr/
    \b[\p{IsUpper}\'´`][\p{IsLower}]{0,2}[\.]    
  /xms;
  $p->{abbreviation}   = qr/
    (?:
      (?:
        $p->{prefix}\s*
      )? 
      (?:
        (?:
          [\p{IsUpper}\'´`][\p{IsLower}]{0,9}[\.]?
        )(?:
          [-]
          [\p{IsUpper}\'´`][\p{IsLower}]{0,9}[\.]?
        )?
      )
      | \b DC[\.]
    )
  /xms;
  $p->{abbreviated_name} = qr/
    (?: 
      $p->{abbreviation}
    )(?:
      \s*(?:
        $p->{abbreviation}
        |$p->{compound}
        |$p->{word}
      )
    )*
    (?:
        \s*
        $p->{suffix}
    )?  
  /xms;
  $p->{name}     = qr/
    (?:
      (?:
        $p->{prefix}\s*
      )? 
      (?:
        $p->{compound}
        |$p->{word}
      )
      (?:
        \s*$p->{suffix}
      )? 
    )(?:
      \s*
      (?:
        $p->{prefix}\s*
      )? 
      (?:
        $p->{compound}
        |$p->{word}
      )
      (?:
        \s*$p->{suffix}
      )?
    )*
  /xms;
  $p->{'list'}   = qr/
    (?:
      $p->{name}
      |$p->{abbreviated_name}
    )
    (?:
      \s*[,]\s*
      (?:
      $p->{name}
      |$p->{abbreviated_name}
      )
    )*
    (?:
      \s+(?:
        $p->{'team_connector'}
      )
      \s+(?:
        al\.?
        |$p->{name}
        |$p->{abbreviated_name}
      )
    )*
  /xms;
  $p->{year}   = qr/
    (?:
      1[5-9]\d\d  # 1500 .. 1999
      |
      20\d\d      # 2000 .. 2099
    )
    (?:[a-hA-H])?
    (?:
      [\/-]
      \d{2,4}
    )?
  /xms;
  $p->{date} = qr/
    (?:
      [\(\[]\s*
      $p->{year}
      \s*[\)\]]
    )
    |$p->{year}
  /xms;
  $p->{phrase} = qr/
    (?:
      $p->{list}
      |$p->{name}
      |$p->{abbreviated_name}
    )(?:
      [\s,]*
      $p->{date}
    )?
  /xms;
  $p->{plain}  = qr/
    $p->{phrase}
    (?:
      \s*\b
      $p->{reference_relation}\s+
      $p->{phrase}
    )?
  /xms;  
  $p->{bracketed}  = qr/
    [\(\[]\s*
    $p->{plain}
    \s*[\)\]]
  /xms;
  $p->{full}   = qr/
    (?:
      $p->{bracketed}\s*
    )?
    (?:
      $p->{reference_relation}\s+
    )?
    (?:
      \s*
      $p->{plain}
    )?
    (?:
      \s*
      $p->{date}
    )?
    (?:
      \s*\,?\s*
      \(? \s*
      (?:
        p \.? \s* p \.?
        | non .*
        | nec .*
        | nom\. \s* illeg\.
        | nom\. \s* inval\.?
        | nom\. \s* nud\.?
      )
      \s* \)?
    )?
    [.,;\s]*
  /xms;

  $p->{authorcaptured}   = qr/
    (?<basionymauthor>
      $p->{bracketed}\s*
    )?
    (?<reference_relation>
      $p->{reference_relation}\s+
    )?
    (?<author>
      \s*
      $p->{plain}
    )?
    (?<date>
      \s*
      $p->{date}
    )?
    (?<non>
      \s*\,?\s*
      \(? \s*
      (?:
        p \.? \s* p \.?
        | non .*
        | nec .*
        | nom\. \s* illeg\.
        | nom\. \s* inval\.?
        | nom\. \s* nud\.?
      )
      \s* \)?
    )?
    [.,;\s]*
  /xms;

  
  my $patterns = $self->{patterns};
  my @patterns = qw< full abbreviated_name authorcaptured>;
  map { $patterns->{$_} = $p->{$_} } @patterns;
  $self->{order}->{authorcaptured} = [qw< basionymauthor reference_relation author date non>];  
}


1;
