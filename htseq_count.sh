#!/bin/bash -l
#SBATCH --job-name=bbee		    # Job name
#SBATCH --partition=sixhour           # Partition Name (Required)
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=8
#SBATCH --mem=20gb                     # Job memory request
#SBATCH --time=00-05:50:00             # Time limit days-hrs:min:sec
#SBATCH --output=bbee_%j.log   # Standard output and error log

cd /home/p860v026/temp/3prime

STAREXEC=/home/p860v026/temp/bin/STAR/source/STAR
BBMAPFOLDER=/home/p860v026/temp/bbmap

GFFFILE=/home/p860v026/temp/bin/flo/flo_mimulus/results/664_85_recover_lifted_exon.gff3
GENOMEFILE=/home/p860v026/temp/IM664/664.contigs.fa

## RUN ONCE

# mkdir star_664_genome

# mkdir counts

# generate genome index
# $STAREXEC --runThreadN 8 --runMode genomeGenerate --genomeDir ./star_664_genome/ --genomeFastaFiles $GENOMEFILE --sjdbGTFfile $GFFFILE --sjdbGTFtagExonParentTranscript Parent --sjdbOverhang 74 --genomeSAindexNbases 13




## RUN PER READ FILE

#  ls /home/p860v026/temp/3prime/reads > listbbblue
#  vim listbbblue
#  for i in $(cat listbbblue); do sbatch ~/code/htseq_count.sh $i; done

module load java
module load samtools

TRIMMEDNAME=$(perl -pe 's/.gz//' <(echo $1))

# need to trim the reads
$BBMAPFOLDER/bbduk.sh in=./reads/$1 out=./trimmed/$TRIMMEDNAME ref=$BBMAPFOLDER/resources/truseq_rna.fa.gz,$BBMAPFOLDER/resources/polyA.fa.gz k=13 ktrim=r useshortkmers=t mink=5 qtrim=r trimq=10 minlength=20


SMALLNAME=$(perl -pe 's/.fq.gz//' <(echo $1))

echo $SMALLNAME 




$STAREXEC --runThreadN 8 --genomeDir ./star_v5_genome/  --readFilesIn ./trimmed/$TRIMMEDNAME --outFilterType BySJout --outFilterMultimapNmax 20 --alignSJoverhangMin 8 --alignSJDBoverhangMin 1 --outFilterMismatchNmax 999 --outFilterMismatchNoverLmax 0.1 --alignIntronMin 20  --alignIntronMax 1000000 --alignMatesGapMax 1000000 --outSAMattributes NH HI NM MD --outSAMtype BAM SortedByCoordinate --outFileNamePrefix ./mapped/$SMALLNAME

cd mapped
samtools index $SMALLNAME\Aligned.sortedByCoord.out.bam
cd ..

htseq-count -m intersection-nonempty -s yes -f bam -r pos -t exon -i Parent ./mapped/$SMALLNAME\Aligned.sortedByCoord.out.bam $GFFFILE > ./counts/$SMALLNAME\_counts.txt




## COMBINE ALL COUNTS
# mkdir temp
# 
# # filenames in first line
# cd counts
# for i in *.txt ; do echo -e "gene\t$i" | cat - $i > temp && mv temp $i; done
# cd ..
# 
# # counts per file 
# for i in $(ls counts/* | perl -pe 's/counts\///'); do cut -f2 counts/$i > temp/$i; done
# 
# # rownames from first file
# for i in $(ls counts/* | perl -pe 's/counts\///' | head -1); do cut -f1 counts/$i > temp/0count.txt; done
# 
# # combine columns, simplify names, remove last 5 rows with summary
# paste temp/*.txt | perl -pe 's/_counts.txt//g ; s/.v5.0//' | head -n -5 > final_count.txt

# Transpose file in BBedit, and remove L001 and L002 from the names
# in R

# datapath <- "~/Downloads"
# kdata <- read.table(file.path(datapath, "final_count.txt"), header=T)
# str(kdata)
# 
# 
# pool1Comb <- aggregate(.~gene,data=kdata,FUN=sum)
# write.table(pool1Comb, file=file.path(datapath, "pool1Comb.txt"), quote=F, row.names=F, sep="\t")
# simplify name _(.*?)\t
# transpose
# make matrix, count and design files