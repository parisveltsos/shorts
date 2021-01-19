Choose positive control contigs

	cd /home/p860v026/temp/Mgut_Mtil
	
	perl -pe 's/ .+//g' tilingii.fasta > tilingii_simplenames.fasta
	
	awk 'BEGIN{RS=">";FS="\n"}NR==FNR{a[$1]++}NR>FNR{if ($1 in a && $0!="") printf ">%s",$0}' positive_list_tilingii.txt tilingii_simplenames.fasta > tilingii_positive.fasta
	
>121 - ch 13 inversion
>53278 - ch13 inversion
>132 - ch10 inversion
>53133 - ch10 inversion
>53108 - ch10 inversion probably?

	module load python

	python /home/p860v026/.local/bin/ragtag.py correct MgutatChr1013.fasta tilingii_positive.fasta -o ./out_ragtag_reads -R /home/p860v026/temp/reads/JKK-LVR_MPS12342939_D10_7687_S1_L002_R2_001.fastq.gz -T sr



Make genes fasta file for chromosome 10-13

	perl -pe 's/\n/\t/g ; s/\>/\n\>/g' all.genes.fa | grep 'Chr_13' | perl -pe 's/\t/\n/g ; s/\n\n/\n/g' > chr1113genes.fasta

	perl -pe 's/\n/\t/g ; s/\>/\n\>/g' all.genes.fa | grep 'Chr_11' | perl -pe 's/\t/\n/g ; s/\n\n/\n/g' >> chr1113genes.fasta
	
	python /home/p860v026/.local/bin/ragtag.py correct MgutatChr1013.fasta /home/p860v026/Mimulus.genomes/Mimulus_guttatus_TOL/sequences/chr1113genes.fasta -o ./out_ragtag_genes
	
raw transcript reads from SRA

I got a leaf RNA sample from a field individual https://trace.ncbi.nlm.nih.gov/Traces/sra/?run=SRR7976161  randomly selected from many RNA libraries https://www.ncbi.nlm.nih.gov/sra which I got to from choosing “SRA experiments” from https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?mode=Info&id=4155&lvl=3&keep=1&srchmode=1&unlock&mod=1&log_op=modifier_toggle#modif 


	module load sratoolkit/2.9.6

	fastq-dump SRR7976161