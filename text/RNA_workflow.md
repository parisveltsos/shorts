# Prep

	mkdir 3prime
	cd 3prime
	mkdir reads
	mkdir trimmed
	
Download files per individual from sequencing facility in `reads_$POPULATION` folder, where $POPULATION refers to the source families of the RNAseq data.

## Fastq to reads and vcf

The working folders, reference assembly, gff and RNA and genome output names are setup in `mim_setup.sh`

## Index genome

Generate an index for the genome to use with the STAR aligner. There are options with and without using a gff file.

	sbatch mim_01_index_genome.sh

## Trim the reads

Edit the `mim_02_trim_reads.sh` script to have the run name (e.g. "s1") in line 28. This will produce unique sequencing run - sample name which will make tracking repeat runs of the same sample easy.

This is run once per read file. First make a text file with the filenames, so that the jobs can be run in parallel.
	
	ls -laSh $OUTFOLDER/trimmed > list6hr
	
edit to just the filenames column, and run in parallel

	for i in $(cat list6hr); do sbatch ~/code/mim_02_trim_reads.sh $i; done

## Map trimmed reads to reference

This is run once per trimmed read file. First make a text file with the filenames, so that the jobs can be run in parallel.

Edit to just the filename column, but split in two files. list6hr has those < 3Gb, listjk > 3Gb, which take more than 6hr to run and need different slurm script settings. 

Try with one file to make sure it works well before submitting the parallel jobs

	cd mapped_to_$GENOMENAME
	
	for i in $(tail -1 list6hr); do sbatch ~/code/mim_03_map_reads.sh $i; done

Once run, bam files should appear in $OUTFOLDER/mapped_to_$GENOMENAME

If all looks good, submit the parallel jobs

	for i in $(cat list6hr); do sbatch ~/code/mim_03_map_reads.sh $i; done
	

## Generate counts

Ensure it works before submitting many jobs

	for i in $(tail -1 list6hr); do sbatch ~/code/mim_04_counts_from_bam.sh $i; done

Submit many jobs

	for i in $(cat list6hr); do sbatch ~/code/mim_04_counts_from_bam.sh $i; done

## Combine counts

If this step was unsuccessfully, first reset count files

	# for i in $(ls *counts.txt); do grep -v gene $i > $i.temp; mv $i.temp $i; done
	
	sbatch ~/code/mim_05_combine_counts.sh

The resulting file in `3prime/` folder is ready for RNAseq analysis and transforming for QTL analysis.

## Call SNPs

### Make vcfs

Prepare input files

	cd $OUTFOLDER/$STARGENOMEFOLDER

	paste chrName.txt chrLength.txt | sort -r -n -k 2 | perl -pe 's/\t/\:1\-/' > chr.bed

Split regions to 1,000,000 size for fast processing in sixhour queue

	python ~/code/split.chroms.py

Submit parallel jobs making vcfs for small chunks of the genome.

	cd $OUTFOLDER/mapped_to_$GENOMENAME
	
Make a test run. It should produce a vcf in mapped_to_$GENOME. Take the script input from 

	source ~/code/mim_setup.sh
	sbatch ~/code/mim_06_make_vcf.sh <(tail -1 $OUTFOLDER/star_$GENOMENAME\_genome/split.chr.bed)

Run parallel jobs, second line is needed if the split.chr.bed file has more than 5000 lines

	for i in $(cat $OUTFOLDER/star_$GENOMENAME\_genome/split.chr.bed); do sbatch ~/code/mim_06_make_vcf.sh $i; done

	# for i in $(cat $OUTFOLDER/$STARGENOMEFOLDER/split.chr.bed | tail -90); do sbatch ~/code/mim_06_make_vcf.sh $i; done # can only submit 5000 jobs

### Merge to single vcf

Edit the vcf in the first grep line of the mim_07_merge_vcfs with any of the vcfs in \$OUTFOLDER/mapped_to_$GENOMENAME

Run the script

	sbatch mim_07_merge_vcfs.sh

	
	
# VCF to genetic maps 

Keep biallelic SNPs above a coverage threshold (minimum number of individuals that should have it).

	python ~/code/vcf_01_keepBial_cov.py $GENOMENAME.vcf 400

Make a key (expects sample format to be "s12_1192-39" which stands for sequence run _ family - individual)

	python ~/code/vcf_02_makeKey.py $GENOMENAME.vcf

Keep only SNPs present in 50% of individuals, and at set minimum coverage (5)

	python ~/code/vcf_03_keep_halfIDcov_depth.py $GENOMENAME.vcf 5

Estimate divergence of a sample from average of families, and identify bad markers to ignore in future.

	vcf_04_estimateDivergence.py zaba

