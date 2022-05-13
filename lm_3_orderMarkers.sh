#!/bin/bash -l
#SBATCH --job-name=LM3	    # Job name
#SBATCH --partition=sixhour
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=2Gb                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log   # Standard output and error log

LINE=$1
LOD=$2

module load java

java -cp ~/bin/lm3/bin OrderMarkers2 sexAveraged=1 data=$LINE\filt.call map= $LINE\map$LOD.txt > $LINE\order$LOD.txt 
