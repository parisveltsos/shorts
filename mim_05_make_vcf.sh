#!/bin/bash -l
#SBATCH --job-name=Mim05           # Job name
#SBATCH --partition=sixhour	     # Partition Name (Required)
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=2gb                     # Job memory request
#SBATCH --time=00-05:50:00             # Time limit days-hrs:min:sec
#SBATCH --output=vcf_%j.log   # Standard output and error log

source ~/code/mim_setup.sh


## PREPARE FILES

# cd $OUTFOLDER/$STARGENOMEFOLDER

# paste chrName.txt chrLength.txt | sort -r -n -k 2 | perl -pe 's/\t/\:1\-/' > chr.bed

# Split regions to 1000000 size for fast processing in sixhour queue
# python ~/code/split.chroms.py

# cd $OUTFOLDER/mapped_to_$GENOMENAME
# for i in $(cat $OUTFOLDER/$STARGENOMEFOLDER/split.chr.bed); do sbatch ~/code/mim_05_make_vcf.sh $i; done
# for i in $(cat $OUTFOLDER/$STARGENOMEFOLDER/split.chr.bed | tail -90); do sbatch ~/code/mim_05_make_vcf.sh $i; done # can only submit 5000 jobs

# test run should produce vcf in mapped_to_$GENOME
# sbatch ~/code/mim_05_make_vcf.sh scaffold_5793:1-1025



## MAIN SCRIPT (1 myr chunk, 2 Gb, 35 min - )

echo $1

module load samtools

module load bcftools/1.9

cd $OUTFOLDER/mapped_to_$GENOMENAME

bcftools mpileup -Ou -I -a FORMAT/AD -f $GENOMEFOLDER/$GENOMEFILE -r ${1} -b <(ls *.bam) | bcftools call -vmO v -o ${1}.vcf