Names of individuals that look like they are mislabelled or contaminated go to the `bad.boys.txt` file.

Check generate input file for lepmap works. If it does you don't need to run the command as it is run by the first step in the lepmap workflow below.

	python ~/code/vcf_05_toLepmap.py 


# Lepmap

The first is launched from the folder containing the clean vcf made above. The remaining are launched from the directory made from the first script, with the family name.

Prepare folders and files from clean vcf above (10 min)

	cd /panfs/pfs.local/scratch/kelly/p860v026/VCFFOLDER
	
	sbatch ~/code/lm_1_prep.sh $VCF $LINE

Parallel run of multiple LOD scores, to be used to determine the one resulting in the expected number of LGs (15 min)

	cd /panfs/pfs.local/scratch/kelly/p860v026/VCFFOLDER/LINE
	
	for i in $(echo -e "12\n13\n14\n15\n16\n17\n18\n19"); do sbatch ~/code/lm_2_tryLod.sh $LINE $i; done

Note number ID and SNP from log file in a note text file, and delete logs

Manually determine appropriate LOD score from the following output

	for i in $(echo -e "12\n13\n14\n15\n16\n17\n18\n19"); do cat $LINE\_lod$i\_lgs.txt; done

Order markers using the identified LOD score (2 h)

	sbatch ~/code/lm_3_orderMarkers.sh $LINE $LOD
	
Make histogram. Need to manually edit the log name below. Run with (high) THRESHOLD of 6.

	cat <(echo -e 'id\ttimes') <(grep Individual  R-LM3.34241869.log | cut -f 3,5) > $LINE.recData.txt
	
	module load R
	
	Rscript ~/code/aveRec.r $LINE $THRESHOLD

Inspect the histogram and rerun with a threshold that will capture the outlier individuals with too much recombination. Manually add their names to the `bad.boys.txt` file.

Make pdf of bp to cm information. If there were more than 14 LGs, define it in the input.

	sbatch ~/code/lm_4_pdf_cMtoBp.sh $LINE $LOD $LG
	
Download pdf and manually rename to which assembly chromosome corresponds to which LG.

If there are outlier individuals, repeat the lepmap workflow using the updated `bad.boys.txt` file.

When the map cannot be improved (may take 3-4 iterations), make the rqtl input (below).

# QTL

## Data prep

### Add gene to bpcm file

	INPUT QTL zaba

### Identify nearest map location for all genes with counts

	genes.to.a.specific.map.gz

Manually fix map

### Generate map and genotype data from Genotype.calls.txt

Split big genotype file every 5834 lines, the number of genotype calls per individual, hence make a file per individual.

	split -d -l5834 Genotype.calls.txt

Rename split files based on first word in first line, which is the individual id

	for i in $(ls | grep x); do mv "$i" "$(head -1 "$i" | cut -f 1)"; done

Keep only relevant fields and transpose to make SNP name, genotype call file per individual

	for i in $(ls | grep _); do head -1 $i | cut -f 1 > $i.txt; cut -f 6 $i | perl -pe 's/\t/_/' >> $i.txt; done

Make map file

	echo -e "id\t" > map.txt
	cut -f 4-5 s12_1192-39 | perl -pe 's/\t/_/' >> map.txt

Combine genotypes and map file to final genotypes

	paste map.txt s*.txt | perl  ~/code/transposeTabDelimited.pl  > wp_genotypes.txt
	
Manually sort the map by chromosome and location (move lines 10_ to 14_ to end of file). 

Transpose and sort by first column to keep IDs in repeatable order.

Replace tabs with commas. Use the header with SNP IDs to make a new file with 3 lines: SNP ID, chromosome, number of marker (resets to 1 in each chromosome). Name the file `rQTL.headers.txt`

Put remaining lines into new file `rQTL.allGenotypes.txt`. Replace AA -> A, AB -> H, BB -> B, NN -> 0

Make list of IDs for which genotypes exist. It will be used to filter the counts file to only those individuals.

	cut -f1 -d, rQTL.allGenotypes.txt > includedIDs.txt

### Voom transformation (generation of phenotype - gene expression files for rQTL)

The phenotype file `Thinned.counts.v5.cpm1.txt` was generated for the GEMMA study, the same remaining genes with cpm>1 are used for voom transformation. Sort the IDs alphabetically so the design file has the same order.

Generate a subset of the design file with the individuals that passed the GEMMA criteria for inclusion. 

	awk -f ~/Documents/git/shorts/transpose.sh <(head -1 Thinned.counts.v5.cpm1.txt) > includedIDs.txt

	for i in $(cat includedIDs.txt); do grep $i wp_design.txt  >> wp.v5.design.genotyped_temp.txt; done

	head -1 wp_design.txt > wp.v5.design.genotyped.txt
	
	sort wp.v5.design.genotyped_temp.txt | uniq | sort -k 10 >> wp.v5.design.genotyped.txt

