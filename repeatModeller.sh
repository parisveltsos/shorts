#!/bin/bash
#SBATCH --job-name=rptModl                # Job name
#SBATCH --partition=eeb              # Partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=3gb                     # Job memory request
#SBATCH --time=5-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_bwa_%j.log         # Standard output and error log
 
module load repeatmodeler/2.0.1
module load repeatmasker/4.0.9

# Variables to change once per project
# <3 days for 767 with 12 cores

GNMFOLDER=/home/p860v026/temp/IM664/purge1
GENOME=664purged1.fa
WFOLDER=/home/p860v026/temp/repeatModeller
NAME=IM767

## PART 1 make database

## cp $GNMFOLDER/$GENOME $BWAFOLDER
# cd $WFOLDER
# mkdir $NAME
# cd $NAME
# cp $GNMFOLDER/$GENOME $GENOME
# 
# BuildDatabase -name $NAME $GENOME
# 
# RepeatModeler -database $NAME -LTRStruct -pa 12 

## if fail
## RepeatModeler -database $NAME -LTRStruct -pa 12 -recoverDir DIRNAME

## PART 2 - masking

# RepeatMasker -pa 12 -gff -lib $NAME-families.fa $GENOME



# PART A - JUST MASK A NEW GENOME WITH EXISTING DATABASE

cd $GNMFOLDER

RepeatMasker -pa 12 -gff -lib $WFOLDER/$NAME/$NAME-families.fa $GENOME

# http://avrilomics.blogspot.com/2015/02/finding-repeats-using-repeatmodeler.html