Edit paths in syri_00_setup.sh

Make 767 pseudo chromosomes file. 

Determine the orientation of purged assemblies relative to 767 pseudochromosome assembly.

Copy pseudochromosome assembly of 767 and make 50 longest contigs fasta of query genome in a new working folder. 

	sbatch ~/code/syri_01_prep_genomes.sh 664

	for LINE in $(echo -e "62\t155\t444\t502\t541\t664\t909\t1034\t1192"); do sbatch ~/code/syri_01_prep_genomes.sh $LINE; done

Mummer align 767 pseudo chromosomes with contigs of other purged assembly 

	for LINE in $(echo -e "62\t155\t444\t502\t541\t664\t909\t1034\t1192"); do sbatch ~/code/syri_02_mummerA.sh $LINE; done
	
Look at `out1.filtered.coords` and manually make pseudochromosomes for purged assembly, orienting appropriately the contigs ans joining them with 10,000 SNPs. Eg script 
`make1192Pseudo.txt`.

Use SyRI to generate pseudo assembly of query genome.





# SyRI installation

	conda create -n syri_env -c bioconda syri python=3.5
