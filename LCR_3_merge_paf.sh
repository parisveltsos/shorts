#!/bin/bash
#SBATCH --job-name=LCR3      # Job name
#SBATCH --partition=sixhour
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=2Gb                     # Job memory request
#SBATCH --time=0-03:59:00             # Time limit days-hrs:min:s
#SBATCH --output=R-%x.%j.log   # Standard output and error log

source ~/code/LCR_0_setup.sh

cd $TEMP_FOLDER/$WDIR

cut -f 1-16 $QREADS_NAME\split*paf > $QREADS_NAME.paf