#!/bin/bash
#SBATCH --job-name=rcn6              # Job name
#SBATCH --partition=sixhour 	# Partition Name (Required)
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=28
#SBATCH --mem-per-cpu=30g                     # Job memory request
#SBATCH --time=00-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.out
#SBATCH --error=R-%x.%j.err

GNAME=$1

cd /home/p860v026/temp/racon/$GNAME

module load mummer

# dnadiff 767purged1.fa 767.racon4.fasta

# nucmer -t 28 -p nucmer $GNAME\purged1.fa $GNAME.racon1.fasta
 
# show-snps -C -T -r nucmer.delta > delta$GNAME\_1.txt
# 
# 
# nucmer -t 28 -p nucmer $GNAME\purged1.fa $GNAME.racon2.fasta
#  
# show-snps -C -T -r nucmer.delta > delta$GNAME\_2.txt

nucmer  -t 28 -p nucmer $GNAME\purged1.fa $GNAME.racon3.fasta
#  
show-snps -C -T -r nucmer.delta > delta$GNAME\_3.txt


 

# minimap2 -x asm10 -t 12 S.latifolia.scaffolds.v1.0.fasta allSet.fasta > allSet.paf


# for i in $(ls *gz | grep -v L002 | perl -pe 's/_S.+//g'); do cat $i* > $i.fastq.gz; done

# du -hs -d 1 /home/p860v026/temp/ > dupv.out

# gzip JKK-LVR_MPS12342939_D10_7687_S1_L002_R2_001.fastq

# tar -zcvf canu541.tar.gz canu541/

