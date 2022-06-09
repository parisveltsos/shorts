#!/usr/bin/env python

import sys

commandsFile = open("cxi.sh", 'w') 

for j in range(9,1940):

	sampleName = str(j)
	shellScriptName = 'r%s.sh' % (str(j))
	shellScript = open(shellScriptName, 'w' )

	commandsFile.write('sbatch %s \n' % (shellScriptName))

	shellScript.write("#!/bin/bash\n" )
	shellScript.write("#SBATCH --job-name=%s\n" % (sampleName))

	shellScript.write("#SBATCH --partition=sixhour       \n" )
	shellScript.write("#SBATCH --time=0-5:59:00        \n" )
	shellScript.write("#SBATCH --mem-per-cpu=5gb           \n" )

	shellScript.write("#SBATCH --mail-type=NONE          \n" )
	shellScript.write("#SBATCH --mail-user=jkk@ku.edu    \n" )	
	shellScript.write("#SBATCH --ntasks=1                   \n" )	
	shellScript.write("#SBATCH --cpus-per-task=1            \n" )
	shellScript.write("#SBATCH --output=rx_%s.log\n\n\n" % sampleName )

	shellScript.write("python paris_4.py %s\n" %(str(j)))
