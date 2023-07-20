#!/bin/bash
#SBATCH --job-name=svmu2b    # Job name
#SBATCH --partition=eeb,kucg,kelly           # Partition Name (Required)
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=8gb                     # Job memory request
#SBATCH --time=2-01:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log

module load mummer

source ~/code/svmu_00_setup.sh

cd $WFOLDER

lastz $REF_NAME\purged1.fa[multiple] $QUERY_NAME.fa[multiple] --chain --format=general:name1,strand1,start1,end1,name2,strand2,start2,end2 > $FOLDER_NAME\_lastz.txt