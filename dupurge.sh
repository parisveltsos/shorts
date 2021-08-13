#!/bin/bash
#SBATCH --job-name=duprg1034              # Job name
#SBATCH --partition=eeb # partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=4gb                     # Job memory request
#SBATCH --time=1-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_purge_%j.log         # Standard output and error log

GFOLDER=/home/p860v026/temp/IM1034
GNAME=1034.contigs.fasta
READS=1034.fastq.gz
OUTNAME=1034

module load python

cd $GFOLDER

~/bin/minimap2 -t 12 -xmap-pb $GNAME $READS | gzip -c - > $OUTNAME.paf.gz

/home/p860v026/temp/bin/purge_dups/bin/pbcstat $OUTNAME.paf.gz

/home/p860v026/temp/bin/purge_dups/bin/calcuts PB.stat > cutoffs 2>calcults.log

/home/p860v026/temp/bin/purge_dups/bin/split_fa $GNAME > $OUTNAME.split

~/bin/minimap2 -t 12 -xasm5 -DP $OUTNAME.split $OUTNAME.split | gzip -c - > $OUTNAME.split.self.paf.gz

/home/p860v026/temp/bin/purge_dups/bin/purge_dups -2 -T cutoffs -c PB.base.cov $OUTNAME.split.self.paf.gz > dups.bed 2> purge_dups.log

/home/p860v026/temp/bin/purge_dups/bin/get_seqs -e dups.bed $GNAME  

/home/p860v026/temp/bin/purge_dups/scripts/hist_plot.py PB.stat $OUTNAME

mkdir purge1

cat purged.fa $GNAME > $OUTNAME\PlusPurged.fasta
mv hap.fa purge1/$OUTNAME\hap1.fa
mv purged.fa purge1/$OUTNAME\purged1.fa
mv $OUTNAME.png purge1/$OUTNAME\1.png
mv calcults.log purge1/$OUTNAME\calcults1.log
mv purge_dups.log purge1/$OUTNAME\purge_dups1.log
mv dups.bed purge1/$OUTNAME\dups1.log

rm $OUTNAME.paf.gz
rm PB*
rm cutoffs
rm *split*


~/bin/minimap2 -t 12 -xmap-pb $OUTNAME\PlusPurged.fasta $READS | gzip -c - > $OUTNAME\PlusPurged.paf.gz

/home/p860v026/temp/bin/purge_dups/bin/pbcstat $OUTNAME\PlusPurged.paf.gz

/home/p860v026/temp/bin/purge_dups/bin/calcuts PB.stat > cutoffs 2>calcults.log

/home/p860v026/temp/bin/purge_dups/bin/split_fa $OUTNAME\PlusPurged.fasta > $OUTNAME\PlusPurged.split

~/bin/minimap2 -t 12 -xasm5 -DP $OUTNAME\PlusPurged.split $OUTNAME\PlusPurged.split | gzip -c - > $OUTNAME\PlusPurged.split.self.paf.gz

/home/p860v026/temp/bin/purge_dups/bin/purge_dups -2 -T cutoffs -c PB.base.cov $OUTNAME\PlusPurged.split.self.paf.gz > dups.bed 2> purge_dups.log

/home/p860v026/temp/bin/purge_dups/bin/get_seqs -e dups.bed $OUTNAME\PlusPurged.fasta   

/home/p860v026/temp/bin/purge_dups/scripts/hist_plot.py PB.stat $OUTNAME\PlusPurged

mkdir purge2

mv hap.fa purge2/$OUTNAME\hap2.fa
mv purged.fa purge2/$OUTNAME\purged2.fa
mv $OUTNAME.png purge2/$OUTNAME\purged2.png
mv calcults.log purge2/$OUTNAME\calcults2.log
mv purge_dups.log purge2/$OUTNAME\purge_dups2.log
mv dups.bed purge2/$OUTNAME\dups2.bed

rm $OUTNAME\PlusPurged.paf.gz
rm PB*
rm cutoffs
rm *split*
