#!/bin/bash
#SBATCH --job-name=short				# Job name
#SBATCH --partition=sixhour,eeb,kelly,kucg 	# Partition Name (Required)
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=8							# Threads
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4g                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.out
#SBATCH --error=R-%x.%j.err

# conda activate /panfs/pfs.local/scratch/kelly/p860v026/conda/envs/liftoff

# conda activate liftoff

cd /panfs/pfs.local/scratch/kelly/p860v026/qtl/out

rm -rf 444rm/
rm -rf 541rm/
rm -rf 664rm/
rm -rf 1034rm/
rm -rf 502rm/
rm -rf 909rm/


# liftoff -g Mguttatusvar.IM767v1.1.gene_exons.gff3 -o 767_lift_to_62.gff3 /panfs/pfs.local/work/kelly/p860v026/Final.builds/purge1/62purged1.fa Mimulus_guttatus_var_IM767.mainGenome.fasta

# cd /home/p860v026/temp 

# find . -exec touch {} +

# cd /home/p860v026/temp/slatgen2

# echo $1 > $1\_by_chr.txt
# awk '$5 > 55' $1.sam | cut -f 3 | sort | uniq -c | sort | perl -pe 's/chr/\tchr/ ; s/sca/\tsca/' >> $1\_by_chr.txt
# 
# sort -k2 $1\_by_chr.txt > $1\_by_chr_sorted.txt
# 
# rm $1\_by_chr.txt

# echo $1 > $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>0 && $4<1e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>1e7 && $4<2e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>2e7 && $4<3e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>3e7 && $4<4e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>4e7 && $4<5e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>5e7 && $4<6e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>6e7 && $4<7e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>7e7 && $4<8e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>8e7 && $4<9e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>9e7 && $4<10e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>10e7 && $4<11e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>11e7 && $4<12e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>12e7 && $4<13e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>13e7 && $4<14e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>14e7 && $4<15e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>15e7 && $4<16e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>16e7 && $4<17e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>17e7 && $4<18e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>18e7 && $4<19e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>19e7 && $4<20e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>20e7 && $4<21e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>21e7 && $4<22e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>22e7 && $4<23e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>23e7 && $4<24e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>24e7 && $4<25e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>25e7 && $4<26e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>26e7 && $4<27e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>27e7 && $4<28e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>28e7 && $4<29e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>29e7 && $4<30e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>30e7 && $4<31e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>31e7 && $4<32e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>32e7 && $4<33e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>33e7 && $4<34e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>34e7 && $4<35e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>35e7 && $4<36e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>36e7 && $4<37e7' $1.sam | wc -l >> $1\_xlength.txt
# awk '$5 > 55 && $3=="chr12" && $4>37e7 && $4<38e7' $1.sam | wc -l >> $1\_xlength.txt




# 
# module load samtools
# 
# samtools view -h $1.bam > $1.sam

# cd /home/p860v026/temp/slatgen2

# dnadiff 444purged1.fa 444.racon1.fasta



# minimap2 -x asm10 -t 12 S.latifolia_v2.0_chr.fasta.txt CDS_genes_test.fasta > CDS_genes_test.paf


# for i in $(ls *gz | grep -v L002 | perl -pe 's/_S.+//g'); do cat $i* > $i.fastq.gz; done

# du -hs -d 1 /home/p860v026/temp/ > dupv.out

# gzip JKK-LVR_MPS12342939_D10_7687_S1_L002_R2_001.fastq

# tar -zcvf LM3_cluster.tar.gz vcf767/

# mv * /home/p860v026/temp/trimmed_bp/ =  =  =  = 
