#!perl
use utf8;

use lib qw(../lib/);

use Test::More;
use Data::Dumper;

my $class = 'Taxon::Parse::Taxon';

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

ok($object->pattern('epithet'),'pattern(epithet)');

### epithet
ok($object->match('word','mann'), 'match word mann');
ok($object->match('word','Mann'), 'match word Mann');

ok($object->check('epithet','mann'), 'check word mann');
ok($object->check('group','Mann'), 'check word Mann');
#ok($object->check('genus','Mann-Frau'), 'check compound Mann-Frau');

ok($object->check('species','Viola mann-frau'), 'check species Viola mann-frau');

my $names = [
'Pinnotheres atrinicola',
        
'Pseudocercospora dendrobii',
'Polypogon monspeliensis',
'Demansia torquata',
        
'Dennyus (Collodennyus) bartoni',
        
'Sténométope laevissimus',
        
'Fagus sylvatica subsp. orientalis',
'Fagus sylvatica',
        
'Mycosphaerella eryngii',
        
'Dennyus (Collodennyus) distinctus timjonesi',
        
'Pseudocercospora',
        
'Gonocephalus borneensis',
'Dennyus (Collodennyus) distinctus timjonesi',
        
'Gonocephalus abbotti',
        
'Uromastyx alfredschmidti',
        
'Pseudocercospora',
        
'Bactrocera (Hemizeugodacus) ektoalangiae',
        
        
'Coptotermes (Polycrinitermes) chaoxianensis',
        
'Helicobacter pylori',
'Pseudomonas fluorescens',

'Abelia × grandiflora',
'Abies X shastensis',
'Abies x shastensis',
'Amaranthus ×tucsonensis',


'Abies ser. Amabiles',
'Abeona ? serrata',
'Aboilus? amplus',

'Steinernema cf. glaseri',
'Amanita aff. volvata',
'Amalia? mediterranea',

];

my $names_todo = [
'Anodonthyla sp. ZSM 673/2003',
        
'"Spirochaeta interrogans"',
'not "Brucella ovis"',
'"Bacterium aquatilis"',

'alpha proteobacterium endosymbiont of Paracatenula sp.',
'Plocamium sp. 2telfairiae BOLD:AAO5906',
'Influenza A virus (A/common teal/California/11285/2008(mixed))',
'Lactobacillus delbrueckii subsp. bulgaricus CNCM I-1519',

'Arthopyrenia hyalospora X Hydnellum scrobiculatum',

'Amara (C.) cylindrica',

'Analtes (?) tripunctalis',
'Ancilla (Eburna)glabrata speciosa',
'Ancistrocerus trimarginatus auct. auct. (null)',
'Ancyloceras (Audouliceras?) fallauxi',
'Andrena (Mel.) vicina',
'Andropogon subg. Cymbopogon',
'Anemone sp. cult.',
'Angraecum sect. Acaulia',
'Anisosticta 19-punctata',

'Anodonta herculeus "Gerstford"',
];

my $taxons = [
'Pinnotheres atrinicola Page, 1983',

'Pinnotheres atrinicola Page, 1983',
        
'Pseudocercospora dendrobii U. Braun & Crous 2003',
'Polypogon monspeliensis (L.) Desf.',
'Demansia torquata (Günther, 1862)',
        
'Dennyus (Collodennyus) bartoni Clayton, Price & Johnson 2006',
        
'Sténométope laevissimus Bibron 1855',
        
'Fagus sylvatica subsp. orientalis (Lipsky) Greuter & Burdet',
'Fagus sylvatica (Lipsky) Greuter & Burdet',
        
'Mycosphaerella eryngii (Fr. Duby) ex Oudem. 1897',
        
'Dennyus (Collodennyus) distinctus timjonesi Clayton, Price & Page 1996',
        
'Pseudocercospora Speg. 1910',
        
'Gonocephalus borneensis — MANTHEY & GROSSMANN 1997: 179',
'Dennyus (Collodennyus) distinctus timjonesi Clayton, Price&Page 1996',
        
'Gonocephalus abbotti',
        
'Uromastyx alfredschmidti WILMS & BÖHME 2001',
'Uromastyx alfredschmidti',
        
'Pseudocercospora Speg. 1910',
        
'Bactrocera (Hemizeugodacus) ektoalangiae Drew & Hancock 1999',
        
'Steinernema cf. glaseri Konza IVAB-71',
'Arthopyrenia hyalospora X Hydnellum scrobiculatum',
        
'Coptotermes (Polycrinitermes) chaoxianensis (Huang & Li 1985)',
        
'Anodonthyla sp. ZSM 673/2003',
        
'"Spirochaeta interrogans" Stimson 1907',
'Helicobacter pylori (Marshall et al. 1985) Goodwin et al. 1989',
'not "Brucella ovis" van Drimmelen 1953',
'"Bacterium aquatilis" (sic) (Frankland and Frankland 1889) Chester 1897',
'Pseudomonas fluorescens (biotype D)',
'alpha proteobacterium endosymbiont of Paracatenula sp.',
'Plocamium sp. 2telfairiae BOLD:AAO5906',
'Influenza A virus (A/common teal/California/11285/2008(mixed))',
'Lactobacillus delbrueckii subsp. bulgaricus CNCM I-1519',
];

for my $name (@$names) {
  ok($object->match_parts('name',$name), "match full $name"); 
}

for my $name (@$names) {
  ok($object->check('name',$name), "check full $name"); 
}

for my $name (@$names) {
  ok($object->check('namecaptured',$name), "check captured $name"); 
}

for my $name (@$names_todo) {
#  ok($object->check('name',$name), "check captured $name"); 
}


#my $ast = $object->ast('namecaptured','Dennyus (Collodennyus) distinctus timjonesi');
#print STDERR Dumper($ast),"\n";

done_testing();
