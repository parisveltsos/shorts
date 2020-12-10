#!/bin/bash
#SBATCH --job-name=jelly                # Job name
#SBATCH --partition=sixhour               # Partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=12gb                     # Job memory request
#SBATCH --time=0-05:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_jelly_%j.log         # Standard output and error log

# replaced by kmc.sh
# for i in $(echo -e "IM125\nIM274\nSF\nIM62\nIM767"); do sbatch jellyfish.sh $i; done

# instructions, and upload file to http://qb.cshl.edu/genomescope/

module load jellyfish

echo "Running"

cd /home/p860v026/temp/10x/$1

pwd; hostname; date

# jellyfish count -m 21 <(gzip -dc *fastq.gz) -o $1\_21.counts -C -s 2000000000 -U 500 -t 8 

jellyfish histo -t 8 $1\_21.counts > $1\_21.counts.histo 

date

