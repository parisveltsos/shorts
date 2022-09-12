# Prep

	mkdir 3prime
	cd 3prime
	mkdir reads
	mkdir trimmed
	
Download files per individual from sequencing facility in `reads` folder.

## Concatenate fastq by ID
	
	for i in $(ls *gz | grep -v L002 | perl -pe 's/_S.+//g'); do cat $i* > $i.fastq.gz; done

# Fastq to reads and vcf

The working folders, reference assembly and gff and names are setup in `mim_setup.sh`

## Index genome

Generate an index for the genome to use with the STAR aligner. There are options with and without using a gff file.

	sbatch mim_01_index_genome.sh

## Trim the reads

This is run once per read file. First make a text file with the filenames, so that the jobs can be run in parallel.
	
	ls -laSh $OUTFOLDER/trimmed > list6hr
	
edit to just the filenames column, and run in parallel

	for i in $(cat list6hr); do sbatch ~/code/mim_02_trim_reads.sh $i; done

## Map trimmed reads to reference

This is run once per trimmed read file. First make a text file with the filenames, so that the jobs can be run in parallel.

Edit to just the filename column, but split in two files. list6hr has those < 3Gb, listjk > 3Gb, which take more than 6hr to run and need different slurm script settings. 

Try with one file to make sure it works well before submitting the parallel jobs

	cd mapped_to_$GENOMENAME
	
	for i in $(tail -1 list6hr); do sbatch ~/code/mim_03a_map_reads.sh $i; done

Once run, bam files should appear in $OUTFOLDER/mapped_to_$GENOMENAME

If all looks good, submit the parallel jobs

	for i in $(cat list6hr); do sbatch ~/code/mim_03a_map_reads.sh $i; done
	
	for i in $(cat listjk); do sbatch ~/code/mim_03b_map_reads.sh $i; done

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

### Make genotype file

Need to transfer the imputed genotypes from LM3 to the finalized maps. The script uses the contig_bp information which is identifies each SNP (it is unique) and a common field between the LM genotypes and the finalized maps.

Copy the manually fixed map (e.g. `1034.corr.map.txt`) to the LM3 output folder for a specific line.

Make the genotype file

	sbatch ~/code/runQTL_00_genoprep.sh $LINE

### Make phenotype (gene expression) file

The files from the voom transformation of the raw count data (`voomCounts.txt`, `voomWeights.txt`, `voomDesign.txt`) are split into data for a particular family, to be analysed separately by rqtl.

## QTL prep per line

This makes a R.project that loads all required files and estimates lod score threshold. The subsequent scanone step is run in parallel for all genes, using the same project.

	cd /panfs/pfs.local/scratch/kelly/p860v026/qtl/
	
	sbatch ~/code/runQTL_01.sh $LINE
	
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