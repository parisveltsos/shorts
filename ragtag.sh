#!/bin/bash
#SBATCH --job-name=ragtag                # Job name
#SBATCH --partition=eeb               # Partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=32gb                     # Job memory request
#SBATCH --time=1-23:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_ragtag_%j.log         # Standard output and error log

echo "Running"

cd /home/p860v026/temp/Mgut_Mtil

	module load python

#	python /home/p860v026/.local/bin/ragtag.py correct MgutatChr1013.fasta tilingii_positive.fasta -o ./out_ragtag_reads -R /home/p860v026/temp/reads/JKK-LVR_MPS12342939_D10_7687_S1_L002_R2_001.fastq.gz -T sr
	python /home/p860v026/.local/bin/ragtag.py correct MgutatChr1013.fasta tilingii_positive.fasta -o ./out_ragtag_simplex


date

