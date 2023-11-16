# How to run

Dont change anything, sets up folders

	~/code/svmu_00_setup.sh

copy files

	sbatch ~/code/svmu_01_prep_genomes.sh 664
	# or
	for i in $(echo -e "62\t155\t502\t541\t444\t909\t1034\t1192"); do sbatch ~/code/svmu_01_prep_genomes.sh $i; done
	
Run 28 core nucmer to make big delta file

	sbatch ~/code/svmu_02a_nucmer.sh 664
	# or
	for i in $(echo -e "62\t155\t502\t541\t444\t909\t1034\t1192"); do sbatch ~/code/svmu_02a_nucmer.sh $i; done
	
Run dnadiff to make filter delta to 1-1 and m-m and get SNPs and inversions

	sbatch ~/code/svmu_02c_dnadiff.sh 62
	# or
	for i in $(echo -e "155\t502\t541\t444\t909\t1034\t1192"); do sbatch ~/code/svmu_02c_dnadiff.sh $i; done

Run svmu on the big delta (might need to change to other delta?)

	sbatch ~/code/svmu_03_svmu.sh 62
	# or
	for i in $(echo -e "155\t502\t541\t444\t909\t1034\t1192"); do sbatch ~/code/svmu_03_svmu.sh $i; done
	
# Header info
## coords headers

Paris: SIM STP FRM are missing in nucmer

When run without the -H or -B options, show-coords prints a header tag for each column; the descriptions of each tag follows. 

[S1] start of the alignment region in the reference sequence 
[E1] end of the alignment region in the reference sequence 
[S2] start of the alignment region in the query sequence 
[E2] end of the alignment region in the query sequence 
[LEN 1] length of the alignment region in the reference sequence 
[LEN 2] length of the alignment region in the query sequence 
[% IDY] percent identity of the alignment 
[% SIM] percent similarity of the alignment (as determined by the BLOSUM scoring matrix) 
[% STP] percent of stop codons in the alignment 
[LEN R] length of the reference sequence 
[LEN Q] length of the query sequence 
[COV R] percent alignment coverage in the reference sequence 
[COV Q] percent alignment coverage in the query sequence 
[FRM] reading frame for the reference and query sequence alignments respectively 
[TAGS] the reference and query FastA IDs respectively. 
All output coordinates and lengths are relative to the forward strand of the reference DNA sequence.

search in https://mummer.sourceforge.net/manual/#aligns 

## Snps headers

Paris: CTX R and Q missing in nucmer

[P1] position of the SNP in the reference sequence. For indels, this position refers to the 1-based position of the first character before the indel, e.g. for an indel at the very beginning of a sequence this would report 0. For indels on the reverse strand, this position refers to the forward-strand position of the first character before indel on the reverse-strand, e.g. for an indel at the very end of a reverse complemented sequence this would report 1. 
[SUB] character or gap at this position in the reference 
[SUB] character or gap at this position in the query 
[P2] position of the SNP in the query sequence 
[BUFF] distance from this SNP to the nearest mismatch (end of alignment, indel, SNP, etc) in the same alignment 
[DIST] distance from this SNP to the nearest sequence end 
[R] number of repeat alignments which cover this reference position 
[Q] number of repeat alignments which cover this query position 
[LEN R] length of the reference sequence 
[LEN Q] length of the query sequence 
[CTX R] surrounding reference context 
[CTX Q] surrounding query context 
[FRM] sequence direction (NUCmer) or reading frame (PROmer) 
[TAGS] the reference and query FastA IDs respectively. All positions are relative to the forward strand of the DNA input sequence, while the [BUFF] distance is relative to the sorted sequence.


search in https://mummer.sourceforge.net/manual/


## diff headers

Outputs a list of structural differences for each sequence in the reference and query, sorted by position. For a reference sequence R, and its matching query sequence Q, differences are categorized as 
GAP (gap between two mutually consistent alignments), 
DUP (inserted duplication), 
BRK (other inserted sequence), 
JMP (rearrangement), 
INV (rearrangement with inversion), 
SEQ (rearrangement with another sequence). 

The first five columns of the output are 
seq ID, 
feature type, 
feature start, 
feature end
feature length. 
Additional columns are added depending on the feature type. Negative feature lengths indicate overlapping adjacent alignment blocks.

IDR GAP gap-start gap-end gap-length-R gap-length-Q gap-diff
IDR DUP dup-start dup-end dup-length
IDR BRK gap-start gap-end gap-length
IDR JMP gap-start gap-end gap-length
IDR INV gap-start gap-end gap-length
IDR SEQ gap-start gap-end gap-length prev-sequence next-sequence
Positions always reference the sequence with the given ID. The sum of the fifth column (ignoring negative values) is the total amount of inserted sequence. Summing the fifth column after removing DUP features is total unique inserted sequence. Note that unaligned sequence are not counted, and could represent additional "unique" sequences. See documentation for tips on how to interpret these alignment break features.

https://manpages.debian.org/stretch/mummer/show-diff.1
