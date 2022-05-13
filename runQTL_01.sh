#!/bin/bash -l
#SBATCH --job-name=qtl	    # Job name
#SBATCH --partition=sixhour
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=2Gb                     # Job memory request
#SBATCH --time=0-02:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log   # Standard output and error log

LINE=$1

module load R

cd /panfs/pfs.local/scratch/kelly/p860v026/qtl/$1

Rscript ~/code/qtl_01_setup.r $1 
