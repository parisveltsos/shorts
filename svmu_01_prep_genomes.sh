#!/bin/bash
#SBATCH --job-name=svmu1    # Job name
#SBATCH --partition=sixhour #eeb,kucg,kelly           # Partition Name (Required)
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=2gb                     # Job memory request
#SBATCH --time=00-00:50:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log

source ~/code/svmu_00_setup.sh

mkdir $WFOLDER
cd $WFOLDER

# copy reference genome
cp /panfs/pfs.local/work/kelly/p860v026/Final.builds/purge1/$REF_NAME\purged1.fa .

# generate contig query from contig and query genome name
grep -A 1 $TIG_NAME /panfs/pfs.local/work/kelly/p860v026/Final.builds/purge1/$QGENOME_NAME\purged1.fa > $QUERY_NAME.fa

