#!/bin/bash
#SBATCH --job-name=LCR2      # Job name
#SBATCH --partition=sixhour
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=12
#SBATCH --mem=10Gb                     # Job memory request
#SBATCH --time=0-02:59:00             # Time limit days-hrs:min:s
#SBATCH --output=R-%x.%j.log   # Standard output and error log

source ~/code/LCR_0_setup.sh

module load samtools
module load python

~/code/vulcan.py -clr -t 12 -r $REF_FOLDER/$REF_GENOME -i $QREADS_NAME -w $QREADS_NAME\_temp -o $QREADS_NAME\_temp

samtools view -h -o $QREADS_NAME\_temp_90.sam $QREADS_NAME\_temp_90.bam

k8 /home/p860v026/bin/minimap-2/misc/paftools.js sam2paf $QREADS_NAME\_temp_90.sam > $QREADS_NAME.paf

# {Fu et al., 2021, #234109# }







# minimap2 -x ava-pb -t 12 $REF_FOLDER/$REF_GENOME $QREADS > $QREADS_OUT\_$REF_GENOME_NAME.paf

# samtools sort $QREADS_OUT\_$REF_GENOME_NAME.sam -o $QREADS_OUT\_$REF_GENOME_NAME.bam

# samtools index $QREADS_OUT\_$REF_GENOME_NAME.bam
