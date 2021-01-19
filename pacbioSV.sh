#!/bin/bash
#SBATCH --job-name=pbSV                # Job name
#SBATCH --partition=kelly               # Partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=1				# change THIS
#SBATCH --mem-per-cpu=8gb                     # Job memory request
#SBATCH --time=4-23:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_pbSV_%j.log         # Standard output and error log

echo "Running"

SMRTFLDR=/home/p860v026/temp/smrtlink/current/bundles/smrttools/smrtcmds/bin/
PBNAME=767 # m64060_201112_195254 62 767 
PBFOLDER=/home/p860v026/temp/pacbio/Lila.pacbio # /home/p860v026/temp/pacbio/r64060_20201112_192654/1_A01 /home/p860v026/temp/pacbio/Lila.pacbio
GNMFOLDER=/home/p860v026/temp/Mgutv5/assembly
OUTNAME=767 # 541 62 767
	
# PART 1. Make fastq files

cd $PBFOLDER 

$SMRTFLDR/bam2fastq -o $OUTNAME $PBFOLDER/$PBNAME.subreads.bam	

## Count number of reads

# 	zcat $OUTNAME.fastq.gz | wc -l # 1340581
	
	
# PART 2. Align to chromosomes # 8 cpu

# export TMPDIR=/home/p860v026/temp/pbmm2Temp$OUTNAME
# 
# $SMRTFLDR/pbmm2 align $GNMFOLDER/MguttatusTOL_551_v5.0.fa /home/p860v026/temp/pacbio/62.bam out62.bam --sort --log-level INFO --log-level DEBUG --median-filter -j 8

# SV discovery # 1 cpu

# $SMRTFLDR/pbsv discover out62.bam out62.svsig.gz --log-level INFO

# Call SV and assign genotypes
	
# $SMRTFLDR/pbsv call $GNMFOLDER/MguttatusTOL_551_v5.0.fa out62.svsig.gz out62.var.vcf --log-level INFO -j 8

# Keep only mapped reads (only mapped reads are there)

# samtools view -b -F 4 outAll.bam > outAll.mapped.bam
# samtools index outAll.mapped.bam

date