Manually remove lines from `wp.v5.design.genotyped.txt` with 1 next to them after the following command

	cat <(cut -f 10 wp.v5.design.genotyped.txt) <(cat includedIDs.txt) | sort | uniq -c | sort | head -20

Edit the path and input filename in the `voom_transform.R` file and run it.
	Rscript voom_transform.R

The script 

	* keeps only genes with >0 reads in 5% of the sample (22239 genes remain)
	* performs edgeR's TMM normalisation and keeps genes with average log CPM >=0 (17253 genes remain), 
	* applies voom transformation with plant cohort and family as parameters
	* produces the voom transformed data, a weights file and a design file to be used by rQTL
	
#### Minor edits to R script output

Counts: Fix header, transpose, fix ID names, make comma delimited.

	sed 's/s/id\ts/' wp_v5_voomCounts_lcpm1.txt | perl ~/Documents/git/shorts/transposeTabDelimited.pl | sed 's/\./-/ ; s/\t/,/g' > voomCounts.txt

Weights: add fixed ID names, transpose

	head -1 wp_v5_voomCounts_lcpm1.txt | sed 's/s/id\ts/ ; s/\./-/g' > voomWeights_temp.txt

	grep -v rownames wp_v5_voomWeights_lcpm1.txt >> voomWeights_temp.txt
	
	perl ~/Documents/git/shorts/transposeTabDelimited.pl voomWeights_temp.txt > voomWeights.txt

### Generate family-specific rQTL files

The files from the voom transformation of the raw count data (`voomCounts.txt`, `voomWeights.txt`, `voomDesign.txt`) are split into data for a particular family, to be analysed separately by rqtl.

	for LINE in $(echo -e "62\t155\t444\t502\t541\t664\t909\t1034\t1192") ; do cat <(grep id voomCounts.txt | perl -pe 's/\t/,/g') <(grep _$LINE voomCounts.txt | grep -v P | perl -pe 's/\t/,/g') > $LINE.count.txt ; cat <(grep id voomWeights.txt | perl -pe 's/,/\t/g') <(grep _$LINE voomWeights.txt | grep -v P | perl -pe 's/,/\t/g') > $LINE.weight.txt ; cat <(echo -e "id\tcohort") <(grep _$LINE wp.v5.design.genotyped.txt | cut -f 10,12 | grep -v P | perl -pe 's/one/0/g ; s/two/0/g ; s/three/1/g ; s/four/1/g') > $LINE.cohort.txt ; cat rQTL.headers.txt <(grep _$LINE rQTL.allGenotypes.txt | grep -v P) > $LINE.genotypes.txt; done

## QTL prep per line

This makes a R.project that loads all required files and estimates lod score threshold. The subsequent scanone step is run in parallel for all genes, using the same project.

	cd /panfs/pfs.local/scratch/kelly/p860v026/qtl/
	
	for LINE in $(echo -e "62\t155\t444\t502\t541\t664\t909\t1034\t1192"); do sbatch ~/code/runQTL_01.sh $LINE; done
	
## Run genes

	cd /panfs/pfs.local/scratch/kelly/p860v026/qtl/out/$LINE

For each LINE need to launch 5000 jobs at a time. The gene names for this are in the genes*.txt files. The following script submits 5000 jobs per 40 min.

	sbatch brunQTL_02.sh $LINE

## Make data from output files

Once all genes run for a line

	sbatch ~/code/runQTL_03_gatherLod.sh $LINE

## Add cis-trans information




# Long Continuous read analysis

The working folders, read folders and naming are setup in `LCR_0_setup.sh`

Change the file to the QREADS_NAME to be used (eg 767).

The fasta reads need to be in two lines per sequence. Make if needed:

	perl ~/code/makeFastaOneLine.pl < in.fasta > out.fasta
	
## Split reads to many files

	sbatch ~/code/LCR_1_split_reads.sh $QREADS_NAME

## Map each split file in parallel

	cd $QREAD_FOLDER/$QREADS_NAME\mapping
	
	for i in $(ls *split*); do sbatch ~/code/LCR_2_minimap.sh $i; done
	
## Merge paf and remove large CIGAR-like columns
	
	sbatch ~/code/LCR_3_merge_paf.sh $QREADS_NAME

## Cleanup unwanted large files
	
	sbatch ~/code/LCR_4_cleanup.sh $QREADS_NAME

## Pull reads

	python ~/code/paf_read_puller.py 767.paf tig00000804_1 2262010 2263722 2226514 2234031