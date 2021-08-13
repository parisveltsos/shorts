#!/bin/bash
#SBATCH --job-name=pb_1034               # Job name
#SBATCH --partition=kelly               # partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=8				# change THIS
#SBATCH --mem-per-cpu=8gb                     # Job memory request
#SBATCH --time=3-5:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=IM1034_%j.log         # Standard output and error log

# SETUP

PBNAME=m64060_210320_174045 # Name of bam file
PBFOLDER=~/temp/IM1034/ # location of raw data
# SMRTFOLDER=/home/p860v026/bin/smrtlink/smrtlink/current/bundles/smrttools/smrtcmds/bin

cd $PBFOLDER


# PART 1 make index of movie file

# pbindex $PBNAME.subreads.bam


# PART 2. Make css in parallel (sixhour)
# for i in $(echo -e "1\n2\n3\n4\n5\n6\n7\n8\n9\n10"); do sbatch IM1034.sh $i; done
# for i in $(echo -e "1"); do sbatch IM1034.sh $i; done

# 
# ccs $PBNAME.subreads.bam $PBNAME\_chunk$1.bam --chunk $1/10 -j 8 --report-file $PBNAME\_chunk$1_report.txt


# PART 3. Merge all files into one (kelly)

samtools merge -@8 $PBNAME.css.bam $PBNAME\_chunk*.bam


# PART 4. Make fastq files

pbindex $PBNAME.css.bam

bam2fastq -o $PBNAME\_ccs $PBFOLDER/$PBNAME.subreads.bam


# Part 5. Manually delete intermediate files if all ok

# rm *chunk*