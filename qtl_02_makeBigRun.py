#!/usr/bin/env python
import sys

commandsFile = open("bigrun.sh", 'w')

in11=open("qtl_02b_genes.txt","r") # loci to be inspected later
for line_idxx, liner in enumerate(in11):
	cole = liner.replace('\n', '').split('\t') 
# A0001	1	48915	tig00000045_1	9200005	9205332 
	geneid=cole[0]
	if line_idxx % 10 == 0:
		sampleName = "x"+str(line_idxx) #

		shellScriptName = 'r%s.sh' % (sampleName)
		shellScript = open(shellScriptName, 'w' )

		commandsFile.write('sbatch %s \n' % (shellScriptName))

		shellScript.write("#!/bin/bash\n" )
		shellScript.write("#SBATCH --job-name=%s\n" % (sampleName))

		shellScript.write("#SBATCH --partition=sixhour       \n" )
		shellScript.write("#SBATCH --time=0-5:59:00        \n" )
		shellScript.write("#SBATCH --mem-per-cpu=3gb           \n" )

		shellScript.write("#SBATCH --mail-type=NONE          \n" )
		shellScript.write("#SBATCH --mail-user=p860v026@ku.edu    \n" )
		shellScript.write("#SBATCH --ntasks=1                   \n" )
		shellScript.write("#SBATCH --cpus-per-task=1            \n" )
		shellScript.write("#SBATCH --output=k_%s.log\n\n\n" % sampleName )
		shellScript.write("module load R\n")

	shellScript.write("Rscript ~/code/qtl_03b_runGene_long.r 664 %s\n" % geneid )
	shellScript.write("Rscript ~/code/qtl_03a_runGene_short.r 664 %s\n" % geneid )

in11.close()



