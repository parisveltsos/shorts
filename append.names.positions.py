# run after trim.sams.py

import sys

infile=sys.argv[1] # exons.to.1034pac.txt # file from trim.sams.py

out1=open("augmented."+infile, "w")



info={}
in0=open("all14.exons.txt", "r")
for line_idx, line in enumerate(in0):
	cols = line.replace('\n', '').split('\t') 
	# Chr_01	0	82	133	ID=MgTOL.A0001.1.v5.0.CDS.10
	info[cols[0]+"_"+cols[1]] =cols[2]+'\t'+cols[3]+'\t'+cols[4][3:]

in1=open(infile, "r")
for line_idx, line in enumerate(in1):
	cols = line.replace('\n', '').split('\t') 
# V5_exon_loc	exonID	Build_sequence	start_pos	MQ	cigar
# 0	Chr_01_0	tig00001037	24330	18	51M
	if line_idx==0:
		out1.write( line.replace('\n', '')+'\tchrStart\tchrEnd\texonName\n')
	else:
		
		out1.write( line.replace('\n', '')+'\t'+info[cols[1]]+'\n')






