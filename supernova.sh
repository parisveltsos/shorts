#!/bin/bash
#SBATCH --job-name=supernova                # Job name
#SBATCH --partition=kelly               # Partition Name (Required) eeb sixhour
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu   # Where to send mail 
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=14
#SBATCH --mem-per-cpu=6g                    # Job memory request
#SBATCH --time=2-59:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=out_sup_%j.log         # Standard output and error log

# for i in $(echo -e "SF"); do sbatch supernova.sh $i; done

echo "Running"

cd /home/p860v026/temp/10x/$1

# ~/bin/supernova-2.1.1/supernova testrun --id=tiny

/home/p860v026/temp/bin/supernova-2.1.1/supernova run --id=$1 --fastqs=/home/p860v026/temp/10x/$1 --localcores=14 --localmem=140 --maxreads 168000000

/home/p860v026/temp/bin/supernova-2.1.1/supernova mkoutput --style=pseudohap --asmdir=/home/p860v026/temp/10x/$1/$1/outs/assembly --outprefix=$1
    
# Info on options https://support.10xgenomics.com/de-novo-assembly/software/pipelines/latest/output/generating

date

