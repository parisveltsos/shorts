#!/bin/bash
#SBATCH --job-name=syri2    # Job name
#SBATCH --partition=sixhour,eeb,kucg,kelly           # Partition Name (Required)
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=32                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=10gb                     # Job memory request
#SBATCH --time=0-01:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log

module load mummer/4.0.0rc1
# module load python

source ~/code/syri_00_setup.sh

cd $WFOLDER

nucmer --maxmatch -c 100 -b 500 -l 2000 -t 16 -p out1 767pseudoChr3.fa $QNAME\_longest50.fa


# -l min exact match length
# -t cores
# -b extension length before giving up 
# -c min cluster length of matches


delta-filter -m -i 90 -l 100 out1.delta > out1.filtered.delta     # Remove small and lower quality alignments
# -m many tomany allowing rearrangements
# -i min algn identity
# -l min algn length

show-coords -THrd out1.filtered.delta > out1.filtered.coords      # Convert alignment information to a .TSV format as required by SyRI
# -T tab delimit
# -H no header
# -r sort by reference ID and coordinates
# -d display alignment direction

