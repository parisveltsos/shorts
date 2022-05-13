#!/bin/bash -l
#SBATCH --job-name=LM1	    # Job name
#SBATCH --partition=sixhour
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=1Gb                     # Job memory request
#SBATCH --time=0-00:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log   # Standard output and error log

VCF=$1
LINE=$2

module load java

python ~/code/vcf_05_toLepmap.py $VCF $LINE

awk -f ~/code/transpose.sh $LINE.untransposed.linkage > $LINE.linkage

mkdir $LINE
rm $LINE.untransposed.linkage 
mv $LINE.linkage $LINE
mv $LINE.markerNames.txt $LINE
cd $LINE

		
awk -f ~/bin/lm3/LMscripts/linkage2post.awk $LINE.linkage | java -cp ~/bin/lm3/LMscripts Transpose > goodF2.post

# make call file

 #	java -cp ~/bin/lm3/bin ParentCall2 data=$LINE\ped.txt vcfFile=$LINE\clean.vcf removeNonInformative=1 > $LINE.call 

java -cp ~/bin/lm3/bin ParentCall2 data=goodF2.post removeNonInformative=1 > $LINE.call 

# remove non informative markers
java -cp ~/bin/lm3/bin Filtering2 data=$LINE.call dataTolerance=0.01 > $LINE\filt.call 

cat $LINE\filt.call | cut -f 1,2| awk '(NR>=7)' > $LINE\filtsnps.txt