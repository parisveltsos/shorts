import sys

family = sys.argv[1]

in_vcf = open("pool1.vcf", "r")

out_snps = open(family + ".snps2.txt", "w")
out_stats = open(family + ".stats2.txt", "w")
out_vcf = open(family + "clean.vcf", "w")

#  Criteria for inclusion
Min_key = 2 # min calls for 767 to assign genotype
Min2 = 2 # min calls for other parental line to assign genotype
samples = 352
mindepth = 3

father = "664-P5_S35.sorted.bam"
mother = "767-P2_S43.sorted.bam"

def parsefield( data ):
	GT=data.split(":")[0] # 1/1:101,14,0:1,12
	pl1=data.split(":")[1]
	ad1=data.split(":")[2]

	return GT,pl1,ad1

x767 = []
xline = []
xF2 = []
amibad = {}
in_key = open("key.txt","r")

for line_idx, line in enumerate(in_key):
	cols = line.replace('\n', '').split('\t')
# vcf_pos	sample_name	Family	ID	type
# 9	1192-100_S164.sorted.bam	1192	100	F2
	if line_idx > 0:
		if cols[4]=="767":
			x767.append(int(cols[0]))

		elif cols[4]=="Parental_line" and cols[2]==family:
			xline.append(int(cols[0]))

		elif cols[4]=="F2" and cols[2]==family:
			xF2.append(int(cols[0]))
			amibad[int(cols[0])]=[0,0] # number of times agree, number of times disagree
in_key.close()

print "number (P 767, P",family, ", F2",family,"):", len(x767),len(xline),len(xF2)

for line_idx, line in enumerate(in_vcf):
	cols = line.replace('\n', '').split('\t')
	if '##' in line:
		out_vcf.write(line)

	if '#CHROM' in line:
		lineTemp = [cols[0] + '\t' + cols[1] + '\t' + cols[2] + '\t' + cols[3] + '\t' + cols[4] + '\t' + cols[5] + '\t' + cols[6] + '\t' + cols[7] + '\t' + cols[8]]
		for x in x767:
			lineTemp.append(cols[x])
		for x in xline:
			lineTemp.append(cols[x])
		for x in xF2:
			lineTemp.append(cols[x])
		out_vcf.write('\t'.join([str(x) for x in lineTemp]) + '\n')

	if len(cols)==9+samples: # skip headers
