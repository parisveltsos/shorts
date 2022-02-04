#!/bin/bash
#SBATCH --job-name=minimap
#SBATCH --partition=eeb      
#SBATCH --time=2-05:59:00        
#SBATCH --mem-per-cpu=4g  
#SBATCH --mail-user=pveltsos@ku.edu    
#SBATCH --ntasks=1                  
#SBATCH --cpus-per-task=2  # change this         
#SBATCH --output=R-%x.%j.out
#SBATCH --error=R-%x.%j.err

REF_FOLDER=/home/p860v026/temp/IM767/purge1
REF_GENOME=767purged1.fa
REF_GENOME_NAME=$(basename -s purged1.fa $REF_GENOME)

QREAD_FOLDER=/home/p860v026/temp/IM502

LCONTIG=$1
QREADS=$1
QREADS_OUT=$(basename -s .fasta $QREADS)
QREADS_NAME=502
WDIR=502mapping

module load samtools

# This scripts maps PACBIO Continuous Long Reads (CLR) to a genome assembly

# Note, need reads fasta into two lines per sequence. Make if needed:

# perl ~/code/makeFastaOneLine.pl < in.fasta > out.fasta



# PART 1 SPLIT READS TO MANY FILES - 1 core sixhour

# cd $QREAD_FOLDER
# 
# ## unzip reads
# 
# gunzip $QREADS_NAME.fasta.gz
# 
# ## split to 250,000 sequences per file 
# 
# split -l 100000 $QREADS_NAME.fasta $QREADS_NAME\split_
# 
# # Make working folder
# 
# mkdir $WDIR
# 
# # Move split files to new folder
# 
# for i in $(find . -name '*split*'); do mv $i $WDIR/$i.fasta; done
# 
# # zip reads again 
# 
# gzip $QREADS_NAME.fasta
# 


# PART 2 MAP EACH SPLIT FILE IN PARALLEL - 12 cores sixhour < 2hr 8 - Gb memory

# Run with 
#	check fasta or fastq
#	check 2 lines per read, if not # perl ~/code/makeFastaOneLine.pl < in.fasta > out.fasta
#	cd $QREAD_FOLDER/$WDIR
#	for i in $(ls *fasta); do sbatch ~/code/LCR_minimap.sh $i; done

# cd $QREAD_FOLDER/$WDIR
# 
# minimap2 -a -x ava-pb -t 12 $REF_FOLDER/$REF_GENOME $QREAD_FOLDER/$WDIR/$QREADS  > $QREADS_OUT\_$REF_GENOME_NAME.sam
# 
# samtools sort $QREADS_OUT\_$REF_GENOME_NAME.sam -o $QREADS_OUT\_$REF_GENOME_NAME.bam
# 
# samtools index $QREADS_OUT\_$REF_GENOME_NAME.bam


# PART 3 MERGE BAMs - 1 core eeb >2.5 days 2Gb

# cd $QREAD_FOLDER/$WDIR
# 
# samtools merge $QREADS_NAME.bam *.bam
# 
# samtools index $QREADS_NAME.bam

# PART 4 cleanup 

# rm *split*bam
# rm *split*bam.bai
# rm *split*sam
# rm *fasta

# https://www.biostars.org/p/339434/

# PART 5 Filtering - 2 cpu

cd $QREAD_FOLDER/$WDIR

## Split by chromosome

# for i in $(cat listLongContigs); do sbatch ~/code/LCR_minimap.sh $i; done

sbatch ~/code/LCR_minimap.sh $i

## keep specific contig

samtools view -bh $QREADS_NAME.bam $LCONTIG > $LCONTIG\_temp.bam

samtools view -h $LCONTIG\_temp.bam > $LCONTIG\_temp.sam &

samtools view -bSq 2 $LCONTIG\_temp.bam > $LCONTIG\_filtered.bam

samtools index $LCONTIG\_filtered.bam &

samtools view -h $LCONTIG\_filtered.bam > $LCONTIG\_filtered.sam


# rm *bam*
# rm *sam
# rm R-*