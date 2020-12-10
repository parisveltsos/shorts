# Run

	~/bin/circos-0.69-9/bin/circos -conf ~/code/circos/test.conf

# Short file creation

## Make list of names with long sequences

	sort -n -k 6,6 tilingii.karyotype.txt | tail -20 | cut -f 6 > longTilingii.txt

## Filter all tilingii based on list
	
	awk 'BEGIN{RS=">";FS="\n"}NR==FNR{a[$1]++}NR>FNR{if ($1 in a && $0!="") printf ">%s",$0}' longTilingii.txt <(awk '{print $1}' tilingii.fasta) > longTilingii.fasta

# Prepare files

## Prepare karyotypes

	python ~/code/circos/karyotype-from-fasta.py MgutatChr1013.fasta > MgutatChr1013.karyotype.txt
	python ~/code/circos/karyotype-from-fasta.py tilingii.fasta > tilingii.karyotype.txt
	
13159 different scaffolds in tilingii. Only 200 top can be plotted by default, need to compact them.

## Prepare links

## Coverage

https://www.biostars.org/p/49630/

# Information

Many circos file processing scripts are in [github tools-iuc](https://github.com/galaxyproject/tools-iuc/tree/master/tools/circos). I copied those that I use to ~/code/circos

They require biopython, which is installed on the cluster but needs to be loaded

	module load python