#!/bin/bash -l
#SBATCH --job-name=snps		    # Job name
#SBATCH --partition=eeb           # Partition Name (Required)
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=40gb                     # Job memory request
#SBATCH --time=02-05:50:00             # Time limit days-hrs:min:sec
#SBATCH --output=snps_%j.log   # Standard output and error log

cd /home/p860v026/temp/3prime/mapped

GENOMEFILE=664.contigs.fa
GENOMEFOLDER=/home/p860v026/temp/IM664
GENOMENAME=664

module load samtools

## PART 1 (needs pre-combined L001 and L002 fastq, should be already indexed so no need to run)

# samtools index *.bam



## PART 2 Run once (20 gb mem) index genome

# module load bwa
# cd $GENOMEFOLDER

# bwa index $GENOMEFILE


## PART 3 call SNPs

module load bcftools/1.9

cd /home/p860v026/temp/3prime/mapped_to_$GENOMENAME

bcftools mpileup -Ou -I -a FORMAT/AD -f $GENOMEFOLDER/$GENOMEFILE -b <(ls *.bam) | bcftools call -vmO v -o $GENOMENAME.vcf

# -Ou uncompressed
# -I skip indels
# -a optional annotation Allelic Depth
# -f faidx indexed reference sequence file

# -v variants only
# -m multiallelic caller (alternative)
# -O v uncompressed vcf
