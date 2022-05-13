# :: divergence of a plant from all categories of plants
import sys

mindepth=5

pltID  =  int(sys.argv[1]) # number from 9 to 1939

src  =open("slim1_v5.vcf", "r")

plt_type={}
Divergence={}
name={}
in1 = open("key.txt","r") # only include samples OK for heterozygosity
for line_idx, line in enumerate(in1):
	cols = line.replace('\n', '').split('\t') 
# POS v5.vcf	sample	FAM	type			
# 9	s1_1192-1.bam	1192	F2
	if line_idx>0:
		family_type=cols[2]+"_"+cols[3]
		plt_type[int(cols[0])]=family_type
		Divergence[family_type]=[0,0.0]
		name[int(cols[0])]=cols[1]
			
in1.close()


good_snp={}
in1 = open("Covered_loci.txt","r") # only include samples OK for heterozygosity
for line_idx, line in enumerate(in1):
	cols = line.replace('\n', '').split('\t') 
# Chr_01:1-100000.vcf:Chr_01	128
	good_snp[cols[0]+"_"+cols[1]]=1
			
in1.close()

out1 =open(name[pltID]+".divergence.txt", "w")


snpcc=[0,0]
for line_idx, line in enumerate(src):
        cols = line.replace('\n', '').split('\t')
        if cols[0]=="#CHROM":
                
                for j in range(9,len(cols)):
                        print j,cols[j]


        else:  
		try:
			uk=good_snp[cols[0]+"_"+cols[1]]
			
			x = pltID
			GT=cols[ x ].split(":")[0] # 1/1:101,14,0:1,12 but also really weird shit:: 1/1:0,9,0:26,25	0/0:0,5,5:3,1
			pl1=cols[ x ].split(":")[1]
			ad1=cols[ x ].split(":")[2]
			readdepth = int(ad1.split(",")[0])+int(ad1.split(",")[1])
			call=-9
			if GT != "./." and readdepth>= mindepth:
				if len(pl1.split(","))==3 and len(ad1.split(","))==2:
					gl=[int(pl1.split(",")[0]),int(pl1.split(",")[1]),int(pl1.split(",")[2])]
					if GT =="0/0" and gl[0]==0 and gl[1]>0 and gl[2]>0:
						call=0 # '0/0'
					elif GT =="1/1" and gl[2]==0 and gl[1]>0 and gl[0]>0:
						call=2  # '1/1'
					elif GT =="0/1" and gl[1]==0 and gl[2]>0 and gl[0]>0:
						call=1  # '0/1'

			if call>=0:
				for x in range(9,len(cols)):
					if x != pltID:
						GT=cols[ x ].split(":")[0] # 1/1:101,14,0:1,12 but also really weird shit:: 1/1:0,9,0:26,25	0/0:0,5,5:3,1
						pl1=cols[ x ].split(":")[1]
						ad1=cols[ x ].split(":")[2]
						readdepth = int(ad1.split(",")[0])+int(ad1.split(",")[1])
						gcall=-9
						if GT != "./." and readdepth>= mindepth:
							if len(pl1.split(","))==3 and len(ad1.split(","))==2:
								gl=[int(pl1.split(",")[0]),int(pl1.split(",")[1]),int(pl1.split(",")[2])]
								if GT =="0/0" and gl[0]==0 and gl[1]>0 and gl[2]>0:
									gcall=0 # '0/0'
								elif GT =="1/1" and gl[2]==0 and gl[1]>0 and gl[0]>0:
									gcall=2 # '1/1'
								elif GT =="0/1" and gl[1]==0 and gl[2]>0 and gl[0]>0:
									gcall=1 # '0/1'
							if gcall>=0:
								Divergence[ plt_type[x] ][0]+=1
								Divergence[ plt_type[x] ][1]+=float( (call-gcall)**2 )
		except KeyError:
			pass

for family_type in Divergence:
	if Divergence[family_type][0]>0:
		Divergence[family_type][1]=Divergence[family_type][1]/float(Divergence[family_type][0])
		out1.write(str(pltID)+'\t'+name[pltID]+'\t'+family_type+'\t'+str(Divergence[family_type][0])+'\t'+str(Divergence[family_type][1])+'\n')





