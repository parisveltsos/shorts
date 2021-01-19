#!/bin/bash
#SBATCH --job-name=blast              # Job name
#SBATCH --partition=sixhour           # Partition Name (Required)
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4g                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=blast_%j.log         # Standard output and error log

echo "Running"
 
WORKFOLDER=/home/p860v026/temp/driver
GENOMEFOLDER=/home/p860v026/temp/Mgutv5/assembly
GENOME=MguttatusTOL_551_v5.0.fa
QUERY=drive.seqs.v2build.fasta 

module load blast+

cd $GENOMEFOLDER

makeblastdb -in $GENOME -dbtype nucl

cd $WORKFOLDER

blastn -query $QUERY -db $GENOMEFOLDER/$GENOME -outfmt 6 -num_threads 8 > $QUERY\_$GENOME\_blastn.out

~/code/blast2gff.sh $QUERY\_$GENOME\_blastn.out 



