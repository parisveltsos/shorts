#!/bin/bash
#SBATCH --job-name=bwa                # Job name
#SBATCH --partition=eeb               # Partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=16gb                     # Job memory request
#SBATCH --time=14-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_bwa_%j.log         # Standard output and error log

module load bwa
module load samtools
echo "Running"

# Variables to change once per project

INPUTDIR=/home/p860v026/temp/kmer
OUTPUTDIR=/home/p860v026/temp/kmer

## Never change, the files will be copied in a subfolder named after the reads and reference, inside a project folder inside the scratch folder
SCRATCHDIR=/home/p860v026/temp/kmer

## Change for each combination of mapped reads to a reference. The reads can be `.fa` or `.fq`. Find and replace in this file `individual` and `interesting_sequence`.
READS1=JKK-LVR_MPS12342939_D10_7687_S1_L002_R1_001.fastq
READS2=JKK-LVR_MPS12342939_D10_7687_S1_L002_R2_001.fastq
REFERENCE=MgutatChr1013.fasta
NAME=Mtill10x_MgutatChr1013

cd $SCRATCHDIR || exit 1
# mkdir $NAME || exit 2
# cd $NAME
# 
# cp $INPUTDIR/$READS1.gz . 
# cp $INPUTDIR/$READS2.gz . 
# cp $INPUTDIR/$REFERENCE . 

# unzip, delete ziped files
gzip -d *.gz

# index reference genome
bwa index -a bwtsw $REFERENCE || exit 3
touch progress_index_done

# bwa alignment

bwa aln $REFERENCE $READS1 > aln_sa1.sai 
bwa aln $REFERENCE $READS2 > aln_sa2.sai 
bwa sampe $REFERENCE aln_sa1.sai aln_sa2.sai $READS1 $READS2 > $NAME.sam || exit 5
# rm $READS1
# rm $READS2
touch progress_bwa_aln_done

# conversion between sam to bam
samtools view -Sb $NAME.sam > $NAME.bam || exit 6
# rm $NAME.sam
touch progress_bam_done

# bam_sorting
samtools sort $NAME.bam -o $NAME.srt.bam || exit 7
# rm $NAME.bam
touch progress_sorting_done

# remove_duplicates, count all reads, keep and index mapped reads only.
samtools rmdup -s  $NAME.srt.bam  $NAME.srt_rmdup.bam || exit 8
# rm $NAME.srt.bam
samtools flagstat $NAME.srt_rmdup.bam > $NAME.flagstat.txt
samtools view -b -F 4 $NAME.srt_rmdup.bam > $NAME.mapped.bam
samtools index $NAME.mapped.bam
# cp $NAME.mapped.bam $OUTPUTDIR
# cp $NAME.mapped.bam.bai $OUTPUTDIR
# cp $NAME.flagstat.txt $OUTPUTDIR

cd ..
# rm -rf $SCRATCHDIR/$NAME || exit 10

