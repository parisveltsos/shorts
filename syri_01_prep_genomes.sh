#!/bin/bash
#SBATCH --job-name=syri1    # Job name
#SBATCH --partition=sixhour #eeb,kucg,kelly           # Partition Name (Required)
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=2gb                     # Job memory request
#SBATCH --time=00-00:50:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log

source ~/code/syri_00_setup.sh

mkdir $WFOLDER
cd $WFOLDER

# copy reference pseudochromosomes

# cp /panfs/pfs.local/work/kelly/p860v026/genomes/IM767.pseudo_chroms.fa .
cp /panfs/pfs.local/work/kelly/p860v026/Final.builds/MguttatusvarIM767.v1.1.prelim.annot/Mimulus_guttatus_var_IM767.mainGenome.fasta IM767.fa

# cp $GFOLDER/767pseudoChr3.fa .

# awk '/^>/ {printf("%s%s\t",(N>0?"\n":""),$0);N++;next;} {printf("%s",$0);} END {printf("\n");}'  $GFOLDER/767purged1.fa  | awk -F '\t' '{printf("%d\t%s\n",length($2),$0);}' | sort -k1,1n | cut -f 2- | tr "\t" "\n" > 767_sorted_temp.fa

# tail -100 767_sorted_temp.fa > 767_longest50.fa

# Sort query by sequence length, longest in end

awk '/^>/ {printf("%s%s\t",(N>0?"\n":""),$0);N++;next;} {printf("%s",$0);} END {printf("\n");}'  $GFOLDER/$QNAME\purged1.fa  | awk -F '\t' '{printf("%d\t%s\n",length($2),$0);}' | sort -k1,1n | cut -f 2- | tr "\t" "\n" > $QNAME\_sorted_temp.fa

# keep 50 longest sequences
 
tail -100 $QNAME\_sorted_temp.fa > $QNAME\_longest50.fa

rm *temp*
