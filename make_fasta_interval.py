#!/usr/bin/env python

# samtools faidx genome.fasta
# cut -f1-2 genome.fasta.fai > fasta_sizes.txt

import sys

commandsFile = open("fasta_sizes.txt", 'w') 
window = 100000


lastbase = {}
in1 = open("fasta_interval.txt","r")
for line_idx, line in enumerate(in1):
	cols = line.replace('\n', '').split('\t')
# chr3R	32079331
	lastbase[cols[0]]=int(cols[1])


for chrom in lastbase:

	pos=0
	while pos < lastbase[chrom]:
		st=pos+1
		end=pos+window
		if end>lastbase[chrom]:
			end=lastbase[chrom]
		interval = chrom+":"+str(st)+"-"+str(end)+"\n"

		commandsFile.write(interval)

		pos+=window


