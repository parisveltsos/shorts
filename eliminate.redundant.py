import sys

infile =sys.argv[1] # the input file containing the mappings is identified at the command line

out1=open("slim."+infile,"w")

mappings={}
src=open(infile,"r") # read the 
for line_idx, line in enumerate(src):
        cols = line.replace('\n', '').split('\t') # split the line based on tabs

	if len(cols)==21: # ignore header
		if cols[9][0:2]=="Mg":
			geneID=cols[9].split(".")[1] # take gene name out of MgTOL.O0616.1

			try:
				x=mappings[geneID]
			except KeyError:
				mappings[geneID]=[] # create a libary to store unique mappings for this gene

			if len(mappings[geneID])==0:
				mappings[geneID].append( [cols[13], int(cols[15]), int(cols[16])] ) # T-name, T-start, T-end

			else:
				melded=0 # indicator to say if we have a new mapping or can meld with previous mapping
				tname=cols[13]
				tstart=int(cols[15])
				tend=int(cols[16])
				for j in range(len(mappings[geneID])): # compare this mapping to all previous locations stored for this gene
					if tname==mappings[geneID][j][0]: # same tilingii scaffold
						if tstart<mappings[geneID][j][1] and tend>mappings[geneID][j][2]: # encompasses previous mapping
							mappings[geneID][j][1]=tstart
							mappings[geneID][j][2]=tend
							melded=1
						elif tstart<mappings[geneID][j][1] and tend<=mappings[geneID][j][2]: # new start
							mappings[geneID][j][1]=tstart
							melded=1
						elif tstart>=mappings[geneID][j][1] and tend>mappings[geneID][j][2]: # new end
							mappings[geneID][j][2]=tend
							melded=1
						elif tstart>=mappings[geneID][j][1] and tend<=mappings[geneID][j][2]: # inside previous mapping
							melded=1

					if melded==1:
						break

				if melded==0:
					mappings[geneID].append([tname,tstart,tend])


# match	mis- 	rep. 	N's	Q gap	Q gap	T gap	T gap	strand	Q        	Q   	Q    	Q  	T        	T   	T    	T  	block	blockSizes 	qStarts	 tStarts
#      	match	match	   	count	bases	count	bases	      	name     	size	start	end	name     	size	start	end	count
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------
# 615	17	0	0	1	2	4	1365	+	MgTOL.O0616.1	640	6	640	53295	738930	506002	507999	5	105,343,70,47,67,	6,113,456,526,573,	506002,506117,506579,507884,507932,


for gene in mappings:
	for j in range(len(mappings[gene])):
		out1.write(gene+'\t'+mappings[gene][j][0]+'\t'+str(mappings[gene][j][1])+'\t'+str(mappings[gene][j][2])+'\n')




