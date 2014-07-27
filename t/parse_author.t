#!perl
use strict;
use warnings;
use utf8;

use lib qw(../lib/);

use Test::More;
use Data::Dumper;

binmode(STDOUT, ':utf8');
binmode(STDERR, ':utf8');


my $class = 'Taxon::Parse::Author';

use_ok($class);

can_ok($class,
  qw/
    new
    init
    pattern
    patterns
    match
    pick
    check
  /); 

my $object = new_ok($class);

ok($object->patterns(),'patterns');

=comment

ok($object->pattern_parts('apostrophe'),'pattern(apostrophe)');
ok($object->pattern_parts('compound_connector'),'pattern(compound_connector)');
ok($object->pattern_parts('word'),'pattern(word)');
ok($object->pattern_parts('compound'),'pattern(compound)');
ok($object->pattern_parts('abbreviation'),'pattern(abbreviation)');
ok($object->pattern_parts('name'),'pattern(name)');
ok($object->pattern_parts('list'),'pattern(list)');
ok($object->pattern_parts('year'),'pattern(year)');
ok($object->pattern_parts('phrase'),'pattern(phrase)');
ok($object->pattern_parts('bracketed'),'pattern(bracketed)');


ok($object->pattern('full'),'pattern(full)');
ok($object->pattern('abbreviated_name'),'pattern(abbreviated_name)');


### prefix

my $prefixes = [ split('\n',<<ITEMS) ];
van
Van
van den
van-den
van der
van-der
von
Von
von den
von-den
von der
von-der
von dem
von-dem
Von den
Von-den
Von der
Von-der
Von dem
Von-dem
del
Des
De
de
di
Di
da
N
del`
Des`
De`
de`
di`
Di`
da`
N`
del'
Des'
De'
de'
di'
Di'
da'
N'
le
d'
D'
de
de la
de La
Mac
Mc
Le
St
St.
Ou
O'
't
ITEMS

for my $name (@$prefixes) {
  ok($object->check_parts('prefix',$name), "check prefix $name"); 
}


my $suffixes = [ split('\n',<<ITEMS) ];
f
fil
j
jr
jun
junior
sr
sen
senior
ms
f.
fil.
j.
jr.
jun.
junior.
sr.
sen.
senior.
ms.
ITEMS

for my $name (@$suffixes) {
  ok($object->check_parts('suffix',$name), "check suffix $name"); 
}

### team_connector
my $team_connectors = [
  qw/
	ex
	ex.
	&
	et
	in
  /,
	',',
	';',
];


for my $name (@$team_connectors) {
  ok($object->check_parts('team_connector',$name), "check team_connector $name"); 
}


### word
ok($object->match_parts('word','Mann'), 'match word Mann');
ok($object->match_parts('word',"D'Mann"), "match word D'Mann");
ok($object->match_parts('word',"'Mann"), "match word 'Mann");
ok($object->match_parts('word',"Mann'"), "match word Mann'");
ok($object->match_parts('word',' Mann '), 'match word Mann embedded');
ok($object->match_parts('word',' Mann'), 'match word Mann embedded');
ok($object->match_parts('word','Mann '), 'match word Mann embedded');

ok(!$object->match_parts('word','und'), 'not match word und');
ok(!$object->match_parts('word','MANN'), 'not match word MANN');
ok(!$object->match_parts('word','mann'), 'not match word mann');
ok(!$object->match_parts('word','M'), 'not match word M');
ok(!$object->match_parts('word','mA'), 'not match word mA');
ok(!$object->match_parts('word','Tiger6'), 'not match word Tiger6');
ok(!$object->match_parts('word','und'), 'not match word und');

### compound
ok($object->match_parts('compound','Mann-Frau'), 'match compound Mann-Frau');
ok($object->match_parts('compound',"D'Mann-Frau"), "match compound D'Mann-Frau");
ok($object->match_parts('compound',"'Mann-Frau"), "match compound 'Mann-Frau");
ok($object->match_parts('compound',"Mann-Frau'"), "match compound Mann-Frau'");

ok(!$object->match_parts('compound',"Mann -Frau"), "not match compound Mann -Frau");
ok(!$object->match_parts('compound',"Mann- Frau"), "not match compound Mann- Frau");
ok(!$object->match_parts('compound',"Mann- Frau'"), "not match compound Mann- Frau'");

### abbreviation
ok($object->match_parts('abbreviation','M.'), 'match abbreviation M.');
ok($object->match_parts('abbreviation','Mu.'), 'match abbreviation Mu.');
ok($object->match_parts('abbreviation','Mannhard.'), 'match abbreviation Mannhard.');

ok(!$object->match_parts('abbreviation','Mannhardt.'), 'not match abbreviation Mannhardt.');
ok(!$object->match_parts('abbreviation','al.'), 'not match abbreviation al.');
ok(!$object->match_parts('abbreviation','ex'), 'not match abbreviation ex');

