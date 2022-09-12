#!/bin/bash -l
#SBATCH --job-name=qtl3	    # Job name
#SBATCH --partition=sixhour
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=2Gb                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log   # Standard output and error log

LINE=$1

cd /panfs/pfs.local/scratch/kelly/p860v026/qtl/out

echo -e 'pheno\tsnp\tlg\tcm\tlod\tp\ta\td\tse.a\tse.d\tthreshold\tlod.ci.low\tlod.ci.high' > $LINE.lod.txt

# cat $LINE/*txt | grep -v snp | perl -pe 's/_1_/\t/' >> $LINE.lod.txt

cat $LINE/*lods.txt | grep -v snp  >> $LINE.lod.txt

echo -e 'pheno\tsnp\tlg\tcm\tlod\tp\ta\td\tse.a\tse.d\tthreshold' > $LINE.lodsAll.txt

cat $LINE/*lodsAll.txt | grep -v snp  >> $LINE.lodsAll.txt

awk '$5>$11 {print $0}' $LINE.lod.txt > $LINE.lod.sig.txt

python QTL.versus.gene.location.v3.py $LINE

grep -v Unknown CisTrans.$LINE.lod.sig.txt > CisTrans2.$LINE.lod.sig.txt
