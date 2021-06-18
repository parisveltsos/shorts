#!/bin/bash
#SBATCH --job-name=pbSV                # Job name
#SBATCH --partition=eeb               # Partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=1				# change THIS
#SBATCH --mem-per-cpu=90gb                     # Job memory request
#SBATCH --time=5-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_pbSV_%j.log         # Standard output and error log

# run time 3:09

echo "Running"

# SMRTFLDR=/home/p860v026/temp/smrtlink/current/bundles/smrttools/smrtcmds/bin/
PBFOLDER=/home/p860v026/temp/IM502
PBREADS=502.fastq.gz
PBREADS_NAME=$(basename -s .fastq.gz $PBREADS)
PBSV_FOLDER=/home/p860v026/temp/pbsv
GENOME=sel541.fasta

	
# PART 1. Make fastq files

# cd $PBFOLDER 

# $SMRTFLDR/bam2fastq -o $OUTNAME $PBFOLDER/$PBNAME.subreads.bam	

## Count number of reads

# 	zcat $OUTNAME.fastq.gz | wc -l # 1340581
	
	
PART 2. Align to chromosomes # 8 cpu

cd $PBSV_FOLDER 

export TMPDIR=/home/p860v026/temp/pbmm2Temp$PBREADS_NAME
 
# pbmm2 align $GENOME $PBFOLDER/$PBREADS $PBREADS_NAME\_$GENOME.bam --sort --log-level INFO --log-level DEBUG --median-filter -j 8

# SV discovery # 1 cpu

pbsv discover $PBREADS_NAME\_$GENOME.bam $PBREADS_NAME\_$GENOME.svsig.gz --log-level INFO

# Call SV and assign genotypes # needs 90 Gb memory
	
pbsv call $GENOME $PBREADS_NAME\_$GENOME.svsig.gz $PBREADS_NAME\_$GENOME.var.vcf --log-level INFO -j 8

# Keep only mapped reads (only mapped reads are there)

# samtools view -b -F 4 outAll.bam > outAll.mapped.bam
# samtools index outAll.mapped.bam

date

