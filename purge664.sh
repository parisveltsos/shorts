#!/bin/bash
#SBATCH --job-name=prg664              # Job name
#SBATCH --partition=eeb # partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=24
#SBATCH --mem-per-cpu=2gb                     # Job memory request
#SBATCH --time=4-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_purge_%j.log         # Standard output and error log

BUSCOSUPPORT=/home/p860v026/temp/bin/buscoSupport

GFOLDER=/home/p860v026/temp/IM664
GNAME=664.contigs.fasta
BAMNAME=aligned664.bam

module load samtools
module load R

# it did never resulted in useful output 

cd $GFOLDER

~/bin/minimap2 -t 24 -ax map-pb $GNAME 664.fastq.gz --secondary=no \ | samtools sort -@ 24 -m 4G -o $BAMNAME -T tmp.ali

# samtools index -@ 24 $BAMNAME

~/bin/purge_haplotigs/purge_haplotigs readhist -b $BAMNAME -g $GNAME -t 24
