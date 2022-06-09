#!/bin/bash
#SBATCH --job-name=LCR1      # Job name
#SBATCH --partition=eeb
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=1Gb                     # Job memory request
#SBATCH --time=1-05:59:00             # Time limit days-hrs:min:s
#SBATCH --output=R-%x.%j.log   # Standard output and error log

source ~/code/LCR_0_setup.sh

cd $TEMP_FOLDER

## unzip reads

gunzip -c $QREAD_FOLDER/$QREADS_NAME.fasta.gz > $QREADS_NAME.fasta

## split to 100,000 sequences per file and put in folder

mkdir $WDIR

split -l 100000 $QREADS_NAME.fasta $WDIR/$QREADS_NAME\split_

# remove unzipped reads

rm $QREADS_NAME.fasta

