#!/bin/bash
#SBATCH --job-name=mapIllum            # Job name
#SBATCH --partition=eeb,kelly,kucg # partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=4gb                     # Job memory request
#SBATCH --time=1-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_purge_%j.log         # Standard output and error log


GFOLDER=/panfs/pfs.local/scratch/kelly/p860v026/compareGenomes
GNAME=v5_F1509.fa
READFOLDER=/home/p860v026/temp/illuminaGenomeReads
READS=c.767.fastq.gz
OTHER=F1509_parts.fa
OUTNAME=v5

module load samtools

cd $GFOLDER

~/bin/minimap2 -t 12 -xmap-pb $GFOLDER/$GNAME $READFOLDER/$READS |samtools view -S -b | samtools sort > $OUTNAME.bam

samtools index $OUTNAME.bam

~/bin/minimap2 -a -t 12 -xsr $GFOLDER/$GNAME $GFOLDER/$OTHER  | samtools view -S -b | samtools sort > $OUTNAME.2.bam

samtools index $OUTNAME.2.bam
