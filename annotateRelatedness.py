import sys

if len(sys.argv)!=2:
	print "\nUsage: \npython annotateRelatedness.py out.relatedness \n"
	sys.exit()
	
inName = sys.argv[1]
# inName2 = inName.split('.')

in_rel = open(inName, "r") 

out_rel = open("ann_" + inName, "w")

for line_idx, line in enumerate(in_rel):
	cols = line.replace('\n', '').split('\t')
	if cols[0]=="INDV1":
		out_rel.write("ID1\tID2\trel\tfamily\tcategory\n")
	else:
		fam_c1=cols[0].replace("_","-").split("-")[1]
		fam_c2=cols[1].replace("_","-").split("-")[1]
		is1P=cols[0].replace("_","-").split("-")[2][0]
		is2P=cols[1].replace("_","-").split("-")[2][0]
		out_rel.write(cols[0] + '\t' + cols[1] + '\t' + cols[2] + '\t' + fam_c1 + '\t')
		if cols[0]==cols[1]:
			out_rel.write('identical\n')
		elif fam_c1==fam_c2 and is1P=='P' and is2P=='P':
			out_rel.write('P\n')
		elif fam_c1==fam_c2 and (is1P=='P' or is2P=='P'):
			out_rel.write('PO\n')
		elif fam_c1==fam_c2 and is1P!='P' and is2P!='P':
			out_rel.write('F2\n')
		elif fam_c1!=fam_c2:				
			out_rel.write('diff\n')
# 	break

# datapath <- "~/Downloads"
# kdata <- read.table(file.path(datapath, "head.txt"), header=T)
# str(kdata)
# 
# tapply(kdata$rel, list(kdata$category), mean) 
# plot(hour,rad,col=day) 