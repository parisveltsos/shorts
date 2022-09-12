#!/bin/bash -l
#SBATCH --job-name=qtl1	    # Job name
#SBATCH --partition=sixhour
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=2Gb                     # Job memory request
#SBATCH --time=0-02:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log   # Standard output and error log

LINE=$1

module load R

cd /panfs/pfs.local/scratch/kelly/p860v026/qtl/out/$1

Rscript ~/code/qtl_01_setup.r $1 

# runtime ≈ 5 min

# data prep
# for LINE in $(echo -e "62\t155\t237\t444\t502\t541\t664\t909\t1034\t1192"); do cp /panfs/pfs.local/scratch/kelly/p860v026/vcf767/$LINE/$LINE.genotypes.txt .; done

# for LINE in $(echo -e "62\t155\t237\t444\t502\t541\t664\t909\t1034\t1192"); do sbatch ~/code/runQTL_01.sh $LINE; done