#!/bin/bash
#SBATCH --job-name=invPlot2              # Job name
#SBATCH --partition=sixhour           # Partition Name (Required)
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1g                     # Job memory request
#SBATCH --time=00-01:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.out
#SBATCH --error=R-%x.%j.err


# sbatch ~/code/invPlot.sh tig00000708_1 1987519 2066816 2252813 2310963 NA NA INV8sa 237

module load R

CONTIG=$1
EXT1=$2
INT1=$3
INT2=$4
EXT2=$5
GENE1=$6
GENE2=$7
NOTE=$8

cd /panfs/pfs.local/scratch/kelly/p860v026/minimap/$NOTE

paste <(cut -f2 rule1*155*) <(cut -f1 rule1*155*) <(cut -f1 rule1*237*) <(cut -f1 rule1*444*) <(cut -f1 rule1*502*) <(cut -f1 rule1*541*) <(cut -f1 rule1*664*) <(cut -f1 rule1*767*) <(cut -f1 rule1*909*) <(cut -f1 rule1*1034*) <(cut -f1 rule1*1192*) > rule1.txt

Rscript ~/code/invPlot2.r $CONTIG $EXT1 $INT1 $INT2 $EXT2 $GENE1 $GENE2 $NOTE

	tar -zcvf $NOTE.tar.gz rule?????