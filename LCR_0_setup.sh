# !/bin/bash -l
#SBATCH --job-name=LCR1      # Job name
#SBATCH --partition=sixhour
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                   # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem=1Gb                     # Job memory request
#SBATCH --time=0-00:59:00             # Time limit days-hrs:min:s
#SBATCH --output=R-%x.%j.log   # Standard output and error log

REF_FOLDER=/panfs/pfs.local/work/kelly/p860v026/Final.builds
REF_GENOME=767.final.fa
REF_GENOME_NAME=$(basename -s .final.fa $REF_GENOME)

QREAD_FOLDER=/panfs/pfs.local/work/kelly/p860v026/longReads
TEMP_FOLDER=/panfs/pfs.local/scratch/kelly/p860v026/minimap

QREADS_NAME=$1
LCONTIG=$2
QREADS=$2
QREADS_OUT=$(basename -s .fasta $QREADS)
WDIR=$QREADS_NAME\mapping

