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
# 	LINE=664
# 	cd /home/p860v026/temp/3prime/mapped
# 	mkdir $LINE
# 	cd $LINE
# 	cp ../key.txt .
# 	python ~/code/makePed.py 664-P 767P $LINE 664.vcf
# 	
# 	# manually delete grandparents in columns after 4

# make clean vcf

	
# LEP-MAP3

	LINE=664

	module load java
	cd /home/p860v026/temp/3prime/mapped/$LINE
	
	# make call file
# 	java -cp ~/bin/lm3/bin ParentCall2 data=$LINE\ped.txt vcfFile=664clean.vcf removeNonInformative=1 > $LINE.call 

	# remove non informative markers
# 	java -cp ~/bin/lm3/bin Filtering2 data=$LINE.call dataTolerance=0.001 > $LINE\filt.call 

	cat $LINE\filt.call | cut -f 1,2| awk '(NR>=7)' > $LINE\filtsnps.txt

	# separate chromosomes
	LOD=12 # mixed 15, 16, 19, 10 ok, 11 ok, 12, 11 
# 	java -cp ~/bin/lm3/bin SeparateChromosomes2 data=$LINE\filt.call lodLimit=$LOD > $LINE\map$LOD.txt

# 	sort $LINE\map$LOD.txt | uniq -c | sort -n 



# 	order markers
	java -cp ~/bin/lm3/bin OrderMarkers2 grandparentPhase=1 sexAveraged=1 data=$LINE\filt.call map= $LINE\map$LOD.txt > $LINE\order$LOD.txt 

	awk -vFS="\t" -vOFS="\t" '(NR==FNR){s[NR-1]=$0}(NR!=FNR){if ($1 in s) $1=s[$1];print}' $LINE\filtsnps.txt $LINE\order$LOD.txt > $LINE\order$LOD.mapped


#mixed here
# 	
# 
# 	 
# export data for plotting 
#	python ~/code/lm2bpcm.py $LINE $LOD
# 	
# Make plots
#	module load R
#	Rscript ~/code/bpcmPlot.r $LINE $LOD
# 	
#	tar -zcvf lgs$LINE\_$LOD.tar.gz *.pdf
# 	
# 	
# 	
	
	
	
# 	export for rqtl
#	awk -vfullData=1 -f ~/bin/lm3/LMscripts/map2genotypes.awk $LINE\order$LOD.txt > $LINE\genotypes.txt
# 	
# 	Only the map information is needed
# 	
# library(qtl)
# GenoData = read.cross(format = "csv", file = "~/Downloads/664genotypes.txt", genotypes=NULL, estimate.map = F, crosstype="4way")
# summary(GenoData)
# plotMap(GenoData)
