# contigs_statistics.py
#---
# Written by Rodrigo Bacigalupe. MSc in Bioinformatics student.
# University of Edinburgh.
#---
# CONTIG STATISTICS: This program is based on contig_stats.pl. It takes one fasta file (presumably
# obtained from a metagenome assembler) and one threshold value as input and calculates contig or
# scaffold metrics. Assembly capacity metrics such as number of contigs, total number of bases, 
# the  average size, the maximum contigh length. It also calculates some stats of contiguity
# such as the N50 values or contigs in N50.

#-------------------------------------------------------------------------------------------------
# Modules to use regular expressions and command line arguments.
import re
import sys
# Modules to deal with the file system.
import os
# Module to run external programms.
import subprocess
# Module to parse arguments
import argparse
# Biopython modules
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.Alphabet import IUPAC

# Print out a message when the program is initiated.
#print('----------------------------------------------------------------\n')
#print('                    Contigs Statistics 1.0.\n')
#print('----------------------------------------------------------------\n')

#----------------------------------- PARSE SOME ARGUMENTS ----------------------------------------
parser = argparse.ArgumentParser(description='Calculate metrics for contigs and scaffolds.')
parser.add_argument("-f", "--fasta", help="introduce the name of the fasta file")
parser.add_argument("-t", "--threshold", type=int, default=0, help="introduce the optional threshold values")
parser.add_argument("-o", "--output", type=str, default="contigs_filtered", help="introduce the name of the output file")
args = parser.parse_args()
# Variable that stores fasta sequences
fasta_file = args.fasta
# Variable to store threshold value
threshold = args.threshold
# Variable to store the name of the output file
output = str(args.output)

#----------------------------------- CALCULATE STATS ----------------------------------------
# Define a function that takes the fasta file and the threshold value as input and returns
# all the metrics as output

def assemblymetrics(fasta_file, threshold):
   handle = open(str(fasta_file), "rU")
   # Variables to store stats
   numcontigs = 0
   numbases = 0
   maxlength = 0
   GCbases = 0
   nonATCG = 0
   n50 = 0
   contigsn50 = 0
   cumulative = 0
   seqlengths = list()
   # Iterate through every contig in the fasta file
   for record in SeqIO.parse(handle, "fasta"):
      # Determine size of contigs to analyse
      if len(record.seq) >= threshold:
         numcontigs = numcontigs + 1
         numbases = numbases + len(record.seq)
         for base in (record.seq):
            if base in "GgCc":
               GCbases = GCbases + 1
            if base not in "ATCGatcg":
               nonATCG = nonATCG + 1
         seqlengths.append(len(record.seq))
   if seqlengths:
      seqlengths.sort(reverse=True)
      maxlength = seqlengths[0]
      for length in seqlengths:
         if cumulative < numbases/2:
            cumulative = cumulative + length
            n50 = length
   contigsn50 = sum(1 for i in seqlengths if i >= n50)

   return numcontigs, numbases, maxlength, GCbases, nonATCG, n50, contigsn50
   handle.close()

#Calculate the metrics
assembly_metrics = assemblymetrics(fasta_file, threshold)

# Split the file into individual metrics
num_contigs, num_bases, max_length, GC_bases, non_ATCG, n50, contigsn50 = assembly_metrics
if num_bases != 0:
   GC_content = GC_bases*100.0/num_bases
else: 
   GC_content = 0.0

if num_contigs != 0:
   aver_size = num_bases/num_contigs
else: 
   aver_size = 0.0


#--------------------------------------- PRINT THE RESULTS -----------------------------------------
results1 = ("Output	Threshold	Num contigs	Total bases in contigs	Average size	Maximum contig length	N50 for contigs	Contigs in N50	GC content	nonATGC in contigs")
results2=(output+"	"+str(threshold)+"	"+str(num_contigs)+"	"+str(num_bases)+"	"+str("%.2f" % aver_size)+"	"+str(max_length)+"	"+str(n50)+"	"+str(contigsn50)+"	"+str("%.2f" % GC_content)+"	"+str(non_ATCG))
print(results1+"\n"+results2)
#----------------------------------- SAVE THE OUTPUT IN A FILE --------------------------------------
# Create the directory where output files will be stored
if os.path.exists('output_dir/'):
   if os.path.exists('output_dir/'+output+"_"+str(threshold)):
       os.remove('output_dir/'+output+"_"+str(threshold))
else:
   os.mkdir('output_dir')

# Create a file to save the output with the name given by the user, open it and indicate it will 
# be a text file (wt).
file = open('./output_dir/'+output+"_"+str(threshold), 'wt')

# Write all the elements of the filtered list to a text file
file.write(results1+"\n"+results2)
# close the file
file.close
