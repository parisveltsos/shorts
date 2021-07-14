#!/bin/bash
#SBATCH --job-name=flo
#SBATCH --partition=kelly      
#SBATCH --time=1-05:59:00        
#SBATCH --mem-per-cpu=2g
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1             
#SBATCH --cpus-per-task=18
#SBATCH --output=flo.log

cd /home/p860v026/temp/bin/flo/flo_mimulus

rake -f Rakefile

NAME=66421npto5_85

cd run

mv liftover.chn $NAME.chn

gzip $NAME.chn

cd Mguttatus_256_v2.0.gene/

ruby ../../gff_recover.rb lifted.gff3 > lifted_cleaned.gff 2>lifted_rubbish.gff

cd ..

mv Mguttatus_256_v2.0.gene/ $NAME\_gff

tar -zcvf $NAME\_gff.tar.gz $NAME\_gff/

cp *.gz ../results/

