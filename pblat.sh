#!/bin/bash
#SBATCH --job-name=pblat              # Job name
#SBATCH --partition=eeb           # Partition Name (Required)
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=8
#SBATCH --mem=24gb                     # Job memory request
#SBATCH --time=6-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=pblat_%j.log         # Standard output and error log

echo "Running"
 
WORKFOLDER=/home/p860v026/temp/driver
GENOMEFOLDER=/home/p860v026/temp/Mgutv5/assembly
GENOME=MguttatusTOL_551_v5.0.fa
QUERY=drive.seqs.v2build.fasta 
 
cd $WORKFOLDER

mpirun pblat-cluster $QUERY $GENOMEFOLDER/$GENOME $GENOME.$QUERY.psl
 
date

