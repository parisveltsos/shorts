#!/bin/bash
#SBATCH --job-name=ngmlr                # Job name
#SBATCH --partition=eeb             # Partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=1gb                     # Job memory request
#SBATCH --time=3-23:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_kmc_%j.log         # Standard output and error log

# https://github.com/philres/ngmlr

echo "Running"

GNMFOLDER=/home/p860v026/temp/Mgutv5/assembly
PBFOLDER=/home/p860v026/temp/pacbio/r64060_20201112_192654/1_A01
GENOME=MguttatusTOL_551_v5.0.fa
PBREADS=541
NGMLRFOLDER=/home/p860v026/temp/ngmlr

cd $NGMLRFOLDER

pwd; hostname; date

# make chromosome subset
# awk 'BEGIN{RS=">";FS="\n"}NR==FNR{a[$1]++}NR>FNR{if ($1 in a && $0!="") printf ">%s",$0}' listChr Mimulus_guttatus_TOL.mainGenome.fasta > MgutatChr1013.fasta

# ngmlr -t 10 -x ont -r /home/p860v026/Mimulus.genomes/Mimulus_guttatus_TOL/sequences/MgutatChr1013.fasta -q /home/p860v026/temp/kmer/all.minion.fastq.gz  -o 179NP_1013.sam

ngmlr -t 16 -r $GNMFOLDER/$GENOME -q $PBFOLDER/$PBREADS.fastq.gz  -o $PBREADS.Mgutv5.sam

module load samtools

samtools view -S -b $PBREADS.Mgutv5.sam > $PBREADS.Mgutv5.bam

samtools sort $PBREADS.Mgutv5.bam -o $PBREADS.Mgutv5.sorted.bam

samtools index $PBREADS.Mgutv5.sorted.bam

sniffles -m $PBREADS.Mgutv5.sorted.bam -v $PBREADS.Mgutv5.sorted.sniffles.vcf
 
date