### name
ok($object->match_parts('name','Mann'), 'match name Mann');
ok($object->match_parts('name','Mann-Frau'), 'match name Mann-Frau');
ok(!$object->match_parts('name','M.'), 'NOT match name M.');
ok($object->match_parts('name','Mann Mann'), 'match name Mann Mann');
ok($object->match_parts('name','Mann Mann-Frau'), 'match name Mann Mann-Frau');
ok($object->match_parts('name',' Mann-Frau Mann'), 'match name  Mann-Frau Mann');
ok($object->match_parts('name','M. Mann Mann-Frau'), 'match name M. Mann Mann-Frau');
ok($object->match_parts('name',' Mann-Frau M. Mann'), 'match name  Mann-Frau M. Mann');
ok($object->match_parts('name','Mann, Mann-Frau'), 'match name Mann, Mann-Frau');

### list TODO
ok($object->match_parts('list','Mann, Mann-Frau'), 'match list Mann, Mann-Frau');

### year
ok($object->match_parts('year','1500'), 'match year 1500');
ok($object->match_parts('year','1999'), 'match year 1999');
ok($object->match_parts('year','2000'), 'match year 2000');
ok($object->match_parts('year','2099'), 'match year 2099');

### phrase
ok($object->match_parts('phrase','Mann'), 'match phrase Mann');
ok($object->match_parts('phrase','Mann, Mann-Frau'), 'match phrase Mann, Mann-Frau');
ok($object->match_parts('phrase','Mann 1999'), 'match phrase Mann 1999');
ok($object->match_parts('phrase','Mann, Mann-Frau 1999'), 'match phrase Mann, Mann-Frau 1999');

### bracketed
ok($object->match_parts('bracketed','(Mann)'), 'match bracketed (Mann)');
ok($object->match_parts('bracketed','(Mann, Mann-Frau)'), 'match bracketed (Mann, Mann-Frau)');
ok($object->match_parts('bracketed','(Mann 1999)'), 'match bracketed (Mann 1999)');
ok($object->match_parts('bracketed','(Mann, Mann-Frau 1999)'), 'match bracketed (Mann, Mann-Frau 1999)');

### full
ok($object->match_parts('full','(Mann) Mann'), 'match full (Mann) Mann');
ok($object->match_parts('full','(Mann, Mann-Frau) Mann, Mann-Frau'), 'match full (Mann, Mann-Frau) Mann, Mann-Frau');
ok($object->match_parts('full','(Mann 1999) Mann 1999'), 'match full (Mann 1999) Mann 1999');
ok($object->match_parts('full','(Mann, Mann-Frau 1999) Mann, Mann-Frau 1999'), 'match full (Mann, Mann-Frau 1999) Mann, Mann-Frau 1999');
ok($object->match_parts('full','R. Br.'), 'match full R. Br.');
ok($object->match_parts('full','R. Br.'), 'match full R.Br.');

=cut

my $examples =[
'Page, 1983',
'Günther',
'Günther, 1862',
'U. Braun & Crous 2003',
'(L.) Desf.',
'(Günther, 1862)',
'Clayton, Price & Johnson 2006',
'Bibron 1855',
'(Lipsky) Greuter & Burdet',
'(Lipsky) Greuter & Burdet',
'(Fr. Duby) ex Oudem. 1897',
'Clayton, Price & Page 1996',
'Speg. 1910',
'Speg. 1910',
'Drew & Hancock 1999',
'(Huang & Li 1985)',
'Stimson 1907',
'(Marshall et al. 1985) Goodwin et al. 1989',
'van Drimmelen 1953',
'(Frankland and Frankland 1889) Chester 1897',
'(Rchb. f.) Schltr.',
'(Rchb.f.) Schltr.',

'(Hook.f. & Thomson ex Müll.Arg.) Kuntze',
'(Wall. ex Hook.) Ching',
'Barnes & McDunnough 1912',
'(Ker Gawl.) Morong',
'Demange & Silva G. F. 1971',
'P Fischer 1883',
'McCook, 1894',
'Wood, 1978a',
'Buch.-Ham.',
'Willd. (1806)',
'v. Hass.',
'(Gord.) Lindl.ex Hildebr.',
'V. d. L.',
'(Cass. ex Gaud.) (1825)',
'Duhamel du Monceau, 1755',
'(L.) Gueldenst. ex Ledeb.',
'(non Hombron & Jacquinot, 1853)',
'(Jordan et Evermann) (1902)',
'(L.) (1826)',
'Hoffmanns.',
', non (Willd.)DC.',
'Hook.(1837) , non Hook.(1841)',
];

my $todo = [
'MANTHEY & GROSSMANN 1997: 179',
'Clayton, Price&Page 1996',
'WILMS & BÖHME 2001',
'Straneo,',
'J. Agardh, nom. illeg.',
];

for my $name (@$examples) {
  ok($object->match_parts('full',$name), "match full $name"); 
}

for my $name (@$examples) {
  ok($object->check('full',$name), "check full $name"); 
}

for my $name (@$examples) {
  ok($object->check('authorcaptured',$name), "check captured $name"); 
}


done_testing();
