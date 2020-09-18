#!/bin/bash
#SBATCH --job-name=ngmlr                # Job name
#SBATCH --partition=sixhour             # Partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=1gb                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_kmc_%j.log         # Standard output and error log

echo "Running"

cd /home/p860v026/temp/ngmlr

pwd; hostname; date

# awk 'BEGIN{RS=">";FS="\n"}NR==FNR{a[$1]++}NR>FNR{if ($1 in a && $0!="") printf ">%s",$0}' listChr Mimulus_guttatus_TOL.mainGenome.fasta > MgutatChr1013.fasta

# ngmlr -t 10 -x ont -r /home/p860v026/Mimulus.genomes/Mimulus_guttatus_TOL/sequences/MgutatChr1013.fasta -q /home/p860v026/temp/kmer/all.minion.fastq.gz  -o 179NP_1013.sam

ngmlr -t 16 -r /home/p860v026/Mimulus.genomes/Mimulus_guttatus_TOL/sequences/MgutatChr1013.fasta -q <(cat /home/p860v026/temp/kmer/*Reads*)  -o 179PB_1013.sam

module load samtools

samtools view -S -b 179PB_1013.sam > 179PB_1013.bam

samtools sort 179PB_1013.bam -o 179PB_1013.sorted.bam

samtools index 179PB_1013.sorted.bam

sniffles -m 179PB_1013.sorted.bam -v 179PB_1013.sorted.vcf
 
date

