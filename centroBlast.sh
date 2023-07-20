	module load blast+
	
	makeblastdb -in 767.contigs.fasta -dbtype ucl -out 767.contigs.db

	blastn -db 767.contigs.db -query ../cent_728.fasta -out cent728_vs_767contigs.out -outfmt 7 -task blastn-short

	~/code/blast2gff.sh cent728_vs_767contigs.out

Need to remove short repeats )n and change name to remove _1
