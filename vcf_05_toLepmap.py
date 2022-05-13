## require at least half of individuals to have data
import sys

vcfName = sys.argv[1] # 767.vcf
vcfName2 = vcfName.split('.')

cross = sys.argv[2] # 1034

if len(sys.argv)!=3:
	print "\nUsage: \npython vcf_05_toLepmap.py vcfName familyName 5\nThis script generates the output for lepmap based on\n1. 1:2:1 segregation\n2. At least 50% of offspring having the marker\n3. At least 10 767 parents having the marker\n4. Min 5 reads to make a call."
	sys.exit()

### settings
mindepth=5 # min reads to make a call
chisq_threshold = 5.99 # for rejection of 1:2:1
min_F2_callrate = 0.5
min_line_calls = 10

the_cause_of_failure=[0,0]

src  =open("slim1_" + vcfName2[0] + ".vcf", "r")
out1 =open(cross+".untransposed.linkage", "w")
out2 =open(cross+".markerNames.txt", "w")

relevant_snps={}
in1 =open(vcfName2[0] + "_covered_loci.txt", "r")
for line_idx, line in enumerate(in1):
        cols = line.replace('\n', '').split('\t')
	relevant_snps[cols[0]+"_"+cols[1]]=1
in1.close()

bad_boys={}
in1 =open(vcfName2[0] + ".bad.boys.txt", "r")
for line_idx, line in enumerate(in1):
        cols = line.replace('\n', '').split('\t')
# s1_62-93
	bad_boys[cols[0]]=1
in1.close()
print bad_boys

pos767={}
posline={}
posF2={}
in1 = open("key_" + vcfName2[0] + ".txt", "r")
for line_idx, line in enumerate(in1):
	cols = line.replace('\n', '').split('\t') 
# POS     sample_name     FAM     id      type
# 9       s12_1192-39.bam 1192    39      F2
# 10      s12_1192-P4.bam 1192    P4      P
	if line_idx>0:
		name=cols[1].split(".")[0]
		try:
			uk=bad_boys[name]
		except KeyError:
			if cols[2]=="767":
				pos767[int(cols[0])]=name
			elif cols[2]==cross and cols[4]=="P":
				posline[int(cols[0])]=name
			elif cols[2]==cross and cols[4]=="F2":
				posF2[int(cols[0])]=name			
in1.close()

nf2 = len(posF2.keys())
minF2calls = int(min_F2_callrate*float(nf2))

out1.write("1\t1")
for nm in posF2:
	out1.write("\t1")
out1.write("\n")
counter=1
snpcc=[0,0]
for line_idx, line in enumerate(src):
        cols = line.replace('\n', '').split('\t')
        if cols[0]=="#CHROM":
			out1.write("767\t"+cross)
			for nm in posF2:
				out1.write("\t"+posF2[nm])
			out1.write("\n")
			out1.write("0\t0")
			for nm in posF2:
				out1.write("\t"+cross)
			out1.write("\n")
			out1.write("0\t0")
			for nm in posF2:
				out1.write("\t767")
			out1.write("\n")        
			out1.write("2\t1")
			for nm in posF2:
				out1.write("\t1")
			out1.write("\n")        
			out1.write("0\t0")
			for nm in posF2:
				out1.write("\t0")
			out1.write("\n")        
        else:  
		try:
			uk = relevant_snps[cols[0]+"_"+cols[1]]

			ch=cols[0].split(":")[0]
			markerName = str(counter) + "\t" + ch + "\t" + cols[1] + "\n"
			countRA=[0,0]
			for x in pos767:
				GT=cols[ x ].split(":")[0] # 1/1:101,14,0:1,12 but also really weird shit:: 1/1:0,9,0:26,25	0/0:0,5,5:3,1
				pl1=cols[ x ].split(":")[1]
				ad1=cols[ x ].split(":")[2]
				countRA[0]+= int(ad1.split(",")[0])
				countRA[1]+= int(ad1.split(",")[1])
			n767=float(sum(countRA))
			G767='N'
			if n767>=min_line_calls:
				if float(countRA[0])/n767 >0.95:
					G767='1 1'
				elif float(countRA[1])/n767 >0.95:
					G767='2 2'
			
			stx=(G767)

			countRA=[0,0]
			for x in posline:
				GT=cols[ x ].split(":")[0] 
				pl1=cols[ x ].split(":")[1]
				ad1=cols[ x ].split(":")[2]
				countRA[0]+= int(ad1.split(",")[0])
				countRA[1]+= int(ad1.split(",")[1])
			GLine='N'
			nLine=float(sum(countRA))
			if nLine>=min_line_calls:
				if float(countRA[0])/nLine > 0.95:
					GLine='1 1'
				elif float(countRA[1])/nLine > 0.95:
					GLine='2 2'
			stx+=('\t'+GLine)

			if (G767=='1 1' and GLine=='2 2') or (G767=='2 2' and GLine=='1 1'):
				genos=[0,0,0]
				for x in posF2:
					GT=cols[ x ].split(":")[0] 
					pl1=cols[ x ].split(":")[1]
					ad1=cols[ x ].split(":")[2]
					readdepth = int(ad1.split(",")[0])+int(ad1.split(",")[1])
					GF2='0 0'
					if GT != "./." and readdepth>= mindepth:
						if len(pl1.split(","))==3 and len(ad1.split(","))==2:
							gl=[int(pl1.split(",")[0]),int(pl1.split(",")[1]),int(pl1.split(",")[2])]
							if GT =="0/0" and gl[0]==0 and gl[1]>0 and gl[2]>0:
								genos[0]+=1 # '0/0'
								GF2='1 1'
							elif GT =="1/1" and gl[2]==0 and gl[1]>0 and gl[0]>0:
								genos[2]+=1 # '1/1'
								GF2='2 2'
							elif GT =="0/1" and gl[1]==0 and gl[2]>0 and gl[0]>0:
								genos[1]+=1 # '0/1'
								GF2='1 2'
					stx+=('\t'+GF2)
				# test for coverage and 1:2:1
				ntot=float( sum(genos) )
				if ntot >=minF2calls:
					x2 = (genos[0]- 0.25*ntot)**2.0 / (0.25*ntot)
					x2+= (genos[1]- 0.5*ntot)**2.0 / (0.5*ntot)				
					x2+= (genos[2]- 0.25*ntot)**2.0 / (0.25*ntot)
					if x2<=chisq_threshold:
						out1.write(stx+'\n')
						out2.write(markerName)
						counter=counter+1
	                                else:
						the_cause_of_failure[1]+=1

				else:
					the_cause_of_failure[0]+=1


		except KeyError:
			pass


print "why we fail", the_cause_of_failure

