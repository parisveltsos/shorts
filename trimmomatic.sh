#!/bin/bash
#SBATCH --job-name=trimmomatic                # Job name
#SBATCH --partition=sixhour               # Partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=16gb                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_trim_%j.log         # Standard output and error log

module load trimmomatic
echo "Running"

# Variables to change once per project

## Never change, the files will be copied in a subfolder named after the reads and reference, inside a project folder inside the scratch folder
SCRATCHDIR=/home/p860v026/temp/kmer

## Change for each combination of mapped reads to a reference. The reads can be `.fa` or `.fq`. Find and replace in this file `individual` and `interesting_sequence`.
READS1=JKK-LVR_MPS12342939_D10_7687_S1_L002_R1_001.fastq
READS2=JKK-LVR_MPS12342939_D10_7687_S1_L002_R2_001.fastq
# REFERENCE=MgutatChr1013.fasta
OUTPUT=R1_10x_trim.fastq

cd $SCRATCHDIR || exit 1

trimmomatic SE -threads 8 $READS1 $OUTPUT HEADCROP:16

