#!/bin/bash -l
#SBATCH --job-name=snps		    # Job name
#SBATCH --partition=kelly           # Partition Name (Required)
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=40gb                     # Job memory request
#SBATCH --time=05-05:50:00             # Time limit days-hrs:min:sec
#SBATCH --output=snps_%j.log   # Standard output and error log

cd /home/p860v026/temp/3prime/mapped

## PART 1 Run per bam pair (1Gb mem)

#  cd /home/p860v026/temp/3prime/mapped
#  ls *.bam | perl -pe 's/L00.Aligned.sortedByCoord.out.bam//' | uniq > list
#  vim list
#  for i in $(cat list); do sbatch ~/code/htseq_snps.sh $i; done

# samtools merge $1.bam $1\L001Aligned.sortedByCoord.out.bam $1\L001Aligned.sortedByCoord.out.bam
# samtools sort $1.bam -o $1.sorted.bam
# samtools index $1.sorted.bam


## PART 2 Run once (20 gb mem)

## 2A index genome (if needed)

# module load bwa
# cd /home/p860v026/temp/Mgutv5/assembly
# bwa index MguttatusTOL_551_v5.0.fa


## 2B call SNPs

module load bcftools/1.9

bcftools mpileup -Ou -I -a FORMAT/AD -f ~/temp/Mgutv5/assembly/MguttatusTOL_551_v5.0.fa -b <(ls *sorted.bam) | bcftools call -vmO v -o pool1.vcf

# -Ou uncompressed
# -I skip indels
# -a optional annotation Allelic Depth
# -f faidx indexed reference sequence file

# -v variants only
# -m multiallelic caller (alternative)
# -O v uncompressed vcf
