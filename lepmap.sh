
# make pedigree (based on key.txt, +1 for all key 1st column)
	
	grep CHROM pool1.vcf | cut -f 277,268,169-263 | perl -pe 's/\t/\n/g' > 664ped.txt
	
	# rearrange so that parents are first, and each gets their own line.
	
	# transpose and turn into LM format using https://avikarn.com/2019-04-17-Genetic-Mapping-in-Lep-MAP3/
	 ~/bin/lm3/LMscripts/transpose_tab 664ped.txt | awk '{print "CHR\tPOS\t" $0}' > ped_t.txt

# LEP-MAP3

	module load java

	# make call file
	
	java -cp ~/bin/lm3/bin ParentCall2 data=ped_t2.txt vcfFile=pool1short.vcf removeNonInformative=1 > 664_2.call

	# remove non informative markers
	java -cp ~/bin/lm3/bin Filtering2 data=664_2.call dataTolerance=0.00001 > 664fil_2.call

	# separate chromosomes
	java -cp ~/bin/lm3/bin SeparateChromosomes2 data=664fil_2.call lodLimit=12 > 664map_2.txt
	sort 664map_2.txt | uniq -c | sort -n 

	# order markers
	java -cp ~/bin/lm3/bin OrderMarkers2 grandparentPhase=1 sexAveraged=1 data=664fil_2.call map=664map_2.txt > 664order_2.txt
	
	# export data for excel 
	python ~/code/lm2bpcm.py 664
	
	paste <(cut -f 1,2 664fil_2.call) <(cut -f 1,2 664order_2.txt) > 664Excel.txt
	