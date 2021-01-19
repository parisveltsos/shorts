#!/bin/bash
#SBATCH --job-name=kallisto                # Job name
#SBATCH --partition=sixhour               # Partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2gb                     # Job memory request
#SBATCH --time=0-05:58:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_kallisto_%j.log         # Standard output and error log

module load kallisto

echo "Running"

# Variables to change once per project

INPUTDIR=/home/p860v026/temp/kallisto
OUTPUTDIR=/home/p860v026/temp/kallisto/out

## Change for each combination of mapped reads to a reference. The reads can be `.fa` or `.fq`. Find and replace in this file `individual` and `interesting_sequence`.
REFERENCE=MguttatusTOL_551_v5.0.transcript_primaryTranscriptOnly.fa
READS=1192_4_q_S3_L001_R1_001.fastq.gz
NAME=1192_4_q

cd $INPUTDIR || exit 1

# index reference genome
kallisto index -i primaryTscp $REFERENCE | exit 3
touch progress_index_done

# Kallisto count

kallisto quant -i primaryTscp --single -l 150 -s 20 -o $NAME $READS





READS=1192_3_q_S2_L001_R1_001.fastq.gz
NAME=1192_3_q
kallisto quant -i primaryTscp --single -l 150 -s 20 -o $NAME $READS
READS=1192_3_h_S10_L001_R1_001.fastq.gz
NAME=1192_3_h
kallisto quant -i primaryTscp --single -l 150 -s 20 -o $NAME $READS
READS=1192_1_q_S1_L001_R1_001.fastq.gz
NAME=1192_1_q
kallisto quant -i primaryTscp --single -l 150 -s 20 -o $NAME $READS
READS=1192_1_h_S9_L001_R1_001.fastq.gz
NAME=1192_1_h
kallisto quant -i primaryTscp --single -l 150 -s 20 -o $NAME $READS
READS=1034_3_q_S8_L001_R1_001.fastq.gz
NAME=1034_3_q
kallisto quant -i primaryTscp --single -l 150 -s 20 -o $NAME $READS
READS=1034_2_q_S7_L001_R1_001.fastq.gz
NAME=1034_2_q
kallisto quant -i primaryTscp --single -l 150 -s 20 -o $NAME $READS
READS=1034_1_q_S6_L001_R1_001.fastq.gz
NAME=1034_1_q
kallisto quant -i primaryTscp --single -l 150 -s 20 -o $NAME $READS
READS=1034_1_h_S12_L001_R1_001.fastq.gz
NAME=1034_1_h
kallisto quant -i primaryTscp --single -l 150 -s 20 -o $NAME $READS
READS=909_2_q_S5_L001_R1_001.fastq.gz
NAME=909_2_q
kallisto quant -i primaryTscp --single -l 150 -s 20 -o $NAME $READS
READS=909_2_h_S11_L001_R1_001.fastq.gz
NAME=909_2_h
kallisto quant -i primaryTscp --single -l 150 -s 20 -o $NAME $READS
READS=909_1_q_S4_L001_R1_001.fastq.gz
NAME=909_1_q
kallisto quant -i primaryTscp --single -l 150 -s 20 -o $NAME $READS

# Compile all counts together

	for i in $(ls | grep -v 'txt\|gz\|a'); do cut -f4 $i/abundance.tsv > $i.txt;  done

	for i in $(ls | grep txt); do cat <(echo $i | perl -pe 's/.txt//') <(tail -n +2 $i) > $i\_count.txt; done

	cut -f1 1192_1_h/abundance.tsv > 1count.txt

	paste *count* > table.txt

# Manually fix outcome