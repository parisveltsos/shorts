#!/bin/bash -l
#SBATCH --job-name=Mim06           # Job name
#SBATCH --partition=sixhour	     # Partition Name (Required)
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=2gb                     # Job memory request
#SBATCH --time=00-05:50:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log   # Standard output and error log

source ~/code/mim_setup.sh


## MAKE FINAL VCF
# edit the vcf in the first grep line

cd $OUTFOLDER/mapped_to_$GENOMENAME

grep '#' tig00000090_1:600001-700000.vcf > $GENOMENAME.vcf
grep -v '#' *vcf >> $GENOMENAME.vcf

python ~/code/makeKey.py $GENOMENAME.vcf
