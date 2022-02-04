## Concatenate fastq by ID

	for i in $(ls *gz | grep -v L002 | perl -pe 's/_S.+//g'); do cat $i* > $i.fastq.gz; done

## Generate counts (`htseq_count.sh`)

If genome exists, start in line 50. Edit header to choose appropriate queue for list file.

Once run check no empty bams produced.

	cd /home/p860v026/temp/3prime/counts_to_$GENOME
	find . -name '*.txt' -size 0 | sed 's/^..//g ; s/listempty.txt//g' | grep counts | sort > listempty.txt
	
If they are, see if jobs can be run in sixhour queue

	sed 's/_counts.txt/\.fastq\*/ ; s/^/ls \-sh \~\/temp\/3prime\/trimmed\//' listempty.txt > checkSize.sh
	bash checkSize.sh

Make new sixhour list

	sed 's/_counts.txt/\.fastq\.gz/' listempty.txt > ~/code/listredo

## Compile counts (`htseq_count.sh`)

Load $GENOMENAME from beginning of script, then run line 100 onwards

Copy file to MBP and run `reads_to_plate.r` script.

## Generate vcf (`parallelPileup.sh`)

`Prepare files` line 26 from script

Run `main script` from line 34

Check logs completed, those that dont complete end later and are larger.

Run `make final vcf` from line 60

## Cleanup vcf and plot heterozygosity

	~/code/cleanvcf.sh

