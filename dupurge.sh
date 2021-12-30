#!/bin/bash
#SBATCH --job-name=duprgv5            # Job name
#SBATCH --partition=eeb # partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=4gb                     # Job memory request
#SBATCH --time=1-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_purge_%j.log         # Standard output and error log

PURGEDUPSFOLDER=/home/p860v026/bin/purge_dups/bin
SCRIPTSFOLDER=/home/p860v026/bin/purge_dups/scripts
# GFOLDER=/home/p860v026/temp/IM1192
GFOLDER=/home/p860v026/temp/genomes/Mgutv5/assembly
# GNAME=1192.contigs.fasta
GNAME=MguttatusTOL_551_v5.0.fa
# READS=1192.fasta.gz
OUTNAME=v5

module load python

cd $GFOLDER

~/bin/minimap2 -t 12 -xmap-pb $GNAME $READS | gzip -c - > $OUTNAME.paf.gz

$PURGEDUPSFOLDER/pbcstat $OUTNAME.paf.gz

$PURGEDUPSFOLDER/calcuts PB.stat > cutoffs 2>calcults.log

$PURGEDUPSFOLDER/split_fa $GNAME > $OUTNAME.split

~/bin/minimap2 -t 12 -xasm5 -DP $OUTNAME.split $OUTNAME.split | gzip -c - > $OUTNAME.split.self.paf.gz

$PURGEDUPSFOLDER/purge_dups -2 -T cutoffs -c PB.base.cov $OUTNAME.split.self.paf.gz > dups.bed 2> purge_dups.log

$PURGEDUPSFOLDER/get_seqs -e dups.bed $GNAME  

$SCRIPTSFOLDER/hist_plot.py PB.stat $OUTNAME


# Cleanup and move output to purge1 folder
mkdir purge1
# 
# # cat purged.fa $GNAME > $OUTNAME\PlusPurged.fasta
cat hap.fa $GNAME > $OUTNAME\PlusHap.fasta
mv hap.fa purge1/$OUTNAME\hap1.fa
mv purged.fa purge1/$OUTNAME\purged1.fa
mv calcults.log purge1/$OUTNAME\calcults1.log
mv purge_dups.log purge1/$OUTNAME\purge_dups1.log
mv dups.bed purge1/$OUTNAME\dups1.log
 
rm $OUTNAME.paf.gz
rm PB*
rm cutoffs
rm *split*

# Make purged histogram
cd purge1

~/bin/minimap2 -t 12 -xmap-pb $OUTNAME\purged1.fa ../$READS | gzip -c - > $OUTNAME\PlusHap.paf.gz
 
$PURGEDUPSFOLDER/pbcstat $OUTNAME\PlusHap.paf.gz

$SCRIPTSFOLDER/hist_plot.py PB.stat $OUTNAME\p1
 
cd ..
 
# repeat steps for diploid genomes 

# ~/bin/minimap2 -t 12 -xmap-pb $OUTNAME\PlusHap.fasta $READS | gzip -c - > $OUTNAME\PlusHap.paf.gz
# 
# $PURGEDUPSFOLDER/pbcstat $OUTNAME\PlusHap.paf.gz
# 
# $PURGEDUPSFOLDER/calcuts PB.stat > cutoffs 2>calcults.log
# 
# $PURGEDUPSFOLDER/split_fa $OUTNAME\PlusHap.fasta > $OUTNAME\PlusHap.split
# 
# ~/bin/minimap2 -t 12 -xasm5 -DP $OUTNAME\PlusHap.split $OUTNAME\PlusHap.split | gzip -c - > $OUTNAME\PlusHap.split.self.paf.gz
# 
# $PURGEDUPSFOLDER/purge_dups -2 -T cutoffs -c PB.base.cov $OUTNAME\PlusHap.split.self.paf.gz > dups.bed 2> purge_dups.log
# 
# $PURGEDUPSFOLDER/get_seqs -e dups.bed $OUTNAME\PlusHap.fasta   
# 
# $SCRIPTSFOLDER/hist_plot.py PB.stat $OUTNAME\PlusHap
#
# # Cleanup and move to purge2 folder
# mkdir purge2
# 
# mv hap.fa purge2/$OUTNAME\hap2.fa
# mv purged.fa purge2/$OUTNAME\purged2.fa
# mv $OUTNAME.png purge2/$OUTNAME\purged2.png
# mv calcults.log purge2/$OUTNAME\calcults2.log
# mv purge_dups.log purge2/$OUTNAME\purge_dups2.log
# mv dups.bed purge2/$OUTNAME\dups2.bed
# 
# rm $OUTNAME\PlusHap.paf.gz
# rm PB*
# rm cutoffs
# rm *split*
