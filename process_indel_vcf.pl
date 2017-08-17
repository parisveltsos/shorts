use strict;    # give advanced error file output

# Make sure there are the correct number of cmdline args
my $usage =
"\nLast update: 2017.07.21\nwww.parisveltsos.com\\research\n\nUsage:\nperl process_indel_vcf.pl input1\n\nThis script heterozygotes for indels, from preformated table made from vcf only containing indels.\n\n";
my $usage_count = 0;
foreach (@ARGV) {
    $usage_count++;
}
if ( $usage_count != 1 ) {
    print $usage;
    exit;
}

# Get the input and ouput file names
$_ = shift for my ( $input_file1);

open( INFILE, $input_file1 ) or die("Can't open input file 1: $! \n");
my @infile_data1 = <INFILE>;
close INFILE;

# Get input headers for using in output
my $header1 = shift(@infile_data1);

my @data = ();
my @comp1 = ();
my @comp2 = (); 
my $count;

print "\nReading input...\n";       
foreach my $line_data1 (@infile_data1) {
#     if ( $line_data1 =~ /^(.+)\t.+\t.+\t.+\t(.+)\tminRead\t(.+)\tposPos\t.+\tPC\t(.+)\t(.+)\t.+\t0\t0\t0\tSanger\t.+\t.+\t.+\t(.+)\t(.+)\t(.+)\t.+\t.+\t.+\t.+\t.+/ )
	if ( $line_data1 =~ /^(.+\t.+\t.+)\t.+\t.+\t.+\t.+\t(.+)\/(.+)/ )
{
        push @data, $1;
    	push @comp1, $2;
    	push @comp2, $3;
# 		print "\n@comp1[$count] ";
		$count++;
	}
}

my @kept = ();
my $count;

foreach my $line_data1(@infile_data1) {
	$count++;
	if ( @comp1[$count] ne @comp2[$count] ) {
		push @kept, $infile_data1[$count];
# 		print "\n@comp1[$count] @comp2[$count]";
	}
}


open( OUTFILE, ">indel_data.txt" )
  or die("Cannot create output file\n");
print( OUTFILE "scaffold\tsize\tchrom\tcm\n" );
my $count;
foreach my $out_line (@kept) {
	$count++;
    print( OUTFILE "@data[$count]\n" );
}
close OUTFILE;   

print "\nDone!\n\nInput file was ".scalar(@infile_data1)." lines, of which ".scalar(@kept)." indels were heterozygous\n\n";

