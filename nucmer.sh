#!/bin/bash
#SBATCH --job-name=mummer    # Job name
#SBATCH --partition=sixhour           # Partition Name (Required)
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=8
#SBATCH --mem=4gb                     # Job memory request
#SBATCH --time=00-01:50:00             # Time limit days-hrs:min:sec
#SBATCH --output=mummer_%j.log   # Standard output and error log

module load mummer/4.0.0rc1
# module load gnuplot/5.2.7
# module load gnuplot 

# cd /home/p860v026/temp
# 
# # put all sequence lines in single line and simplify fasta header
# awk 'BEGIN{RS=">";FS="\n"}NR>1{seq="";for (i=2;i<=NF;i++) seq=seq""$i; print ">"$1"\n"seq}' Mimulus_JK_Pseudohap.fasta  | perl -pe 's/ .+//g' > pseudohapPV.fasta
# 
# # sort by sequence length, longest in end
#  awk '/^>/ {printf("%s%s\t",(N>0?"\n":""),$0);N++;next;} {printf("%s",$0);} END {printf("\n");}'  pseudohapPV.fasta  | awk -F '\t' '{printf("%d\t%s\n",length($2),$0);}' | sort -k1,1n | cut -f 2- | tr "\t" "\n" > pseudohapPV2.fasta
# 
# # keep 25 longest sequences
# tail -50 pseudohapPV2.fasta > longest50.fasta

cd /home/p860v026/temp/mummer

# -t allows many cores, -L filters out alignments smaller than the number -l is minimum exact length (10-20 did not matter)
nucmer --mum -c 100 -p nucmer -t 8 -L 1000 /home/p860v026/temp/Mgutv5/assembly/chr_10_13.fasta /home/p860v026/temp/pseudohapPV2.fasta

wait 
# -T outputs tab-formatted text 
show-coords -r -c -l -T nucmer.delta > nucmertab2.coords
# 
show-snps -C nucmer.delta > nucmer.snps
# 
# show-aligns nucmer.delta "Chr_13" "139" /home/p860v026/temp/Mgutv5/assembly/chr_10_13.fasta /home/p860v026/temp/pseudohapPV2.fasta
# 
# wait 
# 
# nucmer - maxmatch /home/p860v026/temp/Mgutv5/assembly/chr_10_13.fasta /home/p860v026/temp/pseudohapPV2.fasta
# 
show-tiling nucmer.delta > nucmer.tiling

# --png output so no need to deal with gnuplot 
 
mummerplot nucmer.delta --png
# mummerplot -r "Chr_13" nucmer.delta --png
# mummerplot nucmer.tiling --png
# 
# wait 
# 
# gnuplot out.gp
# 
# 
