#!/bin/bash
#SBATCH --job-name=ngmlr                # Job name
#SBATCH --partition=eeb             # Partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=6gb                     # Job memory request
#SBATCH --time=5-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_kmc_%j.log         # Standard output and error log

# https://github.com/philres/ngmlr

echo "Running"

# run time 2:19

GENOME=sel541.fasta
PBFOLDER=/home/p860v026/temp/IM502
PBREADS=502.fastq.gz
PBREADS_NAME=$(basename -s .fastq.gz $PBREADS)
NGMLRFOLDER=/home/p860v026/temp/ngmlr

cd $NGMLRFOLDER

pwd; hostname; date

# make chromosome subset
# awk 'BEGIN{RS=">";FS="\n"}NR==FNR{a[$1]++}NR>FNR{if ($1 in a && $0!="") printf ">%s",$0}' list.txt <(perl -pe 's/ .+//g' 541.contigs.fasta) > sel541.fasta

ngmlr -t 16  -r $GENOME -q $PBFOLDER/$PBREADS  -o $PBREADS_NAME\_$GENOME.sam # -x ont

module load samtools

samtools view -S -b $PBREADS_NAME\_$GENOME.sam > $PBREADS_NAME\_$GENOME.bam

samtools sort $PBREADS_NAME\_$GENOME.bam -o $PBREADS_NAME\_$GENOME.sorted.bam

samtools index $PBREADS_NAME\_$GENOME.sorted.bam

sniffles -m $PBREADS_NAME\_$GENOME.sorted.bam -v snif2.$PBREADS_NAME\_$GENOME.vcf --max_num_splits 14 -t 16 -n 10 --max_dist_aln_events 6 --max_diff_per_window 55
 
date

