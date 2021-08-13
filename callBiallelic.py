import sys

mincc=100

if len(sys.argv)!=3:
	print "\nUsage: \npython callBiallelic.py 1192 vcfName \npython callBiallelic.py test.vcf\n\n"
	sys.exit()
	
familyName = sys.argv[1]
vcfName = sys.argv[2]
vcfName2 = vcfName.split('.')

in_vcf = open(vcfName, "r") 
in_key = open("key_" + sys.argv[2].split(".")[0] + ".txt","r")

out_vcf = open("biall_" + str(mincc) + "_" + vcfName, "w")
out_vcf2 = open("biall_" + familyName + "_" + str(mincc) + "_" + vcfName, "w")
out_het = open("het_" + vcfName2[0] + ".txt", "w")

col767 = []
colParent = []

for line_idx, line in enumerate(in_key):
	cols1 = line.replace('\n', '').split('\t') 
	if cols1[2]=="767":
		col767.append(int(cols1[0]))
	elif cols1[2]==familyName and cols1[4]=="Parental_line":
		colParent.append(int(cols1[0]))
in_key.close()

refcnt767=0
altcnt767=0
refcntP=0
altcntP=0
callsper={} 
names={}

for line_idx, line in enumerate(in_vcf):
	cols2 = line.replace('\n', '').split('\t') 
	if len(cols2)>50: # skip headers ::  ##contig=<ID=Chr_01,length=11879706>
		if cols2[0]=="#CHROM":
			out_vcf2.write(line)
			for x in range(9,len(cols2)):
				names[x]=cols2[x]
				callsper[x]={"0/0":0,"0/1":0,"1/1":0}
		elif len(cols2[3])==1 and len(cols2[4])==1:  # bi-allelic SNPs
			for i in col767:
				vv=cols2[i].split(":")
				ref,alt=vv[2].split(",")
				refcnt767+=int(ref)
				altcnt767+=int(alt)
			for i in colParent:
				vv=cols2[i].split(":")
				ref,alt=vv[2].split(",")
				refcntP+=int(ref)
				altcntP+=int(alt)
			
			if (refcnt767 + altcnt767) > 40 and (refcntP + altcntP) > 40 and float(refcnt767)/float(refcnt767+altcnt767+1) > 0.95:
				print (refcnt767,altcnt767,refcntP,altcntP)
				print (float(refcnt767)/float(refcnt767+altcnt767+1))
				print (float(refcntP)/float(refcntP+altcntP+1))
				for x in range(9,len(cols2)):
					vv2=cols2[x].split(":")
					if vv2[0]!="./.":
						#cc+=1
						callsper[x][vv2[0]]+=1
				out_vcf2.write(line)
			refcnt767=0
			altcnt767=0
			refcntP=0
			altcntP=0
in_vcf.close()	




# in_vcf = open(vcfName, "r") 
# callsper={}
# names={}
# 
# snpcc=0
# for line_idx, line in enumerate(in_vcf):
# 	cols = line.replace('\n', '').split('\t') 
# 	if len(cols)>50: # skip headers ::  ##contig=<ID=Chr_01,length=11879706>
# # tig00001020	31450	.	C	T	7.76187	.	DP=253;VDB=3.61919e-05;SGB=10.2672;RPB=0.000275617;MQB=0.999217;BQB=1.06749e-06;MQ0F=0;ICB=0.00193141;HOB=0.00094518;AC=1;AN=46;DP4=0,133,0,10;MQ=19	GT:PL:AD	./.:0,0,0:0,0	./.:0,0,0:0,0	./.:0,0,0:0,0	./.:0,0,0:0,0	./.:0,0,0:0,0	./.:0,0,0:0,0	./.:0,0,0:0,0	./.:0,0,0:0,0	0/0:0,6,36:2,0	./.:0,0,0:0,0	./.:0,0,0:0,0	./.:0,0,0:0,0	./.:0,0,0:0,0	./.:0,0,0:0,0	./.:0,0,0:0,0	0/0:0,4,66:12,2	
# 		if cols[0]=="#CHROM":
# 			out_vcf.write(line)
# 			for j in range(9,len(cols)):
# #				print j,cols[j]
# 				names[j]=cols[j]
# 				callsper[j]={"0/0":0,"0/1":0,"1/1":0}
# 
# 		elif len(cols[3])==1 and len(cols[4])==1:  # require line to be bi-allelic SNP
# # could also filter on MQ or other at this point
# 
# 			# c664 = cols[103].split(":")[0] # 664P.bam
# 			# c767 = cols[104].split(":")[0] # 767P.bam
# 
# 			cc=0
# 			for x in range(9,len(cols)):
# 				vv = cols[x].split(":")
# 				if vv[0] != "./.":
# 					cc+=1
# 					callsper[x][vv[0]]+=1
# 			# out_vcf.write('\t'+str(g["0/0"])+","+str(g["0/1"])+","+str(g["1/1"])+'\n')
# 			if cc>=mincc:
# 				snpcc+=1
# 
# 				out_vcf.write(line)
# 
# print "parents and mincount",snpcc

out_het.write('id\tfamily\tkey\t11\t00\t01\n')

for x in range(9,len(cols2)):
	out_het.write(names[x].split(".")[0] + '\t')
	out_het.write(names[x].replace("-P","p-").split("-")[0] + '\t')
	out_het.write(str(x) + '\t')
# 	for key, value in callsper[x].items():
# 		out_het.write('%s\t' % (value))
	out_het.write(str(callsper[x]['1/1']))
	out_het.write('\t')
	out_het.write(str(callsper[x]['0/0']))
	out_het.write('\t')
	out_het.write(str(callsper[x]['0/1']))
	out_het.write('\n')
#  	print(x,names[x],callsper[x])

# process output with 

# grep '{' hetout.txt | awk '{print  $2,'\t',$4'\t',$6'\t',$8,'\t',$2}' | perl -pe 's/.bam//g  ;  s/\,//g ; s/\}//' > hetout2.txt