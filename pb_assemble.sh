#!/bin/bash
#SBATCH --job-name=pb_chunk               # Job name
#SBATCH --partition=sixhour               # partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=1				# change THIS
#SBATCH --mem-per-cpu=12gb                     # Job memory request
#SBATCH --time=0-5:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_pb_ch_%j.log         # Standard output and error log

# SETUP


# PBNAME=m64060_211111_043657 # Name of movie file 767 62 m64060_201112_195254
PBNAME=m64060_201112_195254 # Name of movie file 767 62 m64060_201112_195254
# PBFOLDER=/home/p860v026/temp/4596_c1_4619_c2/r64060_20211110_200813/2_B01 
PBFOLDER=/home/p860v026/temp/r64060_20201112_192654/1_A01
SMRTFOLDER=/home/p860v026/temp/smrtlink/smrtlink/current/bundles/smrttools/smrtcmds/bin/
cd $PBFOLDER

# For non-rolling circle reads
# Make index

# $SMRTFOLDER/pbindex $PBNAME.subreads.bam

# Make fastq
# $SMRTFOLDER/bam2fastq $PBNAME.subreads.bam



# Steps below assume css reads.

# PART 1. Make css in parallel
# for i in $(echo -e "1\n2\n3\n4\n5\n6\n7\n8\n9\n10"); do sbatch pb_assemble.sh $i; done

$SMRTFOLDER/ccs $PBNAME.subreads.bam $PBNAME\_chunk$1.bam --chunk $1/10 -j 8 --report-file $PBNAME\_chunk$1_report.txt


# PART 2. Merge all files into one
# module load samtools
# samtools merge -@8 $PBNAME.css.bam $PBNAME\_chunk*.bam


# PART 3. Make fastq files

# $SMRTFOLDER/pbindex $PBNAME.css.bam

# $SMRTFOLDER/bam2fastq -o $PBNAME\_ccs $PBFOLDER/$PBNAME.css.bam


# Part 4. Manually delete intermediate files if all ok

# rm *chunk*