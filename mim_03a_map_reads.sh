#!/bin/bash -l
#SBATCH --job-name=Mim03a	    # Job name
#SBATCH --partition=sixhour # Partition Name (Required) sixhour kelly
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=8
#SBATCH --mem=12Gb                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log   # Standard output and error log

source ~/code/mim_setup.sh

## MAP TRIMMED READS

### RUN ONCE PER READ BY GENOME COMBINATION (7Gb memory for parent, 8 cpu, 50 min)
### MAKE LIST OF FILES FOR PARALLEL WORK 
# cd ~/code 
#  ls -laSh /panfs/pfs.local/scratch/kelly/p860v026/3prime/trimmed > list6hr
#  vim list6hr     
	# split to listjk >3Gb and list6hr
	# make listest to try everything works before submitting big job
#  cd mapped_to_$GENOMENAME
#  for i in $(cat list6hr); do sbatch ~/code/mim_03a_map_reads.sh $i; done
#  for i in $(cat listjk); do sbatch ~/code/mim_03b_map_reads.sh $i; done



module load java
module load samtools

SMALLNAME=$(perl -pe 's/.fastq.gz//' <(echo $1))

 # echo $SMALLNAME

cd $OUTFOLDER
mkdir mapped_to_$GENOMENAME

$STAREXEC --runThreadN 8 --genomeDir ./$STARGENOMEFOLDER/ --readFilesCommand zcat --readFilesIn $TRIMMEDFOLDER/$1 --outFilterType BySJout --outFilterMultimapNmax 20 --alignSJoverhangMin 8 --alignSJDBoverhangMin 1 --outFilterMismatchNmax 999 --outFilterMismatchNoverLmax 0.1 --alignIntronMin 20  --alignIntronMax 1000000 --alignMatesGapMax 1000000 --outSAMattributes NH HI NM MD --outSAMtype BAM SortedByCoordinate --outFileNamePrefix ./mapped_to_$GENOMENAME/$SMALLNAME

cd mapped_to_$GENOMENAME
mkdir infoFiles
mv $SMALLNAME\Aligned.sortedByCoord.out.bam $SMALLNAME.bam
samtools index $SMALLNAME.bam
rm -rf $SMALLNAME\_STARtmp 
mv $SMALLNAME*out* infoFiles
cd ..



# Once run CHECK NO EMPTY BAMS PRODUCED

 # source ~/code/mim_setup.sh
 # cd $OUTFOLDER/mapped_to_$GENOMENAME
 # ls -lSh *bam | tail

 # find . -name '*.txt' -size 0 | sed 's/^..//g ; s/listempty.txt//g' | grep counts | sort > listempty.txt
