import sys

if len(sys.argv)!=2:
	print "\nUsage: \npython makeKey.py vcfName \n"
	sys.exit()
	
vcfName = sys.argv[1]
vcfName2 = vcfName.split('.')

in_vcf = open(vcfName, "r") 

out_key = open("key_" + vcfName2[0] + ".txt", "w")

for line_idx, line in enumerate(in_vcf):
	cols = line.replace('\n', '').split('\t') 
	if len(cols)>50: # skip headers ::  ##contig=<ID=Chr_01,length=11879706>
# tig00001020	31450	.	C	T	7.76187	.	DP=253;VDB=3.61919e-05;SGB=10.2672;RPB=0.000275617;MQB=0.999217;BQB=1.06749e-06;MQ0F=0;ICB=0.00193141;HOB=0.00094518;AC=1;AN=46;DP4=0,133,0,10;MQ=19	GT:PL:AD	./.:0,0,0:0,0	./.:0,0,0:0,0	./.:0,0,0:0,0	./.:0,0,0:0,0	./.:0,0,0:0,0	./.:0,0,0:0,0	./.:0,0,0:0,0	./.:0,0,0:0,0	0/0:0,6,36:2,0	./.:0,0,0:0,0	./.:0,0,0:0,0	./.:0,0,0:0,0	./.:0,0,0:0,0	./.:0,0,0:0,0	./.:0,0,0:0,0	0/0:0,4,66:12,2	
		if cols[0]=="#CHROM":
			out_key.write("vcf_pos\tsample_name\tfamily\tid\ttype\n")
			for j in range(9,len(cols)):
				out_key.write(str(j)+'\t')
				out_key.write(cols[j]+'\t')
				out_key.write(cols[j].replace(".","-").split("-")[0]+'\t')
				out_key.write(cols[j].replace(".","-").split("-")[1]+'\t')
				if cols[j].split("-")[0]!="767" and cols[j].split("-")[1][0]=="P":
					out_key.write("Parental_line"+"\n")
				elif cols[j].split("-")[0]=="767" and cols[j].split("-")[1][0]=="P":
					out_key.write("Parental_line"+"\n")
				else:
					out_key.write("F2"+"\n")
			break
