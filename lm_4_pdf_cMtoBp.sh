#!/bin/bash -l
#SBATCH --job-name=LM4	    # Job name
#SBATCH --partition=sixhour
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=2Gb                     # Job memory request
#SBATCH --time=0-01:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log   # Standard output and error log

LINE=$1
LOD=$2
LG=$3

awk -vFS="\t" -vOFS="\t" '(NR==FNR){s[NR-1]=$0}(NR!=FNR){if ($1 in s) $1=s[$1];print}' $LINE\filtsnps.txt $LINE\order$LOD.txt > $LINE\order$LOD.mapped

# Make cm file
cut -f 1,2 $LINE\order$LOD.txt | grep -v '#' > temp_cm.txt
python ~/code/makeCM.py temp_cm.txt
	
# Merge files to make bpcmData
 
cat <(echo -e 'snp\tlg\tcm\tcontig\tbp') <(join  -1 2 -2 1 <(sort -k2 out_temp_cm.txt) <(sort $LINE.markerNames.txt) ) | sort  -k 2 -nk 3 > $LINE\_$LOD\_bpcmData.txt

# Make pheno data
awk -f ~/code/transpose.sh ../normcounts.txt | head -1 | perl -pe 's/\t/,/g' > $LINE.phenotypes.txt

join -1 1 -2 1 <(awk -f ~/code/transpose.sh ../normcounts.txt | perl -pe 's/\./-/' | sort) <(sort temp_F2names.txt) | perl -pe 's/gene/id/ ; s/ /,/g' >> $LINE.phenotypes.txt


# Make geno data

cut -f2 $LINE.linkage | tail -n +3 > temp_F2names.txt

awk '{print $4, "_", $5, "\t", $2, "\t", $3, OFS=""}' $LINE\_$LOD\_bpcmData.txt | perl -pe 's/contig_bp.+/id\t\t/' | awk -f ~/code/transpose.sh | perl -pe 's/\t/,/g' > $LINE.genotypes_temp.txt

paste temp_F2names.txt <(awk -vfullData=1 -f ~/bin/lm3/LMscripts/map2genotypes.awk $LINE\order$LOD.txt | awk -f ~/code/transpose.sh  | tail -n +7 | cut -f 7-10000 | perl -pe 's/1 1/A/g ; s/2 2/B/g ; s/1 2/H/g ; s/2 1/H/g') | perl -pe 's/\t/,/g' >> $LINE.genotypes_temp.txt

head -3 $LINE.genotypes.txt > $LINE.head.geno_temp.txt

# make $LINE.lginfo from pdfs
# Rscript ~/code/qtl_01_reorder_map.r $LINE
# edit manually in Excel if needed
# transpose,  tabs to comma, upload

cat $LINE.newhead.geno.txt <(tail -n +4 $LINE.genotypes_temp.txt) | perl -pe 's/\t/,/g' | awk -f ~/code/transpose.sh | sort -nk 2 -nk 3 | awk -f ~/code/transpose.sh | perl -pe 's/\t/,/g' > $LINE.genotypes.txt


# Make plot
	
module load R
Rscript ~/code/bpcmPlot.r $LINE $LOD $LG

## compress for export 

tar -zcvf lgs$LINE\_$LOD.tar.gz *.pdf *order*txt *bpcmData.txt

