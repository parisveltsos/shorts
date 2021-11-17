#!/bin/bash -l
#SBATCH --job-name=cnt909	    # Job name
#SBATCH --partition=sixhour           # Partition Name (Required) sixhour kelly
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=8
#SBATCH --mem=8gb                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=htscnt_%j.log   # Standard output and error log

cd /home/p860v026/temp/3prime

STAREXEC=/home/p860v026/temp/bin/STAR/source/STAR
BBMAPFOLDER=/home/p860v026/temp/bbmap

# GFFFILE=WAITING
# GENOMEFILE=/home/p860v026/temp/IM664/664.contigs.fa
# STARGENOMEFOLDER=star_664_18np_genome
# GENOMENAME=664_18np

# GFFFILE=/home/p860v026/temp/bin/flo/flo_mimulus/results/18_664to5_85_gff/18_664to5_85lifted_cleaned_mRNAtoGene2.gff
# GENOMEFILE=/home/p860v026/temp/IM664/1.8/18_664purged.fa
# STARGENOMEFOLDER=star_664_18_genome
# GENOMENAME=664_18

GFFFILE=/home/p860v026/temp/bin/flo/flo_mimulus/results/909to5_85_gff/909to5_85lifted_cleaned_mRNAtoGene2.gff
GENOMEFILE=/home/p860v026/temp/IM909/purge2/909purged2.fa
STARGENOMEFOLDER=star_909_genome
GENOMENAME=909

# GFFFILE=/home/p860v026/temp/bin/flo/flo_mimulus/results/1192to5_85_gff/1192to5_85lifted_cleaned_mRNAtoGene2.gff
# GENOMEFILE=/home/p860v026/temp/IM1192/purge2/1192purged2.fa
# STARGENOMEFOLDER=star_1192_genome
# GENOMENAME=1192

# GFFFILE=/home/p860v026/temp/genomes/Mgutv5/annotation/MguttatusTOL_551_v5.0.gene_exons.gff3
# GENOMEFILE=/home/p860v026/temp/genomes/Mgutv5/assembly/MguttatusTOL_551_v5.0.fa
# STARGENOMEFOLDER=star_v5_genome
# GENOMENAME=v5


## RUN ONCE PER GENOME # 5 min 8 Gb

# mkdir $STARGENOMEFOLDER
# 
# generate genome index
# $STAREXEC --runThreadN 8 --runMode genomeGenerate --genomeDir ./$STARGENOMEFOLDER/ --genomeFastaFiles $GENOMEFILE --sjdbGTFfile $GFFFILE --sjdbGTFtagExonParentTranscript Parent --sjdbOverhang 74 --genomeSAindexNbases 13


#  cd ~/code 
#  ls -laSh /home/p860v026/temp/3prime/trimmed > list6hr
#  vim list6hr     
	# split to listjk >3Gb and list6hr
	# make listest to try everything works before submitting big job
#  for i in $(cat list6hr); do sbatch ~/code/htseq_count.sh $i; done
	# Once run check no empty bams produced, see readme




module load java
module load samtools

TRIMMEDNAME=$(perl -pe 's/.gz//' <(echo $1))


## RUN ONCE PER READ FILE

# need to trim the reads
# $BBMAPFOLDER/bbduk.sh in=./reads/$1 out=./trimmed/$TRIMMEDNAME ref=$BBMAPFOLDER/resources/truseq_rna.fa.gz,$BBMAPFOLDER/resources/polyA.fa.gz k=13 ktrim=r useshortkmers=t mink=5 qtrim=r trimq=10 minlength=20
# cd trimmed
# gzip $TRIMMEDNAME
# cd /home/p860v026/temp/3prime




## RUN ONCE PER READ BY GENOME COMBINATION (7Gb memory for parent, 8 cpu, 50 min)

SMALLNAME=$(perl -pe 's/.fastq.gz//' <(echo $1))

echo $SMALLNAME

mkdir mapped_to_$GENOMENAME


$STAREXEC --runThreadN 8 --genomeDir ./$STARGENOMEFOLDER/ --readFilesCommand zcat --readFilesIn ./trimmed/$1 --outFilterType BySJout --outFilterMultimapNmax 20 --alignSJoverhangMin 8 --alignSJDBoverhangMin 1 --outFilterMismatchNmax 999 --outFilterMismatchNoverLmax 0.1 --alignIntronMin 20  --alignIntronMax 1000000 --alignMatesGapMax 1000000 --outSAMattributes NH HI NM MD --outSAMtype BAM SortedByCoordinate --outFileNamePrefix ./mapped_to_$GENOMENAME/$SMALLNAME

cd mapped_to_$GENOMENAME
mv $SMALLNAME\Aligned.sortedByCoord.out.bam $SMALLNAME.bam
samtools index $SMALLNAME.bam
rm -rf $SMALLNAME\_STARtmp 
cd ..

mkdir counts_to_$GENOMENAME

htseq-count -m intersection-nonempty -s yes -f bam -r pos -t gene -i ID ./mapped_to_$GENOMENAME/$SMALLNAME.bam $GFFFILE > ./counts_to_$GENOMENAME/$SMALLNAME\_counts.txt



## RESET COUNT FILES

# for i in $(ls *counts.txt); do grep -v gene $i > $i.temp; mv $i.temp $i; done


## COMBINE ALL COUNTS

# cd /home/p860v026/temp/3prime
# mkdir temp_count
# 
# # filenames in first line
# cd counts_to_$GENOMENAME
# for i in *.txt ; do echo -e "gene\t$i" | cat - $i > temp_count && mv temp_count $i; done
# 
# # counts per file 
# for i in $(ls | perl -pe 's/counts\///'); do cut -f2 $i > ../temp_count/$i; done
# 
# # rownames from first file
# for i in $(ls | perl -pe 's/counts\///' | head -1); do cut -f1 $i > ../temp_count/0count.txt; done
# cd ..
# 
# # combine columns, simplify names, remove last 5 rows with summary
# paste temp_count/*.txt | perl -pe 's/_counts.txt//g' | head -n -5 > $GENOMENAME\_final_count.txt
# rm -rf temp_count
# 
# make matrix, count and design files