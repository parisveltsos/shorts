#!/bin/bash
#SBATCH --job-name=syri5    # Job name
#SBATCH --partition=sixhour,eeb,kucg,kelly           # Partition Name (Required)
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=4gb                     # Job memory request
#SBATCH --time=0-01:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log

source ~/code/syri_00_setup.sh

cd $WFOLDER

module load python

conda activate /panfs/pfs.local/scratch/kelly/p860v026/conda/envs/syri5

python3 /home/p860v026/bin/syri/syri/syri/bin/syri --nosnp -c out5.filtered.coords -d out5.filtered.delta -r 62_chr11.fa -q 767_804.fa


# python3 /home/p860v026/bin/syri/syri/syri/bin/syri --nosnp -c out1.filtered.coords -d out1.filtered.delta -r 767pseudoChr3.fa -q 62_longest50.fa

python3 /home/p860v026/bin/syri/syri/syri/bin/plotsr syri.out 62_chr11.fa 767_804.fa -H 8 -W 5

