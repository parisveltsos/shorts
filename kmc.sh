#!/bin/bash
#SBATCH --job-name=kmc                # Job name
#SBATCH --partition=eeb               # Partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=400gb                     # Job memory request
#SBATCH --time=2-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_kmc_%j.log         # Standard output and error log

echo "Running"

cd /home/p860v026/temp/kmer

## PART 1 - count kmers - 16 cpu 16 memory sixhour queue - 45 min run
# this uses hard disk space instead of memory so it is best to work on the temp drive.

# mkdir tmp
# ls *.fastq.gz > FILES
# pwd; hostname; date
# 
# kmc -k21 -t16 -m4 -ci1 -fm -cs1000000 @FILES kmc_Mtilingii tmp
# 
# kmc_tools transform kmc_Mtilingii histogram kmc_Mtilingii_k21.hist -cx1000000

## PART 2 genomescope - 

# module load R
# 
# genomescope.R -i kmc_Mtilingii_k21.hist -k 21 -p 2 -o genomescope_kmc_Mtilingii_k21_l10
# 
# tar -zcvf genomescope_kmc_Mtilingii_k21_l10.tar.gz genomescope_kmc_Mtilingii_k21_l10
	
## PART 3 smudgeplot - 1 cpu 300 Mb memory eeb queue 12:30 hr runtime

module load python
module load R

L=$(smudgeplot.py cutoff kmc_Mtilingii_k21.hist L)
U=$(smudgeplot.py cutoff kmc_Mtilingii_k21.hist U)
echo $L $U # these need to be sane values

kmc_tools transform kmc_Mtilingii -ci"$L" -cx"$U" dump -s kmc_Mtilingii_L"$L"_U"$U".dump
smudgeplot.py hetkmers -o kmc_Mtilingii_L"$L"_U"$U" < kmc_Mtilingii_L"$L"_U"$U".dump

smudgeplot.py plot kmc_Mtilingii_L"$L"_U"$U"_coverages.tsv

tar -zcvf smudgeplot_kmc_Mtilingii_k21.tar.gz smudgeplot_*

date

