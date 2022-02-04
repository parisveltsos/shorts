# Canu build
Run canu scripts

###

If there is a message 

	-- Consensus jobs failed, tried 2 times, giving up.
	--   job ctgcns/0012.cns FAILED.

Locate the consensus.sh file in the unitigging/5-consensus folder

	/home/jkk/scratch/PANFS-RESEARCH-JKKELLY/541.build.2.1/canu541/unitigging/5-consensus

Change the line 
	-pbdagcon \ 
to
	-norealign \

Run this script calling 

	sh concensus.sh [number]

# Busco

edit and run

sbatch ~/code/busco.sh 


# Contig statistics

In interactive job

	module load python
	
	python ~/code/contigs_statistics.py -f ~/temp/IM541/541.contigs.fasta -o 541
