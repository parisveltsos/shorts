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

## RUN ONCE

# mkdir star_v5_genome

# mkdir counts

# generate genome index
# /home/p860v026/temp/STAR/source/STAR --runThreadN 8 --runMode genomeGenerate --genomeDir ./star_v5_genome/ --genomeFastaFiles /home/p860v026/temp/Mgutv5/assembly/MguttatusTOL_551_v5.0.fa --sjdbGTFfile /home/p860v026/temp/Mgutv5/annotation/MguttatusTOL_551_v5.0.gene_exons.gff3 --sjdbGTFtagExonParentTranscript Parent --sjdbOverhang 74




## RUN PER READ FILE

#  ls /home/p860v026/temp/3prime/reads > listbbblue
#  vim listbbblue
#  for i in $(cat listbbblue); do sbatch $i; done

module load java

TRIMMEDNAME=$(perl -pe 's/.gz//' <(echo $1))

# need to trim the reads
/home/p860v026/temp/bbmap/bbduk.sh in=./reads/$1 out=./trimmed/$TRIMMEDNAME ref=/home/p860v026/temp/bbmap/resources/truseq_rna.fa.gz,/home/p860v026/temp/bbmap/resources/polyA.fa.gz k=13 ktrim=r useshortkmers=t mink=5 qtrim=r trimq=10 minlength=20


SMALLNAME=$(perl -pe 's/_/zaba/ ; s/_// ; s/_.+// ; s/zaba/_/' <(echo $1))

echo $SMALLNAME 




/home/p860v026/temp/STAR/source/STAR --runThreadN 8 --genomeDir ./star_v5_genome/  --readFilesIn ./trimmed/$TRIMMEDNAME --outFilterType BySJout --outFilterMultimapNmax 20 --alignSJoverhangMin 8 --alignSJDBoverhangMin 1 --outFilterMismatchNmax 999 --outFilterMismatchNoverLmax 0.1 --alignIntronMin 20  --alignIntronMax 1000000 --alignMatesGapMax 1000000 --outSAMattributes NH HI NM MD --outSAMtype BAM SortedByCoordinate --outFileNamePrefix ./mapped/$SMALLNAME

cd mapped
samtools index $SMALLNAME\Aligned.sortedByCoord.out.bam
cd ..

htseq-count -m intersection-nonempty -s yes -f bam -r pos -t exon -i Parent ./mapped/$SMALLNAME\Aligned.sortedByCoord.out.bam /home/p860v026/temp/Mgutv5/annotation/MguttatusTOL_551_v5.0.gene_exons.gff3 > ./counts/$SMALLNAME\_counts.txt




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
