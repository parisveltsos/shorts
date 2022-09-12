#!/bin/bash
#SBATCH --job-name=bus1192              # Job name
#SBATCH --partition=sixhour               # partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=1gb                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_busco_%j.log         # Standard output and error log

BUSCOSUPPORT=/panfs/pfs.local/scratch/kelly/p860v026/bin/buscoSupport

# GFOLDER=/temp/30day/kelly/p860v026/IM1192/purge1
GFOLDER=/panfs/pfs.local/work/kelly/p860v026/Final.builds
# GNAME=1192.contigs.fasta 
GNAME=Mimulus_guttatus_IM767.raconPolished.contigs.fasta

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
