#!/bin/bash
#SBATCH --job-name=pbSV                # Job name
#SBATCH --partition=kelly               # Partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=8				# change THIS
#SBATCH --mem-per-cpu=12gb                     # Job memory request
#SBATCH --time=6-23:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_pbSV_%j.log         # Standard output and error log

echo "Running"

cd /home/p860v026/temp/pacbioSV
	
# make fastq files

# 	/home/p860v026/temp/smrtlink/current/bundles/smrttools/smrtcmds/bin/bam2fastq -o allReadsAll /home/p860v026/temp/pacbio/r64060_20201112_192654/1_A01/m64060_201112_195254.subreads.bam	

## Count number of reads

# 	zcat allReads.fastq.gz | wc -l # 1340581
	
## Keep 10%
# 	zcat allReads.fastq.gz | head -n above/4
	
# Align subset to chromosomes # 8 cpu

export TMPDIR=/home/p860v026/temp/pbmm2Temp

/home/p860v026/temp/smrtlink/current/bundles/smrttools/smrtcmds/bin/pbmm2 align /home/p860v026/temp/Mgutv5/assembly/chr_10_13.fasta /home/p860v026/temp/pacbio/r64060_20201112_192654/1_A01/m64060_201112_195254.subreads.bam outBig.bam --sort --log-level INFO --log-level DEBUG --median-filter -j 8

# SV discovery # 1 cpu

/home/p860v026/temp/smrtlink/current/bundles/smrttools/smrtcmds/bin/pbsv discover outBig.bam outBig.svsig.gz --log-level INFO

# Call SV and assign genotypes
	
	/home/p860v026/temp/smrtlink/current/bundles/smrttools/smrtcmds/bin/pbsv call /home/p860v026/temp/Mgutv5/assembly/chr_10_13.fasta outBig.svsig.gz outBig.var.vcf --log-level INFO
	
date

