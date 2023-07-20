#!/bin/bash
#SBATCH --job-name=syri2    # Job name
#SBATCH --partition=sixhour,eeb,kucg,kelly           # Partition Name (Required)
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=16                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=4gb                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.log

# module load mummer/4.0.0rc1
# module load python




#MY OLD CODE 
# 
# 
# -t allows many cores, -L filters out alignments smaller than the number -l is minimum exact length (10-20 did not matter)
# nucmer --mum -c 100 -p nucmer -t 8 -L 1000 /home/p860v026/temp/Mgutv5/assembly/chr_10_13.fasta /home/p860v026/temp/pseudohapPV2.fasta
# 
# wait 
# -T outputs tab-formatted text 
# show-coords -r -c -l -T nucmer.delta > nucmertab2.coords
# 
# show-snps -C nucmer.delta > nucmer.snps
# 
# show-aligns nucmer.delta "Chr_13" "139" /home/p860v026/temp/Mgutv5/assembly/chr_10_13.fasta /home/p860v026/temp/pseudohapPV2.fasta
# 
# wait 
# 
# nucmer - maxmatch /home/p860v026/temp/Mgutv5/assembly/chr_10_13.fasta /home/p860v026/temp/pseudohapPV2.fasta
# 
# show-tiling nucmer.delta > nucmer.tiling
# 
# --png output so no need to deal with gnuplot 
#  
# mummerplot nucmer.delta --png
# mummerplot -r "Chr_13" nucmer.delta --png
# mummerplot nucmer.tiling --png
# 
# wait 
# 
# gnuplot out.gp
# 
# 
