import sys

acceptable_size_ratios=[0.5,2.0]

# out1  =open("aligned.trans.txt", "w")

out2  =open("767_ruby.gff", "w")
out3  =open("not_in_ruby.gff", "w")

v5genes={}
in1  =open("V5.genes.txt", "r")
for line_idx, line in enumerate(in1):
	cols = line.replace('\n', '').split('\t') 
# Chr_01	A0001	82	5456
	v5genes[cols[1]]=[float(cols[3])-float(cols[2]),cols[0],cols[2],cols[3]]
in1.close()

print "v5genes",len(v5genes.keys())


ruby={}
rubygff={}
src  =open("767_p1lifted_cleaned.gff", "r")
for line_idx, line in enumerate(src):
	cols = line.replace('\n', '').split('\t') 
# tig00000045_1	phytozomev13	gene	9200005	9205332	.	+	.	ID=MgTOL.A0001.1.v5.0
	if cols[2]=="gene" or cols[2]=="mRNA":
		geneID=cols[8].split(".")[1]
		try:
			bx=ruby[geneID]
			size=int(cols[4])-int(cols[3])
			if size>=v5genes[geneID][0]*acceptable_size_ratios[0] and size<=v5genes[geneID][0]*acceptable_size_ratios[1]:
				if size>(ruby[geneID][2]-ruby[geneID][2]): # replae previous find
					ruby[geneID]=[cols[0],int(cols[3]),int(cols[4])]
					rubygff[geneID]=line

		except KeyError:
			size=int(cols[4])-int(cols[3])
			if size>=v5genes[geneID][0]*acceptable_size_ratios[0] and size<=v5genes[geneID][0]*acceptable_size_ratios[1]:
				ruby[geneID]=[cols[0],int(cols[3]),int(cols[4])]
				rubygff[geneID]=line
src.close()

print "v5genes",len(ruby.keys())
#build767={}
src  =open("v5.genes.in.767.txt", "r")
for line_idx, line in enumerate(src):
	cols = line.replace('\n', '').split('\t') 
# V5_chrom	gene	Build_sequence	MQ	qwidth	start	end	width
# Chr_06	F1185	tig00000722_1	5S105M2D360M74I36M18D7M5I218M4I207M15I249M17D234M8I22M3I295M3D6M10D17M4D9M1D348M	2227	5541867	5544034	2168
	if line_idx>0:
		#build767[cols[1]]=[cols[2],cols[5],cols[6]]
		size=int(cols[6])-int(cols[5])
		if size>=v5genes[geneID][0]*acceptable_size_ratios[0] and size<=v5genes[geneID][0]*acceptable_size_ratios[1]:
			try:
				am_i_ruby=rubygff[cols[1]]
			except KeyError:
				out3.write(cols[2]+'\tphytozomev13\tgene\t'+cols[5]+'\t'+cols[6]+'\t.\t+\t.\tID=MgTOL.'+cols[1]+'\n')

for geneID in rubygff:
	out2.write(rubygff[geneID])
	



