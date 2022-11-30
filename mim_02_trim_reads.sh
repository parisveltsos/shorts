#!/bin/bash -l
#SBATCH --job-name=mim02	    # Job name
#SBATCH --partition=sixhour,kelly,eeb,kucg # Partition Name (Required) sixhour kelly
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=2Gb                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log   # Standard output and error log

source ~/code/mim_setup.sh


## TRIM READS - RUN ONCE PER READ FILE

### hard code sequencing run name in line 28

### Prepare list of untrimmed filenames so that the job can be run in parallel
 #  cd ~/code 
 #  ls -laSh /panfs/pfs.local/scratch/kelly/p860v026/3prime/reads > list6hr
 #  vim list6hr
	# edit to just the filenames
 #  for i in $(cat list6hr); do sbatch ~/code/mim_02_trim_reads.sh $i; done

module load java
module load samtools

TRIMMEDNAME=$(perl -pe 's/_.+gz// ; s/^/s3_/' <(echo $1))

cd $OUTFOLDER
mkdir trimmed_$RNANAME
$BBMAPFOLDER/bbduk.sh in=./$RNANAME\_reads/$1 out=./trimmed_$RNANAME/$TRIMMEDNAME ref=$BBMAPFOLDER/resources/truseq_rna.fa.gz,$BBMAPFOLDER/resources/polyA.fa.gz k=13 ktrim=r useshortkmers=t mink=5 qtrim=r trimq=10 minlength=20
cd trimmed_$RNANAME
gzip $TRIMMEDNAME
