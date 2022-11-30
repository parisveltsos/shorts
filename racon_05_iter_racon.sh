#!/bin/bash -l
#SBATCH --job-name=rcn5	    # Job name
#SBATCH --partition=sixhour # Partition Name (Required) sixhour kelly
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=28
#SBATCH --mem=78Gb                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log   # Standard output and error log

GNAME=$1
OLDGENOME=$2
NEWGENOME=$3

# sbatch racon_04_iter_bwa.sh 1034 1 2

cd /home/p860v026/temp/racon/$GNAME

echo $GNAME

# Run racon
racon -t 28 $GNAME.reads.fq $GNAME.$OLDGENOME.sam $GNAME.racon$OLDGENOME.fasta > $GNAME.racon$NEWGENOME.fasta

# 
# Compare old and new genomes
# module load mummer # https://github.com/isovic/racon/issues/9
# 
# nucmer -p nucmer $GNAME.racon$OLDGENOME.fasta $GNAME.racon$NEWGENOME.fasta
# 
# show-snps -C -T -r nucmer.delta > delta$NEWGENOME.txt
# 

