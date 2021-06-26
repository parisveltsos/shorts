import sys

if len(sys.argv)!=3:
	print "\nUsage: \npython lm2bpcm.py family lof\npython makePed.py 1192 16\n\nThis script makes data used to plot cm vs bp with the Rscript bpcmPlot.r\n"
	sys.exit()

family = sys.argv[1]
lod = sys.argv[2]

in_call = open(family + ".call", "r") 
in_map = open(family + "order" + lod + ".txt", "r") 

out_excel = open(family + "lod" + lod + "_excel.txt", "w")

genomeInfo={}

for line_idx, line in enumerate(in_call):
	cols = line.replace('\n', '').split('\t')
	if line_idx > 0:
		genomeInfo[line_idx-6]=[cols[0],cols[1]]
in_call.close()

LG = -9

excelList = []

for line_idx, line in enumerate(in_map):
	if "#" in line:
		if "LG" in line:
			LG = line.split(' ')[3]
	else: 
		cols = line.replace('\n', '').split('\t')
		chx = genomeInfo[ int(cols[0]) ]
		excelList.append(chx[0] + '\t' + chx[1] + '\tLG' + str(LG) + '\t' + cols[1] + '\n')
in_map.close()

out_excel.write('chr\tbp\tlg\tcm\n')
for j in range( len(excelList) ):
	out_excel.write( str( excelList[j] ) )

# print "Done!"