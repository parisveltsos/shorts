#!/bin/bash -l
#SBATCH --job-name=racon2	    # Job name
#SBATCH --partition=eeb # Partition Name (Required) sixhour kelly
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=14
#SBATCH --mem=24Gb                     # Job memory request
#SBATCH --time=2-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log   # Standard output and error log

GNAME=$1
RACONDIR=/home/p860v026/temp/racon/$GNAME

module load bwa

echo $GNAME 

cd $RACONDIR

# Map reads to genome
bwa mem -t 14 $GNAME.final.fa $GNAME.reads.fq > $GNAME.sam

# Run racon
racon -t 14 $GNAME.reads.fq $GNAME.sam $GNAME.final.fa > $GNAME.racon1.fasta


# Compare old and new genomes

module load mummer # https://github.com/isovic/racon/issues/9

nucmer -p nucmer $GNAME.final.fa $GNAME.racon1.fasta

show-snps -C -T -r nucmer.delta > delta1.txt
