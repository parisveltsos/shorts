#!/bin/bash -l
#SBATCH --job-name=LM2	    # Job name
#SBATCH --partition=sixhour
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=1Gb                     # Job memory request
#SBATCH --time=0-02:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log   # Standard output and error log

LINE=$1
LOD=$2

module load java

# separate chromosomes

java -cp ~/bin/lm3/bin SeparateChromosomes2 data=$LINE\filt.call lodLimit=$LOD > $LINE\map$LOD.txt

sort $LINE\map$LOD.txt | uniq -c | sort -n > $LINE\_lod$LOD\_lgs.txt

tail -20 $LINE\_lod$LOD\_lgs.txt
