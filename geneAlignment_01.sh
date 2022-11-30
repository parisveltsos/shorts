#!/bin/bash -l
#SBATCH --job-name=GA1	    # Job name
#SBATCH --partition=eeb,kelly,kucg # Partition Name (Required) sixhour kelly
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=14
#SBATCH --mem=2Gb                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log   # Standard output and error log

LINE=$1
WDIR=/panfs/pfs.local/scratch/kelly/p860v026/compareGenomes

cd $WDIR

module load bwa

bwa index $LINE\purged1.fa

# Map reads to genome
bwa mem -t 14 $LINE\purged1.fa allgenes.fa > $LINE.sam

/home/p860v026/bin/minimap-2/misc/paftools.js sam2paf $LINE.sam > $LINE.paf

rm $LINE.sam
