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


# This scripts maps PACBIO Continuous Long Reads (CLR) to a genome assembly


# Old merge bams 12 cpu 2 gb em 5 days

source ~/code/LCR_0_setup.sh

cd $QREAD_FOLDER/$WDIR

samtools merge $QREADS_NAME.bam *.bam

samtools index $QREADS_NAME.bam



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