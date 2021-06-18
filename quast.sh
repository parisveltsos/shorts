#!/bin/bash
#SBATCH --job-name=quast2v5               # Job name
#SBATCH --partition=eeb               # partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4gb                     # Job memory request
#SBATCH --time=7-23:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_quast2v5_%j.log         # Standard output and error log

# SETUP


PBFOLDER=/home/p860v026/temp/IM664
PBREADS=664.fastq.gz
GFOLDER=/home/p860v026/temp/IM664
GNAME=664.contigs.fasta
RFOLDER=/home/p860v026/temp/Mgutv5/assembly
RNAME=MguttatusTOL_551_v5.0.fa.gz

module load quast
# module load python

cd $GFOLDER

quast.py $GFOLDER/$GNAME -r $RFOLDER/$RNAME -g /home/p860v026/temp/Mgutv5/annotation/MguttatusTOL_551_v5.0.gene.gff3 --large -k --circos --rna-finding --conserved-genes-finding --pacbio $PBFOLDER/$PBREADS --fragmented --gene-finding

# quast.py $GFOLDER/$GNAME -r $RFOLDER/$RNAME -g /home/p860v026/temp/Mgutv5/annotation/MguttatusTOL_551_v5.0.gene.gff3 --large -k --circos --rna-finding --conserved-genes-finding --fragmented

