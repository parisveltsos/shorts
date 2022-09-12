#!/bin/bash -l
#SBATCH --job-name=qtlGeno	    # Job name
#SBATCH --partition=sixhour
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=2Gb                     # Job memory request
#SBATCH --time=0-01:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log   # Standard output and error log

LINE=$1

module load R

cd /panfs/pfs.local/scratch/kelly/p860v026/vcf767/$LINE

perl -pe 's/,/\t/g' $LINE.genotypes_temp.txt | awk -f ~/code/transpose.sh | perl -pe 's/\t\t/\toldlg\toldcm/' > $LINE.genotypes_temp2.txt

Rscript ~/code/qtl_00_prepGeno.r $1

cat <(awk 'NR>1' $LINE.\genotypes_temp3.txt | head -3 | perl -pe 's/ +/,/g ; s/,,/,/g ; s/tig/id,tig/')  <(paste temp_F2names.txt <(awk 'NR>4' $LINE.\genotypes_temp3.txt ) | perl -pe 's/\t/,/') > $LINE\.genotypes.txt

# cut -f1 -d, $LINE.genotypes_temp.txt > $LINE.genotyped.list.txt

cp $LINE\.genotypes.txt /panfs/pfs.local/scratch/kelly/p860v026/qtl/in/