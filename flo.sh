#!/bin/bash
#SBATCH --job-name=flo
#SBATCH --partition=eeb      
#SBATCH --time=1-05:59:00        
#SBATCH --mem-per-cpu=24g
#SBATCH --mail-user=pveltsos@ku.edu
#SBATCH --ntasks=1             
#SBATCH --cpus-per-task=10
#SBATCH --output=flo.log

cd /home/p860v026/temp/bin/flo/flo_mimulus

rake -f Rakefile

NAME=1192to5_85
GFFNAME=MguttatusTOL_551_v5.0.gene

cd run

mv liftover.chn $NAME.chn

gzip $NAME.chn

cd $GFFNAME

ruby ../../gff_recover.rb lifted.gff3 > $NAME\lifted_cleaned.gff 2>$NAME\lifted_rubbish.gff

cd ..

mv $GFFNAME $NAME\_gff

tar -zcvf $NAME\_gff.tar.gz $NAME\_gff/

cp *.gz ../results/

