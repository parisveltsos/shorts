#!/bin/bash
#SBATCH --job-name=syri3    # Job name
#SBATCH --partition=sixhour,eeb,kucg,kelly           # Partition Name (Required)
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=4gb                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log

source ~/code/syri_00_setup.sh

cd $WFOLDER

conda activate syri_env

python3 /home/p860v026/bin/syri/syri/syri/bin/chroder out1.filtered.coords 767pseudoChr3.fa $QNAME\_longest50.fa
