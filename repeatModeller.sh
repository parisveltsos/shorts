#!/bin/bash
#SBATCH --job-name=rptModl                # Job name
#SBATCH --partition=eeb,kucg,kelly              # Partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=3gb                     # Job memory request
#SBATCH --time=5-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log
 
module load repeatmodeler/2.0.1
# module load repeatmasker/4.1.2
module load repeatmasker/4.0.9
# module load hmmer/3.2.1

# Variables to change once per project
# <3 days for 767 with 12 cores

RFOLDER=/panfs/pfs.local/work/kelly/p860v026/longReads/
GFOLDER=/panfs/pfs.local/work/kelly/p860v026/Final.builds/IM62/
WFOLDER=/panfs/pfs.local/scratch/kelly/p860v026/repeatMasker/

DBNAME=IM62.db
GENOME=Mimulus_guttatus_var_IM62.mainGenome.fasta
RNAME=664

## PART 1 make database

# cp $GFOLDER/$GENOME $WFOLDER

cd $WFOLDER

# BuildDatabase -name $DBNAME $GENOME
 
# RepeatModeler -database $DBNAME -LTRStruct -pa 12 

# perl -pe 's/m64060/\>m64060/ ; s/    /\n/' families2.stk > families3.stk
# perl -pe 's/$/_$seen{$_}/ if ++$seen{$_}>1 and /^/; ' families3.stk | perl -pe 's/\n/    /g ; s/\>/\n\>/g' > families4.stk

# hmmbuild test.hmm $DBNAME-families.stk

# hmmbuild --cpu 12 test.hmm fixed.IM62.db-families.stk
 
 
## if fail
# RepeatModeler -database $NAME -LTRStruct -pa 12 -recoverDir RM_7012.FriJan130821012023


## PART 2 - masking

# split to < 4Gb files otherwise blast database made by BuildDatabase crashes

# split -d -a2 -l500000 --additional-suffix=.fasta $RFOLDER/$RNAME.fasta $RNAME\split.


# RepeatMasker -pa 12 -gff -species arabidopsis Mimulus_guttatus_var_IM62.mainGenome.fasta
# RepeatMasker -pa 12 -gff -lib test.hmm Mimulus_guttatus_var_IM62.mainGenome.fasta
# RepeatMasker -pa 12 -s -gff -lib IM62.db-families.fa Mimulus_guttatus_var_IM62.mainGenome.fasta
RepeatMasker -pa 12 -s -gff -lib /panfs/pfs.local/work/kelly/p860v026/Final.builds/IM62/Mimulus_guttatus_var_IM62.repeat.fasta Mimulus_guttatus_var_IM62.mainGenome.fasta



# PART A - JUST MASK A NEW GENOME WITH EXISTING DATABASE

# cd $GFOLDER

# RepeatMasker -e hmmer -pa 12 -gff -lib /panfs/pfs.local/work/kelly/p860v026/genomes/v2.0/assembly/TEs.fasta $GENOME

# RepeatMasker -e hmmer -pa 12 -gff -lib /panfs/pfs.local/work/kelly/p860v026/repeatLib.fa $GENOME

# http://avrilomics.blogspot.com/2015/02/finding-repeats-using-repeatmodeler.html
