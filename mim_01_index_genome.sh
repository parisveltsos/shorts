#!/bin/bash -l
#SBATCH --job-name=Mim01	    # Job name
#SBATCH --partition=sixhour # Partition Name (Required) sixhour kelly
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=8
#SBATCH --mem=20Gb                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log   # Standard output and error log

source ~/code/mim_setup.sh

## PREP GENOME 

### RUN ONCE PER GENOME 
### 5 min 20 Gb

cd $OUTFOLDER
mkdir $STARGENOMEFOLDER
 
# generate genome index
$STAREXEC --runThreadN 8 --runMode genomeGenerate --genomeDir ./$STARGENOMEFOLDER/ --genomeFastaFiles $GENOMEFOLDER/$GENOMEFILE --sjdbGTFtagExonParentTranscript Parent --genomeSAindexNbases 12
# $STAREXEC --runThreadN 8 --runMode genomeGenerate --genomeDir ./$STARGENOMEFOLDER/ --genomeFastaFiles $GENOMEFOLDER/$GENOMEFILE --sjdbGTFfile $GFFFOLDER/$GFFFILE --sjdbGTFtagExonParentTranscript Parent --sjdbOverhang 74 --genomeSAindexNbases 13

