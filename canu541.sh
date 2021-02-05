#!/bin/bash
#SBATCH --job-name=canu541               # Job name
#SBATCH --partition=sixhour # partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=1				# change THIS
#SBATCH --mem-per-cpu=1gb                     # Job memory request
#SBATCH --time=0-5:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_canu541_%j.log         # Standard output and error log

# SETUP

module load canu

PBFOLDER=/home/p860v026/temp/pacbio/r64060_20201112_192654/1_A01/
SAMPLE=541


# PART 1 Run Canu

cd $PBFOLDER

canu -p $SAMPLE -d canu$SAMPLE genomeSize=430m gridOptions="--time=7-5:59:00 --partition=eeb" -pacbio-raw $PBFOLDER/$SAMPLE.fastq.gz correctedErrorRate=0.035 utgOvlErrorRate=0.065 trimReadsCoverage=2 trimReadsOverlap=500 batMemory=72g
