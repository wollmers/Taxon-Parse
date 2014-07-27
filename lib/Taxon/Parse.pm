package Taxon::Parse;

use strict;
use warnings;

sub new {
  my $class = shift;
  my $self = {
      patterns => {},
      pattern_parts => {},
  };
  bless $self,$class;
  $self->init();
  return $self;
}

sub pattern {
  my $self = shift;
  my $pattern = shift;
  return $self->{patterns}->{$pattern} if exists $self->{patterns}->{$pattern};
}

sub pattern_parts {
  my $self = shift;
  my $pattern = shift;
  return $self->{pattern_parts}->{$pattern} if exists $self->{pattern_parts}->{$pattern};
}

sub patterns {
  my $self = shift;
  return $self->{patterns};
}

sub order {
  my $self = shift;
  my $pattern = shift;
  return $self->{order}->{$pattern} if exists $self->{order}->{$pattern};
}

sub match {
  my $self = shift;
  my $pattern = shift;
  my $string = shift;
  
  my $regex = $self->pattern($pattern);
  return $string =~ m/$regex/;
}

sub match_parts {
  my $self = shift;
  my $pattern = shift;
  my $string = shift;
  
  my $regex = $self->pattern_parts($pattern);
  return $string =~ m/$regex/;
}

sub check_parts {
  my $self = shift;
  my $pattern = shift;
  my $string = shift;
  
  my $regex = $self->pattern_parts($pattern);
  return $string =~ m/^$regex$/;
}


sub check {
  my $self = shift;
  my $pattern = shift;
  my $string = shift;
  
  my $regex = $self->pattern($pattern);
  return $string =~ m/^$regex$/;
}

sub pick {
  my $self = shift;
  my $pattern = shift;
  my $string = shift;
  
  my $regex = $self->pattern($pattern);
  my @result = $string =~ m/($regex)/g;
  return @result;
}

sub ast {
  my $self = shift;
  my $pattern = shift;
  my $string = shift;
  
  my $regex = $self->pattern($pattern);
  my $order = $self->order($pattern);
  my $result = [];
  {
     if ($string =~ m/^$regex$/) {
       for my $key (@$order) {
         push @$result,[ $key, $+{$key} ] if ($+{$key});
       }
     };
  }
  return $result;
}

sub init {
  my $self = shift;

  my $p = $self->{patterns};

  $p->{apostrophe} = qr/[\'´`]/xms;
  $p->{compound_connector} = qr/[-]/xms;

}


1;
