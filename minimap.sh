#!/bin/bash
#SBATCH --job-name=minimap
#SBATCH --partition=sixhour      
#SBATCH --time=0-05:59:00        
#SBATCH --mem-per-cpu=10g  
#SBATCH --mail-user=pveltsos@ku.edu    
#SBATCH --ntasks=12                  
#SBATCH --cpus-per-task=1            
#SBATCH --output=502p_ex.log

REF_FOLDER=/home/p860v026/temp/IM767/purge1
REF_GENOME=767purged1.fa
REF_GENOME_NAME=$(basename -s urged1.fa $REF_GENOME)

QREAD_FOLDER=/home/p860v026/temp/IM502

QREADS=$1
QREADS_NAME=502
WDIR=502mapping

module load samtools

QGENOME_FOLDER=/home/p860v026/temp/IM502/purge1
QGENOME=502purged1.fa
QGENOME_NAME=$(basename -s .fa $QGENOME)

## This is leftover of minimap commands, they need checking

# Genome to genome

# cd $REF_FOLDER
# minimap2 -t 12 $QGENOME_FOLDER/$QGENOME $REF_FOLDER/$REF_GENOME > genome_$QGENOME_NAME\_to$REF_GENOME_NAME.paf


# Exons to genome

# /home/p860v026/bin/minimap2 -ax sr $QREAD_FOLDER/$QGENOME All14.v5.exons.fa > exons_$QGENOME_NAME.sam
#
# python ~/code/trim.sams.py exons_$QGENOME_NAME





