# File setup

	cd /panfs/pfs.local/scratch/kelly/p860v026/compareGenomes

Make fasta of interesting genes from transcriptome

	awk 'BEGIN{RS=">";FS="\n"}NR>1{seq="";for (i=2;i<=NF;i++) seq=seq""$i; print ">"$1"\n"seq}' /panfs/pfs.local/work/kelly/p860v026/genomes/Mgutv5/annotation/MguttatusTOL_551_v5.0.transcript_primaryTranscriptOnly.fa > allgenes.fa
	
Copy genomes to working folder

	cp /panfs/pfs.local/work/kelly/p860v026/Final.builds/purge1/*fa .
	
# 1. Map all genes to all genomes 

	for LINE in $(echo -e "62\t155\t444\t502\t541\t664\t909\t1034\t1192"); do sbatch ~/code/geneAlignment_01.sh $LINE; done

# 2. Run each gene

	for GENE in $(cat genelist); do sbatch ~/code/geneAlignment_02.sh $GENE 200; done