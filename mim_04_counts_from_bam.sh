#!/bin/bash -l
#SBATCH --job-name=Mim04	    # Job name
#SBATCH --partition=sixhour # Partition Name (Required) sixhour kelly
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=8
#SBATCH --mem=8Gb                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log   # Standard output and error log

source ~/code/mim_setup.sh



## GENERATE COUNTS FROM BAMs

### MAKE LIST OF FILES FOR PARALLEL WORK 
# cd ~/code 
#  ls -laSh /home/p860v026/temp/trimmed > list6hr
#  vim list6hr     
	# make listest to try everything works before submitting big job
#  for i in $(cat listredo); do sbatch ~/code/mim_04_counts_from_bam.sh $i; done

SMALLNAME=$(perl -pe 's/.fastq.gz//' <(echo $1))

 # echo $SMALLNAME
# module load python
cd $OUTFOLDER

mkdir counts_to_$GENOMENAME

$HTSEQFOLDER/htseq-count -m intersection-nonempty -s yes -f bam -r pos -t gene -i ID ./mapped_to_$GENOMENAME/$SMALLNAME.bam $GFFFOLDER/$GFFFILE > ./counts_to_$GENOMENAME/$SMALLNAME\_counts.txt



## MERGE COUNTS
# cd $OUTFOLDER/counts_to_$GENOMENAME

# Empty files 
# s4_541-96_counts.txt
# s4_237-69_counts.txt
# s6_444-124_counts.txt

## RESET COUNT FILES 

# for i in $(ls *counts.txt); do grep -v gene $i > $i.temp; mv $i.temp $i; done


## COMBINE ALL COUNTS

#  cd $OUTFOLDER
# mkdir temp_count
# 
# filenames in first line
# cd counts_to_$GENOMENAME
# for i in *.txt ; do echo -e "gene\t$i" | cat - $i > temp_count && mv temp_count $i; done
# 
# counts per file 
# for i in $(ls | perl -pe 's/counts\///'); do cut -f2 $i > ../temp_count/$i; done
# 
# rownames from first file
# for i in $(ls | perl -pe 's/counts\///' | head -1); do cut -f1 $i > ../temp_count/0count.txt; done
# cd ..
# 
# combine columns, simplify names, remove last 5 rows with summary
# 
# May need to first change max file limit for session 
# 
# ulimit -n 2000
# 
# paste temp_count/*.txt | perl -pe 's/_counts.txt//g' | head -n -5 > $GENOMENAME\_final_count.txt
# rm -rf temp_count
# 
# make matrix, count and design files

