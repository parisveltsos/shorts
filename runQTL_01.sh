#!/bin/bash -l
#SBATCH --job-name=qtl1	    # Job name
#SBATCH --partition=eeb,kelly,kucg
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=2
#SBATCH --mem=4Gb                     # Job memory request
#SBATCH --time=1-01:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log   # Standard output and error log

LINE=$1

module load R

cd /panfs/pfs.local/scratch/kelly/p860v026/qtl/out/$1

# Rscript ~/code/qtl_01a_setup_short.r $1

Rscript ~/code/qtl_01b_setup_long.r $1 

# runtime ≈ 20 min
