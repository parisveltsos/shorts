import sys

if len(sys.argv)!=3:
	print "\nUsage: \npython vcf_01_keepBial_cov.py vcfName 400\nThis script keeps biallelic and normal-looking './.' SNPs."
	sys.exit()
	
vcfName = sys.argv[1]
vcfName2 = vcfName.split('.')

mincc=int(sys.argv[2])

src = open(vcfName2[0] + ".vcf", "r")
# out1 =open("slim"+str(mincc)+".664.vcf", "w")
out1 = open("slim1_" + vcfName, "w")
	
out2 = open("slim1_" + vcfName2[0] + ".out", "w")

callsper={}
names={}

print "mincc set to ", mincc

snpcc=[0,0]
for line_idx, line in enumerate(src):
	cols = line.replace('\n', '').split('\t') 
	if len(cols)>50: # skip headers ::  ##contig=<ID=Chr_01,length=11879706>
# tig00000001_1	63177	.	A	G	5.26659	.	DP=4806;VDB=1.24099e-17;SGB=79.8199;RPB=3.00822e-18;MQB=1;BQB=0.0172746;MQ0F=0;ICB=0.999945;HOB=4.35091e-05;AC=5;AN=1072;DP4=4697,0,38,0;MQ=20	GT:PL:AD	0/0:0,129,86:43,0	./.:0,0,0:0,0	0/0:0,12,60:4,0	0/0:0,6,36:2,0	0/0:0,6,36:2,0	0/0:0,3,20:1,0	0/0:0,3,20:1,0	0/0:0,9,49:3,0	0/0:0,12,60:4,0	0/0:0,6,36:2,0	0/0:0,18,74:6,0	./.:0,0,0:0,0	0/0:0,27,86:9,0	./.:0,0,0:0,0	0/0:0,9,49:3,0	./.:0,0,0:0,0	./.:0,0,0:0,0	./.:0,0,0:0,0	0/0:0,30,88:10,0	...
		if cols[0]=="#CHROM":
			out1.write(line)
			for j in range(9,len(cols)):
#				print j,cols[j]
				names[j]=cols[j]
				callsper[j]={"0/0":0,"0/1":0,"1/1":0}

		elif len(cols[3])==1 and len(cols[4])==1:  # require line to be bi-allelic SNP

			cc=0
			for x in range(9,len(cols)):
				vv = cols[x].split(":")
				if vv[0] != "./.":
					cc+=1
					callsper[x][vv[0]]+=1
			if cc>=mincc:
				snpcc[0]+=1
				out1.write(line)
			else:
				snpcc[1]+=1

out2.write("SNPs kept/lost " + str(snpcc) + "\n" + "Coverage" + str(mincc) + "\n")
print "snps kept/lost",snpcc

for x in range(9,len(cols)):
	out2.write(str(x) + "\t" + str(names[x]) + "\t" + str(callsper[x]) + "\n")
#	print x,names[x],callsper[x]

