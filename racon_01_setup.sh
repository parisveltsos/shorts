#!/bin/bash -l
#SBATCH --job-name=rcn1_767	    # Job name
#SBATCH --partition=eeb # Partition Name (Required) sixhour kelly
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=4Gb                     # Job memory request
#SBATCH --time=2-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log   # Standard output and error log

module load bwa

GNAME=$1
RACONDIR=/home/p860v026/temp/racon/$GNAME

mkdir $RACONDIR
 
# # Index genome
cp /panfs/pfs.local/work/kelly/p860v026/Final.builds/$GNAME\purged1.fa.gz $RACONDIR

cd $RACONDIR
 
gunzip $GNAME\purged1.fa.gz
 
bwa index $GNAME\purged1.fa
 
cd /home/p860v026/temp/illuminaGenomeReads

# OPTION 1 (237, 444, 541, 1034)
# Give unique names to paired reads, combine in single file 
# 
# gunzip *$GNAME*
#  
# python ~/code/unique_readNames_for_racon.py ss.$GNAME.R1.fq ss.$GNAME.R2.fq > $RACONDIR/$GNAME.reads.fq
# 
# gzip *$GNAME*.fq


# OPTION 2 (502, 909, 1192)
# Give unique names to paired reads, combine in single file 
# 
# gunzip *$GNAME*
#  
# python ~/code/unique_readNames_for_racon.py *$GNAME*L001_R1* *$GNAME*L001_R2* > $GNAME.readsL001.fq
# 
# python ~/code/unique_readNames_for_racon.py *$GNAME*L002_R1* *$GNAME*L002_R2* > $GNAME.readsL002.fq
# 
# cat $GNAME.readsL00* > $RACONDIR/$GNAME.reads.fq
# 
# rm $GNAME.readsL00*
# 
# gzip *$GNAME*.fastq


# OPTION 3 (664)
# Give unique names to paired reads, combine in single file 
# 
# gunzip *$GNAME*
#  
# python ~/code/unique_readNames_for_racon.py *$GNAME*L001_R1* *$GNAME*L001_R2* > $GNAME.readsL001.fq
# 
# python ~/code/unique_readNames_for_racon.py *$GNAME*L002_R1* *$GNAME*L002_R2* > $GNAME.readsL002.fq
# 
# python ~/code/unique_readNames_for_racon.py *$GNAME*L003_R1* *$GNAME*L003_R2* > $GNAME.readsL003.fq
# 
# python ~/code/unique_readNames_for_racon.py *$GNAME*L004_R1* *$GNAME*L004_R2* > $GNAME.readsL004.fq
# 
# cat $GNAME.readsL00* > $RACONDIR/$GNAME.reads.fq
# 
# rm $GNAME.readsL00*
# 
# gzip *$GNAME*


# If not needed, unzip to racon directory (62, 155, 767)
gunzip -c *$GNAME* > $RACONDIR/$GNAME.reads.fq
# 


# split -l 149767685 155.reads.fq
# grep @ 155.reads.fq > out.txt
# grep " 2 " out.txt | perl -pe 's/.+@/@/' > 2list
# grep " 1 " out.txt | perl -pe 's/.+@/@/' > 1list
# for i in $(cat 1list); do grep -m1 -A3 $i 155.reads.fq >> 155.1.reads.fq; done
# split -l 1000000 2list

# RUN WITH  for i in $(ls x*); do sbatch ~/code/racon_01_setup.sh 155 $i; done
# for i in $(cat $LIST); do grep -m1 -A3 $i 155.reads.fq >> 155.2$LIST.reads.fq; done
# for i in $(cat 2list); do grep -m2 -A3 $i 155.reads.fq >> 155.22.reads.fq; done

# cat 155.2* > 155reads2.fq