# Chr_01	20079	.	T	C	43.1495	.	DP=9373;VDB=1.83927e-32;SGB=-143.472;RPB=2.08262e-21;MQB=1;BQB=2.55912e-09;MQ0F=0;ICB=0.000173123;HOB=8.54372e-05;AC=2;AN=306;DP4=0,9065,0,88;MQ=20	GT:PL:AD	./.:0,0,0:0,0	0/0:0,30,88:10,0	./.:0,0,0:0,0	./.:0,0,0:0,0	./.:0,0,0:0,0	./.:0,0,0:0,0	./.:0,0,0:0,0	0/0:0,6,36:2,0	0/0:0,255,101:106,0	0/0:0,108,86:36,0	0/0:0,6,36:2,0	0/0:0,255,159:233,0	0/0:0,255,147:213,0
		if len(cols[3])==1 and len(cols[4])==1:  # require line to be bi-allelic SNP
			lineTemp = [cols[0] + '\t' + cols[1] + '\t' + cols[2] + '\t' + cols[3] + '\t' + cols[4] + '\t' + cols[5] + '\t' + cols[6] + '\t' + cols[7] + '\t' + cols[8]]
			g={"0/0":0,"0/1":0,"1/1":0}
			for x in x767:
				GT,pl1,ad1 = parsefield(cols[x])
				if len(pl1.split(","))==3 and len(ad1.split(","))==2:
					m1 = int(ad1.split(",")[0]) + int(ad1.split(",")[1])
					gl = [int(pl1.split(",")[0]), int(pl1.split(",")[1]), int(pl1.split(",")[2])]
					if GT =="0/0" and gl[0]==0 and gl[1]>0 and gl[2]>0 and m1>=mindepth:
						g[GT]+=1
						lineTemp.append(GT + ':' + pl1 + ':' + ad1)
					elif GT =="1/1" and gl[2]==0 and gl[1]>0 and gl[0]>0 and m1>=mindepth:
						g[GT]+=1
						lineTemp.append(GT + ':' + pl1 + ':' + ad1)
					elif GT =="0/1" and gl[1]==0 and gl[2]>0 and gl[0]>0 and m1>=mindepth:
						g[GT]+=1
						lineTemp.append(GT + ':' + pl1 + ':' + ad1)
					else:
						lineTemp.append("./." + ':' + pl1 + ':' + ad1)
				if GT != "./.":
					out_snps.write(cols[0]+'\t'+cols[1]+'\t'+cols[3]+'\t'+cols[4]+'\t'+str(g["0/0"])+","+str(g["0/1"])+","+str(g["1/1"]))

			c767="U"
			if g["0/0"]>=Min_key and g["0/1"]==0 and g["1/1"]==0:
				c767="R"
			elif g["1/1"]>=Min_key and g["0/1"]==0 and g["0/0"]==0:
				c767="A"

			g={"0/0":0,"0/1":0,"1/1":0}
			for x in xline:
				GT,pl1,ad1 = parsefield(cols[x])
				if len(pl1.split(","))==3 and len(ad1.split(","))==2:
					m1 = int(ad1.split(",")[0]) + int(ad1.split(",")[1])
					gl = [int(pl1.split(",")[0]), int(pl1.split(",")[1]), int(pl1.split(",")[2])]
					if GT =="0/0" and gl[0]==0 and gl[1]>0 and gl[2]>0 and m1>=mindepth:
						g[GT]+=1
						lineTemp.append(GT + ':' + pl1 + ':' + ad1)
					elif GT =="1/1" and gl[2]==0 and gl[1]>0 and gl[0]>0 and m1>=mindepth:
						g[GT]+=1
						lineTemp.append(GT + ':' + pl1 + ':' + ad1)
					elif GT =="0/1" and gl[1]==0 and gl[2]>0 and gl[0]>0 and m1>=mindepth:
						g[GT]+=1
						lineTemp.append(GT + ':' + pl1 + ':' + ad1)
					else:
						lineTemp.append("./." + ':' + pl1 + ':' + ad1)
				if GT != "./.":
					out_snps.write('\t'+str(g["0/0"])+","+str(g["0/1"])+","+str(g["1/1"]))

			cP="U"
			if g["0/0"]>=Min2 and g["0/1"]==0 and g["1/1"]==0:
				cP="R"
			elif g["1/1"]>=Min2 and g["0/1"]==0 and g["0/0"]==0:
				cP="A"

			cat=-9 # negative is what John chooses when he does not have a better choice
			if c767=="R" and cP=="R":
				out_snps.write('\tpredict_R')
				cat="R"
			elif c767=="A" and cP=="A":
				out_snps.write('\tpredict_A')
				cat="A"
			elif (c767=="R" and cP=="A") or (c767=="A" and cP=="R"):
				out_snps.write('\tpredict_poly')
			else:
				out_snps.write('\tAmbiguous')

			g={"0/0":0,"0/1":0,"1/1":0}
			for x in xF2:
				vv = cols[x].split(":")
				GT,pl1,ad1 = parsefield(cols[x])
				if len(pl1.split(","))==3 and len(ad1.split(","))==2:
					m1 = int(ad1.split(",")[0]) + int(ad1.split(",")[1])
					gl = [int(pl1.split(",")[0]), int(pl1.split(",")[1]), int(pl1.split(",")[2])]
					if GT =="0/0" and gl[0]==0 and gl[1]>0 and gl[2]>0 and m1>=mindepth:
						g[GT]+=1
						lineTemp.append(GT + ':' + pl1 + ':' + ad1)
					elif GT =="1/1" and gl[2]==0 and gl[1]>0 and gl[0]>0 and m1>=mindepth:
						g[GT]+=1
						lineTemp.append(GT + ':' + pl1 + ':' + ad1)
					elif GT =="0/1" and gl[1]==0 and gl[2]>0 and gl[0]>0 and m1>=mindepth:
						g[GT]+=1
						lineTemp.append(GT + ':' + pl1 + ':' + ad1)
					else:
						lineTemp.append('./.' + ':' + pl1 + ':' + ad1)
				if GT != "./.":
					if cat=="R":
						if vv[0]=="0/0":
							amibad[x][0]+=1 # add to count of good
						else:
							amibad[x][1]+=1 # add to count of bad
					elif cat=="A":
						if vv[0]=="1/1":
							amibad[x][0]+=1 # add to count of good
						else:
							amibad[x][1]+=1 # add to count of bad

			out_vcf.write('\t'.join([str(j) for j in lineTemp]) + '\n')
			out_snps.write('\t' + str(g["0/0"]) + "," + str(g["0/1"]) + "," + str(g["1/1"]) + '\n')

newlist=[]
for f2id in amibad:
	if amibad[f2id][0] + amibad[f2id][1] > 0:
		frac_good=round(float(amibad[f2id][1]) / float(amibad[f2id][0] + amibad[f2id][1]), 2)
		newlist.append([frac_good, str(f2id) + '\t' + str(amibad[f2id][0]) + '\t' + str(amibad[f2id][1]) + '\n'])
	else:
		frac_good=-9
		newlist.append([frac_good, str(f2id) + '\t' + str(amibad[f2id][0]) + '\t' + str(amibad[f2id][1]) + '\n'])

newlist.sort()
for j in range(len(newlist)):
	out_stats.write(str(newlist[j][0]) + '\t' + newlist[j][1])
