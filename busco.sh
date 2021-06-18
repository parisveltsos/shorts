#!/bin/bash
#SBATCH --job-name=bus1034              # Job name
#SBATCH --partition=sixhour               # partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=1gb                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_busco_%j.log         # Standard output and error log

BUSCOSUPPORT=/home/p860v026/temp/bin/buscoSupport

GFOLDER=/home/p860v026/temp/IM1034/purge2/
# GNAME=1034.contigs.fasta
GNAME=1034purged2.fa

module load busco

# Part 1 install with write permissions
# mkdir -p $BUSCOSUPPORT
# cd $BUSCOSUPPORT
# wget https://busco-archive.ezlab.org/v3/datasets/embryophyta_odb9.tar.gz
# tar xvzf embryophyta_odb9.tar.gz
# rm embryophyta_odb9.tar.gz
# 
# a_path=`which augustus`             
# a_path=${a_path::${#a_path}-12}     
# a_path="${a_path}config"            
# mkdir -p $BUSCOSUPPORT/augustus     
# cp -r $a_path $BUSCOSUPPORT/augustus
# chmod 755 $BUSCOSUPPORT/augustus/config   

# 
# # Part 2 run busco
AUGUSTUS_CONFIG_PATH=$BUSCOSUPPORT/augustus/config 
cd $GFOLDER

run_BUSCO.py -i $GNAME -o busco_$GNAME -l $BUSCOSUPPORT/embryophyta_odb9 -m geno -c 8

# transcriptome
# run_BUSCO.py -i SEQUENCE_FILE -o OUTPUT_NAME -l LINEAGE -m tran
