#!/bin/bash
#SBATCH --job-name=bqtl2              # Job name
#SBATCH --partition=sixhour           # Partition Name (Required)
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2g                     # Job memory request
#SBATCH --time=00-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.out
#SBATCH --error=R-%x.%j.err

LINE=$1
#  
mkdir /panfs/pfs.local/scratch/kelly/p860v026/qtl/out/$LINE
cd /panfs/pfs.local/scratch/kelly/p860v026/qtl/out/$LINE

for i in $(cat ../../genes1.txt); do sbatch ~/code/runQTL_02.sh $LINE $i; done; sleep 40m && for i in $(cat ../../genes2.txt); do sbatch ~/code/runQTL_02.sh $LINE $i; done; sleep 40m && for i in $(cat ../../genes3.txt); do sbatch ~/code/runQTL_02.sh $LINE $i; done; sleep 40m && for i in $(cat ../../genes4.txt); do sbatch ~/code/runQTL_02.sh $LINE $i; done; sleep 40m && for i in $(cat ../../genes5.txt); do sbatch ~/code/runQTL_02.sh $LINE $i; done;


