import sys

infile=sys.argv[1] # exons.to.1034pac

out1=open(infile+".txt", "w")


out1.write("V5_exon_loc\texonID\tBuild_sequence\tstart_pos\tMQ\tcigar\n")
in1=open(infile+".sam", "r")
for line_idx, line in enumerate(in1):
	cols = line.replace('\n', '').split('\t') 
# Chr_02_2328	0	70594	21733	60	148M	*	0	0	GTGGACCAATTTTTTGAGTGCTTTGATGGACTAAGAAATTCGCAGTCAGCTTTGGGGAATAGTGGCATGTGGAATTGGACTTGCTCTGTGTTTAGTGCAATAACTGCAGCATCCAATCTTGCCTCTGGATCTTTACATGTCCCTTCTG	*	NM:i:0	ms:i:296	AS:i:296	nn:i:0	tp:A:P	cm:i:16	s1:i:144	s2:i:0

	if cols[0]=="@SQ":
		pass
		
	elif cols[0][0]=="C":
		vv=cols[0].split("_")
		out1.write(vv[2]+"\t"+cols[0]+"\t"+cols[2]+"\t"+cols[3]+"\t"+cols[4]+"\t"+cols[5]+'\n')


