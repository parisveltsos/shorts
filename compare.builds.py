import sys

in0=open("All14.v5.exons.fa","r")

in1=open(sys.argv[1],"r") # exons_444.contigs.txt
in2=open(sys.argv[2],"r") # exons_444.purged.txt

out1=open("contrast.txt", "w")


exoninfo={}
for line_idx, line in enumerate(in0):
	cols = line.replace('\n', '').split('\t') 
# >Chr_01_0
# TTGTGCTTCTTCTTGCCAGAATCGAAAGACGCAATTACACCCTCATAAAAC
	if line[0]==">":
		exoninfo[cols[0][1:]]={1:[],2:[]}



for line_idx, line in enumerate(in1):
	cols = line.replace('\n', '').split('\t') 
# V5_exon_loc	exonID	Build_sequence	start_pos	MQ	cigar
# 0	Chr_01_0	tig00001037	24330	18	51M
	if line_idx>0:
		exoninfo[cols[1]][1].append(int(cols[4]))



for line_idx, line in enumerate(in2):
	cols = line.replace('\n', '').split('\t') 
# V5_exon_loc	exonID	Build_sequence	start_pos	MQ	cigar
# 0	Chr_01_0	tig00001037	24330	18	51M
	if line_idx>0:
		exoninfo[cols[1]][2].append(int(cols[4]))


changes=[]
outcomes={}
for z in exoninfo:
	a1 = len(exoninfo[z][1])
	a2 = len(exoninfo[z][2])
	if a1==1 and a2==1:
		changes.append(exoninfo[z][2][0]-exoninfo[z][1][0])
	try:
		outcomes[str(a1)+"_"+str(a2)]+=1
	except KeyError:
		outcomes[str(a1)+"_"+str(a2)]=1			

for z in outcomes:
	print z, outcomes[z]

print "mean change",sum(changes)/float(len(changes))
for x in range(len(changes)):
	if changes[x] != 0:
		out1.write(str(changes[x])+'\n')

