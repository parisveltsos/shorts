#!/bin/bash
#SBATCH --job-name=flo
#SBATCH --partition=eeb
#SBATCH --time=1-05:59:00        
#SBATCH --mem-per-cpu=20g
#SBATCH --mail-user=pveltsos@ku.edu
#SBATCH --ntasks=1             
#SBATCH --cpus-per-task=10
#SBATCH --output=flo.log

cd /panfs/pfs.local/scratch/kelly/p860v026/bin/flo/flo_mimulus

# This script generates chain file and transfers gff to new genome
# need to edit /home/p860v026/temp/bin/flo/flo_mimulus/flo_opts.yaml before running.
# Also delete the run folder if it exists in /home/p860v026/temp/bin/flo/flo_mimulus 
# Also edit NAME below


rake -f Rakefile

NAME=767_p1
GFFNAME=MguttatusTOL_551_v5.0.gene

cd run

mv liftover.chn $NAME.chn

gzip $NAME.chn

cd $GFFNAME

ruby ../../gff_recover.rb lifted.gff3 > $NAME\lifted_cleaned.gff 2>$NAME\lifted_rubbish.gff

perl -pe 's/mRNA/gene/g ; s/...v5.0//g' $NAME\lifted_cleaned.gff > $NAME\lifted_cleaned_mRNAtoGene2.gff

grep gene $NAME\lifted_cleaned_mRNAtoGene2.gff | awk '{print $9}' | perl -pe 's/\;.+//g ; s/ID\=//g' | uniq > $NAME\_lifted_names.txt

cd ..

mv $GFFNAME $NAME\_gff

tar -zcvf $NAME\_gff.tar.gz $NAME\_gff/

cp *.gz ../results/

cd ..

# rm -rf run/