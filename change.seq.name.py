import sys

infle = sys.argv[1]


out1=open("mod."+infle,"w")
stnm = 111111111
endn = 999999999

cc0=0
cc1=stnm
in1  =open(infle, "r") # 
for line_idx, line in enumerate(in1):
        cols = line.replace('\n', '').split(' ') 

# @SRR172648.1 HWUSI-EAS1676_0031_FC:2:1:1398:1092 length=75
# CAAGTANCGTAGCTGGGCTGATGTCGGGACTACTGGTGTAAGCGCATTGGAGCCTTTCTTTCCTAAATCAATAGT
# +SRR172648.1 HWUSI-EAS1676_0031_FC:2:1:1398:1092 length=75
# fffff_B_\]\^Z\a^dddc]\b\`eeeaa\`\^a\G\RYYZV]TWaRa[]fccWWYZ^Z```]WZY^BBBBBBB
	if cols[0][0]=="@":
		out1.write("@"+str(cc0)+"_"+str(cc1)+'\n')

	elif cols[0][0]=="+":
		out1.write("+"+str(cc0)+"_"+str(cc1)+'\n')
		cc1+=1
		if cc1==endn:
			cc0+=1
			cc1=stnm
	else:
		out1.write(line)
