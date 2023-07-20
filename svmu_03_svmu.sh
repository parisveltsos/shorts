#!/bin/bash
#SBATCH --job-name=svmu3    # Job name
#SBATCH --partition=sixhour           # Partition Name (Required)
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=8gb                     # Job memory request
#SBATCH --time=0-01:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log

module load mummer

source ~/code/svmu_00_setup.sh

cd $WFOLDER

svmu $FOLDER_NAME.delta $REF_NAME\purged1.fa $QUERY_NAME.fa snp_mode=h $FOLDER_NAME\_lastz.txt $FOLDER_NAME\_svmu_out