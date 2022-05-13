import sys

if len(sys.argv)!=2:
	print "\nUsage: \npython makeCM.py cmData.txt \n"
	sys.exit()
	
cmName = sys.argv[1]
cmName2 = cmName.split('.')

in_cm = open(cmName, "r") 

out_cm = open("out_" + cmName2[0] + ".txt", "w")

LG=1
col_cm=0
for line_idx, line in enumerate(in_cm):
	cols = line.replace('\n', '').split('\t') 
	if float(cols[1]) >= col_cm:
		out_cm.write(str(LG) + '\t' + cols[0] + "\t" + cols[1] + "\n")
		col_cm=float(cols[1])
	else:
		LG+=1
		out_cm.write(str(LG) + '\t' + cols[0] + "\t" + cols[1] + "\n")
		col_cm=float(cols[1])
