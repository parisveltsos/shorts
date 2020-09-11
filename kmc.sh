#!/bin/bash
#SBATCH --job-name=kmc                # Job name
#SBATCH --partition=sixhour               # Partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH -n 16                          # Run on a single CPU
#SBATCH -N 16
#SBATCH --mem=16gb                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_kmc_%j.log         # Standard output and error log

echo "Running"

# cd /home/p860v026/scratch/kmer/Tolpis_coronop/Run1
cd /home/p860v026/temp

## PART 1 - count kmers - 16 cpu 16 memory sixhour queue - 45 min run
# this uses hard disk space instead of memory so it is best to work on the temp drive.

# mkdir tmp
# ls *.fastq.gz > FILES
pwd; hostname; date

kmc -k21 -t16 -m16 -ci1 -cs1000000 @FILES kmcdb4 tmp

kmc_tools transform kmcdb4 histogram kmcdb4_k21.hist -cx1000000

## PART 2 genomescope - 

module load R

genomescope.R -i kmcdb4_k21.hist -k 21 -p 2 -l 10 -o genomescope_kmcdb4_k21_l10

tar -zcvf genomescope_kmcdb4_k21_l10.tar.gz genomescope_kmcdb4_k21_l10
	
## PART 3 smudgeplot - 1 cpu 300 Mb memory eeb queue 12:30 hr runtime

# module load python
# module load R
# 
# L=$(smudgeplot.py cutoff kmcdb4_k21.hist L)
# U=$(smudgeplot.py cutoff kmcdb4_k21.hist U)
# echo $L $U # these need to be sane values
# 
# # kmc_tools transform kmcdb3 -ci"$L" -cx"$U" dump -s kmcdb_L"$L"_U"$U".dump
# smudgeplot.py hetkmers -o kmcdb_L"$L"_U"$U" < kmcdb_L"$L"_U"$U".dump
# 
# smudgeplot.py plot kmcdb_L"$L"_U"$U"_coverages.tsv
# 
# tar -zcvf smudgeplot_kmcdb4_k21.tar.gz smudgeplot_*

date

