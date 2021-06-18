#!/bin/bash
#SBATCH --job-name=minimap
#SBATCH --partition=sixhour      
#SBATCH --time=0-05:59:00        
#SBATCH --mem-per-cpu=20g         
#SBATCH --mail-user=pveltsos@ku.edu    
#SBATCH --ntasks=1                  
#SBATCH --cpus-per-task=1            
#SBATCH --output=502p_ex.log

REF_FOLDER=/home/p860v026/temp/IM541/make541Sel
REF_GENOME=541sel.fasta
REF_GENOME_NAME=$(basename -s .fasta $REF_GENOME)

# QFOLDER=/home/p860v026/temp/Mgutv5/assembly/
# QFOLDER=/home/p860v026/temp/IM541/make541Sel
QFOLDER=/home/p860v026/temp/IM502/purge2

QGENOME=502.purged.fasta
# QGENOME=541sel.fasta
QGENOME_NAME=$(basename -s .fasta $QGENOME)

cd /home/p860v026/temp/minimap

# Genome to genome

# /home/p860v026/bin/minimap2 $QFOLDER/$QGENOME $REF_FOLDER/$REF_GENOME > $REF_GENOME_NAME\_$QGENOME_NAME.paf


# Exons to genome

/home/p860v026/bin/minimap2 -ax sr $QFOLDER/$QGENOME All14.v5.exons.fa > exons_$QGENOME_NAME.sam
#
python ~/code/trim.sams.py exons_$QGENOME_NAME
