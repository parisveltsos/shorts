#!/bin/bash
#SBATCH --job-name=canu1034               # Job name
#SBATCH --partition=kelly # partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=1				# change THIS
#SBATCH --mem-per-cpu=8gb                     # Job memory request
#SBATCH --time=7-5:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_canu1034_%j.log         # Standard output and error log

# SETUP

# module load canu
module load java

PBFOLDER=/home/p860v026/temp/IM1034
SAMPLE=1034


# PART 1 Run Canu

cd $PBFOLDER

~/bin/canu-2.1.1/bin/canu -p $SAMPLE -d canu$SAMPLE genomeSize=430m gridOptions="--time=0-5:59:00 --partition=sixhour" gridOptionsJobName=c1034 -pacbio $PBFOLDER/$SAMPLE.fastq.gz correctedErrorRate=0.035 utgOvlErrorRate=0.065 trimReadsCoverage=2 trimReadsOverlap=500 batMemory=85g

# canu -p $SAMPLE -d canu$SAMPLE genomeSize=430m gridOptions="--time=7-5:59:00 --partition=eeb" -pacbio-raw $PBFOLDER/$SAMPLE.fastq.gz correctedErrorRate=0.035 utgOvlErrorRate=0.065 trimReadsCoverage=2 trimReadsOverlap=500 # batMemory=72g
