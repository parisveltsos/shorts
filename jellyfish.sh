#!/bin/bash
#SBATCH --job-name=jelly              # Job name
#SBATCH --partition=sixhour           # Partition Name (Required)
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH -n 8                          # Run on a single CPU
#SBATCH -N 8
#SBATCH --mem=16gb                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=pblat_%j.log         # Standard output and error log

# instructions, and upload file to http://qb.cshl.edu/genomescope/

module load jellyfish

echo "Running"

cd /home/p860v026/scratch/kmer/Tolpis_coronop/Run2 

pwd; hostname; date

jellyfish count -m 21 <(gzip -dc *.gz) -o fastqR2all21.counts -C -s 2000000000 -U 500 -t 8 

jellyfish histo -t 8 fastqR2all21.counts > fastqR2all21.counts.histo 

date

