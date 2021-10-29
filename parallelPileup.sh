#!/bin/bash -l
#SBATCH --job-name=vcf909             # Job name
#SBATCH --partition=sixhour	     # Partition Name (Required)
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=2gb                     # Job memory request
#SBATCH --time=00-05:50:00             # Time limit days-hrs:min:sec
#SBATCH --output=vcf_%j.log   # Standard output and error log

# GENOMENAME=1192
# GENOMEFILE=1192purged2.fa
# GENOMEFOLDER=/home/p860v026/temp/IM1192/purge2

GENOMENAME=909
GENOMEFILE=909purged2.fa
GENOMEFOLDER=/home/p860v026/temp/IM909/purge2

# GENOMENAME=v5
# GENOMEFILE=MguttatusTOL_551_v5.0.fa
# GENOMEFOLDER=/home/p860v026/temp/genomes/Mgutv5/assembly



## PREPARE FILES

# cd /home/p860v026/temp/3prime/star_$GENOMENAME\_genome

# paste chrName.txt chrLength.txt | sort -r -n -k 2 | perl -pe 's/\t/\:1\-/' > chr.bed

# Split regions to 1000000 size for fast processing in sixhour queue
# python ~/code/split.chroms.py

# cd /home/p860v026/temp/3prime/mapped_to_$GENOMENAME
# for i in $(cat /home/p860v026/temp/3prime/star_$GENOMENAME\_genome/split.chr.bed); do sbatch ~/code/parallelPileup.sh $i; done

# test run should produce vcf in mapped_to_$GENOME
# sbatch ~/code/parallelPileup.sh tig00001061_1:1-1103




## MAIN SCRIPT (1 myr chunk, 2 Gb, 35 min - )

echo $1

module load samtools

module load bcftools/1.9

cd /home/p860v026/temp/3prime/mapped_to_$GENOMENAME

bcftools mpileup -Ou -I -a FORMAT/AD -f $GENOMEFOLDER/$GENOMEFILE -r ${1} -b <(ls *.bam) | bcftools call -vmO v -o ${1}.vcf






## MAKE FINAL VCF (run as job KELLY queue)

# cd /home/p860v026/temp/3prime/mapped_to_$GENOMENAME
# 
# cat <(grep '#' tig00000003_1:3000001-4000000.vcf) <(grep -v '#' *.vcf | perl -pe 's/.+vcf\://') > $GENOMENAME
# 
# mv $GENOMENAME $GENOMENAME.vcf
# 
# python ~/code/makeKey.py $GENOMENAME.vcf