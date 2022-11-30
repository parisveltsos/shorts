#!/bin/bash -l
#SBATCH --job-name=qtl0	    # Job name
#SBATCH --partition=sixhour
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=2Gb                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log   # Standard output and error log

LINE=$1

module load R

cd /panfs/pfs.local/scratch/kelly/p860v026/qtl/out/$1

Rscript ~/code/qtl_00_calculateMap.r $1 

paste markerNames.txt <(cat $1\_lg_1.txt $1\_lg_2.txt $1\_lg_3.txt $1\_lg_4.txt $1\_lg_5.txt $1\_lg_6.txt $1\_lg_7.txt $1\_lg_8.txt $1\_lg_9.txt $1\_lg_10.txt $1\_lg_11.txt $1\_lg_12.txt $1\_lg_13.txt $1\_lg_14.txt | grep -v x) > $1\All.txt
