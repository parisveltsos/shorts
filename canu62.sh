#!/bin/bash
#SBATCH --job-name=canu62               # Job name
#SBATCH --partition=kelly               # partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=1				# change THIS
#SBATCH --mem-per-cpu=1gb                     # Job memory request
#SBATCH --time=0-23:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_canu62_%j.log         # Standard output and error log

# SETUP

module load canu

PBFOLDER=/home/p860v026/temp/pacbio/Lila.pacbio/
SAMPLE=62


# PART 1 Run Canu

cd $PBFOLDER

canu -p $SAMPLE -d canu$SAMPLE genomeSize=430m gridOptions="--time=1-23:59:00 --partition=eeb" -pacbio-raw $PBFOLDER/$SAMPLE.fastq.gz
