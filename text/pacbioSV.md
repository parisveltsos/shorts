Installed smrtlink tools smrtlink_9.0.0.92188.run from https://www.pacb.com/support/software-downloads/ using

	./smrtlink_9.0.0.92188.run --rootdir smrtlink --smrttools-only

Unzip downloaded data file

	cd /home/p860v026/temp/pacbio
	tar xvf 3758.tar

Make chr_10_13 file

	cd /home/p860v026/temp/Mgutv5/assembly
	awk 'BEGIN{RS=">";FS="\n"}NR==FNR{a[$1]++}NR>FNR{if ($1 in a && $0!="") printf ">%s",$0}' listChr MguttatusTOL_551_v5.0.fa > chr_10_13.fasta

Align PacBio reads to a reference genome (Subreads BAM input)

	cd /home/p860v026/temp/pacBioSV
	
    /home/p860v026/temp/smrtlink/current/bundles/smrttools/smrtcmds/bin/pbmm2 align /home/p860v026/temp/Mgutv5/assembly/chr_10_13.fasta allReads.fastq.gz out.bam --sort --log-level INFO --log-level DEBUG --median-filter -j 8

Discover SV features

	/home/p860v026/temp/smrtlink/current/bundles/smrttools/smrtcmds/bin/pbsv discover out.bam out.svsig.gz --log-level INFO

Call SV and assign genotypes

	/home/p860v026/temp/smrtlink/current/bundles/smrttools/smrtcmds/bin/pbsv call /home/p860v026/temp/Mgutv5/assembly/chr_10_13.fasta out.svsig.gz out.var.vcf --log-level INFO
	
	
	 -m,--min-sv-length                          STR   Ignore variants with
                                                    length < N bp. [20]
  --min-cnv-length                            STR   Ignore CNVs with
                                                    length < N bp. [1K]
  --max-ins-length                            STR   Ignore insertions
                                                    with length > N bp.
                                                    [10K]
  --max-dup-length                            STR   Ignore duplications
                                                    with length > N bp.
                                                    [100K]
                                                    
  --cluster-max-length-perc-diff              INT   Do not cluster
                                                    signatures with
                                                    difference in length
                                                    > P%. [25]
  --cluster-max-ref-pos-diff                  STR   Do not cluster
                                                    signatures > N bp
                                                    apart in reference.
                                                    [200]
  --cluster-min-basepair-perc-id              INT   Do not cluster
                                                    signatures with
                                                    basepair identity <
                                                    P%. [10]
                                                    
  -A,--call-min-reads-all-samples             INT   Ignore calls
                                                    supported by < N
                                                    reads total across
                                                    samples. [2]
  --gt-min-reads                              INT   Minimum supporting
                                                    reads to assign a
                                                    sample a
                                                    non-reference
                                                    genotype. [1]
  --annotations                               FILE  Annotate variants by
                                                    comparing with
                                                    sequences in
                                                    fasta.Default
                                                    annotations are ALU,
                                                    L1, SVA.                                                                                                                                                                                                                

                                                    L1, SVA.
  --annotation-min-perc-sim                   INT   Annotate variant if
                                                    sequence similarity
                                                    > P%. [60]
  --min-N-in-gap                              STR   Consider >= N
                                                    consecutive "N" bp
                                                    as a reference gap.
                                                    [50]
  --filter-near-reference-gap                 STR   Flag variants < N bp
                                                    from a gap as
                                                    "NearReferenceGap".
                                                    [1K]
  --filter-near-contig-end                    STR   Flag variants < N bp
                                                    from a contig end as
                                                    "NearContigEnd".
                                                    [1K]
# zaba

     $ pbmm2 align ref.fa movie1.subreads.bam ref.movie1.bam --sort --median-filter --sample sample1

     CCS BAM input:
     $ pbmm2 align ref.fa movie1.ccs.bam ref.movie1.bam --sort --preset CCS --sample sample1

     CCS FASTQ input:
     $ pbmm2 align ref.fa movie1.Q20.fastq ref.movie1.bam --sort --preset CCS --sample sample1 --rg '@RG\tID:movie1'

  2. Discover signatures of structural variation (per movie or per sample):
     $ pbsv discover ref.movie1.bam ref.sample1.svsig.gz
     $ pbsv discover ref.movie2.bam ref.sample2.svsig.gz

  3. Call structural variants and assign genotypes (all samples), for CCS input append "--ccs":
     $ pbsv call ref.fa ref.sample1.svsig.gz ref.sample2.svsig.gz ref.var.vcf
     
     
     
     # Convert bam to fastq

	bam2fastq -o pb541 .subreads.bam 
