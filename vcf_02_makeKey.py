import sys

if len(sys.argv)!=2:
	print "\nUsage: \npython vcf_02_makeKey.py vcfName \n"
	sys.exit()
	
vcfName = sys.argv[1]
vcfName2 = vcfName.split('.')

in_vcf = open(vcfName, "r") 

out_key = open("key_" + vcfName2[0] + ".txt", "w")

for line_idx, line in enumerate(in_vcf):
	cols = line.replace('\n', '').split('\t') 
	if len(cols)>50: # skip headers ::  ##contig=<ID=Chr_01,length=11879706>
		if cols[0]=="#CHROM":
			out_key.write("POS\tsample_name\tFAM\tid\ttype\n")
			for j in range(9,len(cols)):
				out_key.write(str(j)+'\t')
				out_key.write(cols[j]+'\t')
				out_key.write(cols[j].replace("_","-").split("-")[1]+'\t')
				out_key.write(cols[j].replace(".","-").split("-")[1]+'\t')
				if cols[j].split("-")[0]!="767" and cols[j].split("-")[1][0]=="P":
					out_key.write("P"+"\n")
				elif cols[j].split("-")[0]=="767" and cols[j].split("-")[1][0]=="P":
					out_key.write("P"+"\n")
				else:
					out_key.write("F2"+"\n")
			break
