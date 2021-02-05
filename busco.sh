#!/bin/bash
#SBATCH --job-name=busco               # Job name
#SBATCH --partition=sixhour               # partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=1gb                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_busco_%j.log         # Standard output and error log

BUSCOSUPPORT=/home/p860v026/temp/bin/buscoSupport

GFOLDER=/home/p860v026/temp/pacbio/r64060_20201112_192654/1_A01/canu541
GNAME=541.contigs.fasta

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

# results
# C:91.6%[S:87.4%,D:4.2%],F:2.8%,M:5.6%,n:1440  V2
# C:92.0%[S:87.5%,D:4.5%],F:1.5%,M:6.5%,n:1440	V5
# C:88.8%[S:77.3%,D:11.5%],F:2.6%,M:8.6%,n:1440	canu62
# C:88.7%[S:70.9%,D:17.8%],F:2.9%,M:8.4%,n:1440 canu767
# C:93.8%[S:89.7%,D:4.1%],F:1.5%,M:4.7%,n:1440 541