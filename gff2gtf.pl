##!/usr/bin/perl
# downloaded from http://seqanswers.com/forums/showpost.php?p=55022&postcount=4

use strict;
use warnings;
use Data::Dumper;

use File::Basename;
use Bio::FeatureIO;

my $inFile = shift;
my ($name, $path, $suffix) = fileparse($inFile, qr/\.gff/);
my $outFile = $path . $name . ".gtf";

my $inGFF = Bio::FeatureIO->new( '-file' => "$inFile",
	'-format' => 'GFF',
	'-version' => 3 );
my $outGTF = Bio::FeatureIO->new( '-file' => ">$outFile",
	'-format' => 'GFF',
	'-version' => 2.5);

while (my $feature = $inGFF->next_feature() ) {

$outGTF->write_feature($feature);

}
