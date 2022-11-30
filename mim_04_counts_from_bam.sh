#!/bin/bash -l
#SBATCH --job-name=Mim04	    # Job name
#SBATCH --partition=sixhour,kelly,kucg,eeb
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=2
#SBATCH --mem=4Gb                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log   # Standard output and error log

source ~/code/mim_setup.sh



## GENERATE COUNTS FROM BAMs

### MAKE LIST OF FILES FOR PARALLEL WORK 
# cd ~/code 
#  ls -laSh /panfs/pfs.local/scratch/kelly/p860v026/3prime/trimmed > list6hr
#  vim list6hr     
	# make listest to try everything works before submitting big job
#  for i in $(cat list6hr); do sbatch ~/code/mim_04_counts_from_bam.sh $i; done

SMALLNAME=$(perl -pe 's/.fastq.gz//' <(echo $1))

 # echo $SMALLNAME
# module load python
cd $OUTFOLDER

mkdir $RNANAME\_counts_to_$GENOMENAME

$HTSEQFOLDER/htseq-count -m intersection-nonempty -s yes -f bam -r pos -t gene -i ID /home/jkk/scratch/PANFS-RESEARCH-JKKELLY/STAR_mapping/v5bams/$SMALLNAME.Aligned.sortedByCoord.out.bam $GFFFOLDER/$GFFFILE > ./$RNANAME\_counts_to_$GENOMENAME/$SMALLNAME\_counts.txt

# $HTSEQFOLDER/htseq-count -m intersection-nonempty -s yes -f bam -r pos -t gene -i ID ./$RNANAME\_mapped_to_$GENOMENAME/$SMALLNAME.bam $GFFFOLDER/$GFFFILE > ./$RNANAME\_counts_to_$GENOMENAME/$SMALLNAME\_counts.txt

