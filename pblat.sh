#!/bin/bash
#SBATCH --job-name=pblat              # Job name
#SBATCH --partition=sixhour           # Partition Name (Required)
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH -n 8                          # Run on a single CPU
#SBATCH -N 8
#SBATCH --mem=2gb                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=pblat_%j.log         # Standard output and error log

echo "Running"
 
cd /home/p860v026/Mimulus.genomes

pwd; hostname; date

mpirun ~/bin/icebert-pblat-cluster-f850247/pblat-cluster tilingii.fasta Mimulus_guttatus_TOL/annotation/MguttatusTOL_551_v5.0.transcript_primaryTranscriptOnly.fa primaryTranscriptOut.psl
 
date

