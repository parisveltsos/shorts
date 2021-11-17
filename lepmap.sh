#!/bin/bash
#SBATCH --job-name=LM3
#SBATCH --partition=sixhour      
#SBATCH --time=0-05:59:00        
#SBATCH --mem-per-cpu=4g         
#SBATCH --mail-user=pveltsos@ku.edu    
#SBATCH --ntasks=1                  
#SBATCH --cpus-per-task=1            
#SBATCH --output=LM3.log

# make pedigree (based on key.txt, +1 for all key 1st column)
# 	module load python/2.7
# 	LINE=1192
# 	cd /home/p860v026/temp/3prime/mapped_to_$LINE
# 	mkdir LM$LINE
# 	cd LM$LINE
# 	cp ../key_$LINE.txt .
# 	cp ../../1192clean.vcf .
# 	python ~/code/makePed.py 1192-P.bam 767-P.bam $LINE 1192clean.vcf
# # 	
# # 	# manually delete grandparents in columns after 4

# make clean vcf

	LINE=62
	
# Make linkage file from genotypes

# perl ~/git/shorts/transposeTabDelimited.pl $LINE.geno.v5.txt | perl -pe 's/^/1\t/ ; s/.bam/\t'$LINE'\tIM767\t1\t0/g ; s/1\/1/1 1/g ; s/0\/1/1 2/g ; s/0\/0/2 2/g ; s/\.\/\./0 0/g' > $LINE.linkage

	# Fix parent lines in linkage file
		# Remove first 4 lines
		# Add 0	0	2	0 to IM767 and 0	0	1	0 to LINE parent

# Make snp info from genotypes

# cut -f 1,2,3,4 $LINE.geno.v5.txt | grep -v contig | nl | perl -pe 's/ +/\t/g ; s/^\t//' > $LINE.markerNames.txt

	
# LEP-MAP3

	module load java
#	cd /home/p860v026/temp/3prime/mapped_to_$LINE/LM$LINE
		
	awk -f ~/bin/lm3/LMscripts/linkage2post.awk $LINE.linkage | java -cp ~/bin/lm3/LMscripts Transpose > goodF2.post
		
	# make call file
#	java -cp ~/bin/lm3/bin ParentCall2 data=$LINE\ped.txt vcfFile=$LINE\clean.vcf removeNonInformative=1 > $LINE.call 
	java -cp ~/bin/lm3/bin ParentCall2 data=goodF2.post removeNonInformative=1 > $LINE.call 

	# remove non informative markers
	java -cp ~/bin/lm3/bin Filtering2 data=$LINE.call dataTolerance=0.01 > $LINE\filt.call 

	cat $LINE\filt.call | cut -f 1,2| awk '(NR>=7)' > $LINE\filtsnps.txt

#	separate chromosomes
	LOD=12 # 1192 14 good
	java -cp ~/bin/lm3/bin SeparateChromosomes2 data=$LINE\filt.call lodLimit=$LOD > $LINE\map$LOD.txt

	sort $LINE\map$LOD.txt | uniq -c | sort -n > $LINE\_lod$LOD\_lgs.txt

	tail -20 $LINE\_lod$LOD\_lgs.txt



# 	order markers
	java -cp ~/bin/lm3/bin OrderMarkers2 sexAveraged=1 data=$LINE\filt.call map= $LINE\map$LOD.txt > $LINE\order$LOD.txt 
# 
	awk -vFS="\t" -vOFS="\t" '(NR==FNR){s[NR-1]=$0}(NR!=FNR){if ($1 in s) $1=s[$1];print}' $LINE\filtsnps.txt $LINE\order$LOD.txt > $LINE\order$LOD.mapped

# Make cm file
	cut -f 1,2 $LINE\order$LOD.txt | grep -v '#' > temp_cm.txt
	python ~/code/makeCM.py temp_cm.txt
	
# Merge files to make bpcmData

 cat <(echo -e 'snp\tlg\tcm\tcontig\tbp\tref\talt') <(join  -1 2 -2 1 <(sort out_temp_cm.txt -k2) <(sort $LINE.markerNames.txt) ) > $LINE\_$LOD\_bpcmData.txt

# Make plot
	
	module load R
	Rscript ~/code/bpcmPlot.r $LINE $LOD

# compress for export 

tar -zcvf lgs$LINE\_$LOD.tar.gz *.pdf
	
	
	
# 	export for rqtl
#	awk -vfullData=1 -f ~/bin/lm3/LMscripts/map2genotypes.awk $LINE\order$LOD.txt > $LINE\genotypes.txt
# 	
# 	Only the map information is needed
# 	
# library(qtl)
# GenoData = read.cross(format = "csv", file = "~/Downloads/664genotypes.txt", genotypes=NULL, estimate.map = F, crosstype="4way")
# summary(GenoData)
# plotMap(GenoData)
