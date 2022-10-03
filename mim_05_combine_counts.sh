#!/bin/bash -l
#SBATCH --job-name=Mim05	    # Job name
#SBATCH --partition=sixhour # Partition Name (Required) sixhour kelly
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=8Gb                     # Job memory request
#SBATCH --time=0-04:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log   # Standard output and error log

source ~/code/mim_setup.sh


## MERGE COUNTS
cd $OUTFOLDER/$RNANAME\_counts_to_$GENOMENAME


cd $OUTFOLDER
mkdir temp_count

# add filenames in first line
cd $RNANAME\_counts_to_$GENOMENAME
for i in *.txt ; do echo -e "gene\t$i" | cat - $i > temp_count && mv temp_count $i; done

# add counts per file 
for i in $(ls | perl -pe 's/counts\///'); do cut -f2 $i > ../temp_count/$i; done

# add rownames from first file
for i in $(ls | perl -pe 's/counts\///' | head -1); do cut -f1 $i > ../temp_count/0count.txt; done

cd ..

# The following combines columns, simplifies names, removes last 5 rows with summary information

# May need to first change max file limit for session 

ulimit -n 2000

paste temp_count/*.txt | perl -pe 's/_counts.txt//g' | head -n -5 > $RNANAME\_$GENOMENAME\_final_count.txt

rm -rf temp_count

