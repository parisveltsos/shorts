#!/bin/bash -l
#SBATCH --job-name=rcn2	    # Job name
#SBATCH --partition=eeb # Partition Name (Required) sixhour kelly
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=14
#SBATCH --mem=62Gb                     # Job memory request
#SBATCH --time=2-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log   # Standard output and error log

GNAME=$1
RACONDIR=/home/p860v026/temp/racon/$GNAME

module load bwa

echo $GNAME 

cd $RACONDIR

bwa index $GNAME\purged1.fa

# Map reads to genome
bwa mem -t 14 $GNAME\purged1.fa $GNAME.reads.fq > $GNAME.sam

