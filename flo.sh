#!/bin/bash
#SBATCH --job-name=flo
#SBATCH --partition=eeb      
#SBATCH --time=1-05:59:00        
#SBATCH --mem-per-cpu=2g
#SBATCH --mail-user=pveltsos@ku.edu    
#SBATCH --ntasks=1             
#SBATCH --cpus-per-task=20
#SBATCH --output=flo.log

cd /home/p860v026/temp/bin/flo/flo_mimulus

rake -f Rakefile

