#!/bin/bash
#SBATCH --job-name=kallisto                # Job name
#SBATCH --partition=sixhour               # Partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2gb                     # Job memory request
#SBATCH --time=0-05:58:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_kallisto_%j.log         # Standard output and error log

module load kallisto

# Variables to change once per project

KALDIR=/home/p860v026/temp/kallisto

## Change for each combination of mapped reads to a reference. The reads can be `.fa` or `.fq`. Find and replace in this file `individual` and `interesting_sequence`.
REFDIR=/home/p860v026/temp/genomes/Mgutv5/annotation
REF=MguttatusTOL_551_v5.0.transcript.fa

READDIR=/home/p860v026/temp/3prime/trimmed

cd $KALDIR || exit 1


## RUN ONCE
# kallisto index -i primaryTscp $REFDIR/$REF | exit 3



## RUN PER FILE

# for i in $(ls /home/p860v026/temp/3prime/trimmed/ | grep fastq); do sbatch ~/code/kallisto.sh $i; done

READNAME=$(perl -pe 's/_.+L00/-R/ ; s/_.+//' <(echo $1)) 

kallisto quant -i primaryTscp --single -l 150 -s 20 -o $READNAME $READDIR/$1



# MANUALLY COMPILE ALL FILES TOGETHER

#	for i in $(ls | grep -v 'txt\|gz\|log\|primaryTscp'); do cut -f4 $i/abundance.tsv > $i.txt;  done

#	for i in $(ls | grep txt); do cat <(echo $i | perl -pe 's/.txt//') <(tail -n +2 $i) > $i\_count.txt; done

#	cut -f1 909-P16-R2/abundance.tsv > 1count.txt

#	paste *count* > ktable.txt

# Manually fix outcome