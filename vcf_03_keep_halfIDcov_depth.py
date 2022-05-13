import sys

if len(sys.argv)!=3:
	print "\nUsage: \npython vcf_03_keep_halfIDcov_depth.py vcfName 5\nThis script requires at least half individuals to have data and above given coverage threshold."
	sys.exit()
	
vcfName = sys.argv[1]
vcfName2 = vcfName.split('.')

mindepth=int(sys.argv[2])

src = open("slim1_" + vcfName2[0] + ".vcf", "r")
	
out1 = open("slim1_" + vcfName2[0] + "_genotypes.txt", "w")
out2 =open(vcfName2[0] + "_covered_loci.txt", "w")

family={}
typeX={}
genos={}
name={}
in1 = open("key_" + vcfName2[0] + ".txt", "r")
for line_idx, line in enumerate(in1):
	cols = line.replace('\n', '').split('\t') 
# vcf_pos	sample_name	family	id	type
# 9	s12_1192-39.bam	1192	39	F2
# 10	s12_1192-P4.bam	1192	P4	P
	if line_idx>0:
		family[int(cols[0])]=cols[2]
		typeX[int(cols[0])]=cols[4]
		genos[int(cols[0])]=[0,0,0]
		name[int(cols[0])]=cols[1]
			
in1.close()

nx = len(family.keys())

snpcc=[0,0]
for line_idx, line in enumerate(src):
        cols = line.replace('\n', '').split('\t')
        if cols[0]=="#CHROM":
                pass

        else:  
                cc=0
		snpcc[0]+=1
                for x in range(9,len(cols)):
			GT=cols[ x ].split(":")[0] # 1/1:101,14,0:1,12 but also really weird shit:: 1/1:0,9,0:26,25	0/0:0,5,5:3,1
			if GT != "./.":
				cc+=1
		if cc>=nx/2: # coverage at least half individuals
			out2.write(cols[0]+"\t"+cols[1]+"\n")
			snpcc[1]+=1
		        for x in range(9,len(cols)):
				GT=cols[ x ].split(":")[0] # 1/1:101,14,0:1,12 but also really weird shit:: 1/1:0,9,0:26,25	0/0:0,5,5:3,1
				pl1=cols[ x ].split(":")[1]
				ad1=cols[ x ].split(":")[2]
				readdepth = int(ad1.split(",")[0])+int(ad1.split(",")[1])
				if GT != "./." and readdepth>= mindepth:
					if len(pl1.split(","))==3 and len(ad1.split(","))==2:
						gl=[int(pl1.split(",")[0]),int(pl1.split(",")[1]),int(pl1.split(",")[2])]
						if GT =="0/0" and gl[0]==0 and gl[1]>0 and gl[2]>0:
							genos[ x ][0]+=1 # '0/0'
						elif GT =="1/1" and gl[2]==0 and gl[1]>0 and gl[0]>0:
							genos[ x ][2]+=1 # '1/1'
						elif GT =="0/1" and gl[1]==0 and gl[2]>0 and gl[0]>0:
							genos[ x ][1]+=1 # '0/1'

for j in range(9,len(cols)):
	out1.write(str(j)+'\t'+name[j]+'\t'+family[j]+'\t'+typeX[j]+'\t'+str(genos[j][0])+'\t'+str(genos[j][1])+'\t'+str(genos[j][2])+'\n')


print "at least half",snpcc


