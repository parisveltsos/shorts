#!/bin/bash
#SBATCH --job-name=short              # Job name
#SBATCH --partition=sixhour # Partition Name (Required)
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10g                     # Job memory request
#SBATCH --time=00-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.out
#SBATCH --error=R-%x.%j.err

cd /home/p860v026/temp/racon/502

module load mummer

show-snps -C -T -r nucmer.delta > delta1.txt

# minimap2 -x asm10 -t 12 S.latifolia.scaffolds.v1.0.fasta allSet.fasta > allSet.paf


# for i in $(ls *gz | grep -v L002 | perl -pe 's/_S.+//g'); do cat $i* > $i.fastq.gz; done

# du -hs -d 1 /home/p860v026/temp/ > dupv.out

# gzip JKK-LVR_MPS12342939_D10_7687_S1_L002_R2_001.fastq

# tar -zcvf canu541.tar.gz canu541/

