# Execute by: python seq_extractor.py fastafile readsList outputfile

from Bio import SeqIO
import sys

fastafile = sys.argv[1]
readsList = open(sys.argv[2], 'r')
outputfile = open(sys.argv[3], 'w')

wanted = set()
with readsList as f:
    for line in f:
        line = line.strip()
        if line != "":
            wanted.add(line)

fasta_sequences = SeqIO.parse(open(fastafile),'fasta')

with outputfile as i:
    for seq in fasta_sequences:
        if seq.id in wanted:
            SeqIO.write([seq], i, "fasta")

readsList.close()
outputfile.close()