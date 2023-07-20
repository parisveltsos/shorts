#!/bin/bash
#SBATCH --job-name=svmu2a    # Job name
#SBATCH --partition=sixhour,eeb,kucg,kelly           # Partition Name (Required)
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=12				# Change this
#SBATCH --mem=14gb                     # Job memory request
#SBATCH --time=0-01:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log

module load mummer

source ~/code/svmu_00_setup.sh

cd $WFOLDER

nucmer --threads 12 --prefix $FOLDER_NAME $REF_NAME\purged1.fa $QUERY_NAME.fa

