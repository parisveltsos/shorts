#!/bin/bash
#SBATCH --job-name=gzip              # Job name
#SBATCH --partition=sixhour           # Partition Name (Required)
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1gb                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=gzip_%j.log         # Standard output and error log

echo "Running"
 
cd /home/p860v026/work 
pwd; hostname; date

# gzip JKK-LVR_MPS12342939_D10_7687_S1_L002_R2_001.fastq
# gzip JKK-LVR_MPS12342939_D10_7687_S1_L002_R1_001.fastq
# tar -zcf supernovaShort.tar.gz JKK-LVR3/ 

cp -r /home/p860v026/work/Mimulus_tilingii_10x/* /home/p860v026/temp/Mimulus_tilingii_10x/
cp -r /home/p860v026/work/pacbio/* /home/p860v026/temp/pacbio/
cp -r /home/p860v026/work/tolpis_coronop/* /home/p860v026/temp/tolpis_coronop/


date

