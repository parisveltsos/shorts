#!/bin/bash
#SBATCH --job-name=short              # Job name
#SBATCH --partition=kelly           # Partition Name (Required)
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1g                     # Job memory request
#SBATCH --time=2-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=short_%j.log         # Standard output and error log

echo "Running"
 
PBFOLDER=/home/p860v026/temp/pacbioSV
NAME=767
CHROM=06

cd /home/p860v026/temp/IM444

gunzip 444.fastq.gz 

# rm -rf IM909

# du -hs -d 1 /home/p860v026/temp/ > dupv.out

# cd $PBFOLDER/$NAME
# cd /home/p860v026/temp/pacbio/r64060_20201112_192654/1_A01 

# pwd; hostname; date

# bamsieve --blacklist 26_62_seqsZMW.txt m64047_200904_124839.subreads.bam not_62_62.bam

# gzip JKK-LVR_MPS12342939_D10_7687_S1_L002_R2_001.fastq
# gzip JKK-LVR_MPS12342939_D10_7687_S1_L002_R1_001.fastq
# tar -zcf supernovaShort.tar.gz JKK-LVR3/ 

# tar -zcvf canu541.tar.gz canu541/

# cp -r /home/p860v026/work/Mimulus_tilingii_10x/* /home/p860v026/temp/Mimulus_tilingii_10x/
# cp -r /home/p860v026/work/pacbio/* /home/p860v026/temp/pacbio/
# cp -r /home/p860v026/work/tolpis_coronop/* /home/p860v026/temp/tolpis_coronop/

# keep only mapped reads
# samtools view -b -F 4 outBig.bam > outBig.mapped.bam
# samtools index outBig.mapped.bam


# samtools view -@ 8 out.bam > out.sam

# samtools view -@ 8 -b out$NAME.bam Chr_$CHROM > out$NAME.chr$CHROM.bam
# samtools index -@ 8 out$NAME.chr$CHROM.bam

date

