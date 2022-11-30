#!/bin/bash -l
#SBATCH --job-name=GA2     # Job name
#SBATCH --partition=sixhour,eeb,kelly,kucg # Partition Name (Required) sixhour kelly
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=2Gb                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log   # Standard output and error log

WDIR=/panfs/pfs.local/scratch/kelly/p860v026/compareGenomes
GENE=$1
CONTROL=$2

cd $WDIR

# get gene results ssaa

for LINE in $(echo -e "62\t155\t444\t502\t541\t664\t767\t909\t1034\t1192"); do grep $GENE $LINE.paf > $GENE\_$LINE\_temp.txt; done

# keep interesting columns

grep $GENE $GENE*temp.txt | perl -pe 's/_/\t/ ; s/_temp// ; s/.txt:/\t/ ; s/MgTOL.//' | cut -f 1-14 > $GENE\_temp_out.txt

# check only 1 hit per line (should result in 10)

cut -f 2,8 $GENE\_temp_out.txt | sort | uniq -c | wc -l

# Make control file, separate for positive and negative directions which need to be RT

grep '-' $GENE\_temp_out.txt | cut -f 2,8,10,11 > $GENE\_$CONTROL\_temp_control_negative.txt

grep '+' $GENE\_temp_out.txt | cut -f 2,8,10,11 > $GENE\_$CONTROL\_temp_control_positive.txt

module load R

Rscript ~/code/geneAlignment_03a_makeControlPositive.r $GENE $CONTROL

Rscript ~/code/geneAlignment_03b_makeControlNegative.r $GENE $CONTROL


module load samtools 

module load bedtools 

# get gene gff info from annotation

grep $GENE /panfs/pfs.local/work/kelly/p860v026/genomes/Mgutv5/annotation/MguttatusTOL_551_v5.0.gene_exons.gff3 > $GENE\_temp.gff

# generate coding sequence fasta for alignment

gffread -x $GENE\_cds_temp.fa -g /panfs/pfs.local/work/kelly/p860v026/genomes/Mgutv5/assembly/MguttatusTOL_551_v5.0.fa $GENE\_temp.gff

# rename to simplify gene name
perl -pe 's/MgTOL/CDS/' $GENE\_cds_temp.fa > $GENE\_cds_temp2.fa

# generate mRNA, including UTR, fasta for alignment

gffread -w $GENE\_exontogether_temp.fa -g /panfs/pfs.local/work/kelly/p860v026/genomes/Mgutv5/assembly/MguttatusTOL_551_v5.0.fa $GENE\_temp.gff

# generate gene fasta, includes introns, for alignment. This is the "reference genome"

samtools faidx /panfs/pfs.local/work/kelly/p860v026/genomes/Mgutv5/assembly/MguttatusTOL_551_v5.0.fa $(grep $GENE /panfs/pfs.local/work/kelly/p860v026/genomes/Mgutv5/annotation/MguttatusTOL_551_v5.0.gene_exons.gff3 | grep gene | cut -f 1,4,5 | sed 's/\t/:/ ; s/\t/-/') > v5_$GENE\_temp.fa

samtools faidx v5_$GENE\_temp.fa

# generate gene sequence from IM assemblies, separately for  +ve and -ve which are RT

cat $GENE\_$CONTROL\_temp_control_positive2.txt | grep -v line | while read LINE CHR MIN MAX; do samtools faidx $LINE\purged1.fa $CHR:$MIN-$MAX >> $GENE\_parts_temp.fa; done

cat $GENE\_$CONTROL\_temp_control_negative2.txt | grep -v line | while read LINE CHR MIN MAX; do samtools faidx -i $LINE\purged1.fa $CHR:$MIN-$MAX >> $GENE\_parts_temp.fa; done

# make fasta without line breaks

awk 'BEGIN{RS=">";FS="\n"}NR>1{seq="";for (i=2;i<=NF;i++) seq=seq""$i; print ">"$1"\n"seq}' $GENE\_parts_temp.fa > $GENE\_parts_temp2.fa

# make list of names for replace

awk '{print $2,$1, OFS="\t"}'  $GENE\_$CONTROL\_temp_control_*2.txt | grep -v chr > names_$GENE\_temp.txt

# Add IM line to chromosome names

perl ~/code/rename_fasta.pl names_$GENE\_temp.txt $GENE\_parts_temp2.fa > $GENE\_parts_temp3.fa 

# get exon parts of gff and make their fasta, for alignment

grep $GENE /panfs/pfs.local/work/kelly/p860v026/genomes/Mgutv5/annotation/MguttatusTOL_551_v5.0.gene_exons.gff3 | grep exon > $GENE\_exons_temp.gff

bedtools getfasta -fi /panfs/pfs.local/work/kelly/p860v026/genomes/Mgutv5/assembly/MguttatusTOL_551_v5.0.fa -bed $GENE\_exons_temp.gff -fo $GENE\_exons_temp.fa -name

# concatenate everything to be aligned 

cat v5_$GENE.fa $GENE\_exontogether_temp.fa $GENE\_cds_temp.fa $GENE\_exons_temp.fa $GENE\_parts_temp3.fa > $GENE\_parts_temp.fa

# mafft alignment

mafft $GENE\_parts_temp.fa > $GENE\_algn_temp.fa

# make fasta have no line breaks

awk 'BEGIN{RS=">";FS="\n"}NR>1{seq="";for (i=2;i<=NF;i++) seq=seq""$i; print ">"$1"\n"seq}' $GENE\_algn_temp.fa > $GENE\_algn.fa

# download and visualise in jalview

# rm $GENE*temp*

