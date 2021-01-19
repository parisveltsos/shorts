#!/bin/bash -l
#SBATCH --job-name=gstats		    # Job name
#SBATCH --partition=sixhour           # Partition Name (Required)
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=8
#SBATCH --mem=20gb                     # Job memory request
#SBATCH --time=00-05:50:00             # Time limit days-hrs:min:sec
#SBATCH --output=gstats_%j.log   # Standard output and error log

# for i in $(echo -e "IM62\nIM125\nIM767"); do sbatch genomeStats.sh $i; done

# cd /home/p860v026/temp/10x/$1

SFOLDER=/home/p860v026/temp/pacbio/Lila.pacbio/canu767
GENOME=767.contigs.fasta

cd $SFOLDER

mkdir gstats

/home/p860v026/temp/STAR/source/STAR --runThreadN 8 --runMode genomeGenerate --genomeDir ./gstats/ --genomeFastaFiles $SFOLDER/$GENOME

