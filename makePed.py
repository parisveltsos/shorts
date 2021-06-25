import sys

if len(sys.argv)!=5:
	print "\nUsage: \npython makePed.py mother father family vcf\npython makePed.py 664-P5_S35.sorted.bam 767-P2_S43.sorted.bam 664 pool1.vcf\n\nAlso need key.txt file\n"
	sys.exit()
	
mother = sys.argv[1]
father = sys.argv[2]
family = sys.argv[3]

in_vcf = open(sys.argv[4], "r") 

out_ped = open(family + "ped.txt", "w")

x767 = []
xline = []
xF2 = []

in_key = open("key.txt","r")

for line_idx, line in enumerate(in_key):
	cols = line.replace('\n', '').split('\t') 
	
	if line_idx > 0:
		if cols[4]=="767":
			x767.append(int(cols[0]))
		elif cols[4]=="Parental_line" and cols[2]==family:
			xline.append(int(cols[0])) 
		elif cols[4]=="F2" and cols[2]==family:
			xF2.append(int(cols[0]))  
in_key.close()

out_ped.write('CHR\tPOS')

for j in range(len(x767) + len(xline) + len(xF2) + 4):
	out_ped.write('\t' + family)
out_ped.write('\n')

out_ped.write('CHR' + '\t' + 'POS' + '\t' + father + '\t' + mother + '\t' + 'father\tmother')

counter = 0
for line_idx, line in enumerate(in_vcf):
	cols = line.replace('\n', '').split('\t')
	if '#CHROM' in line: 
		for x in x767:
			out_ped.write('\t' + cols[x])
		for x in xline:
			out_ped.write('\t' + cols[x])
		for x in xF2:
			out_ped.write('\t' + cols[x])
		out_ped.write('\n')
		counter=1
	elif counter==1:
		break

out_ped.write('CHR\tPOS\t0\t0\t' + father + '\t' + father)

for j in range(len(x767) + len(xline) + len(xF2)):
	out_ped.write('\t' + 'father')
out_ped.write('\n')


out_ped.write('CHR\tPOS\t0\t0\t' + mother + '\t' + mother)

for j in range(len(x767) + len(xline) + len(xF2)):
	out_ped.write('\t' + 'mother')
out_ped.write('\n')


out_ped.write('CHR\tPOS\t1\t2\t1\t2')

for j in range(len(x767) + len(xline) + len(xF2)):
	out_ped.write('\t' + '0')
out_ped.write('\n')


out_ped.write('CHR\tPOS\t0\t0\t0\t0')

for j in range(len(x767) + len(xline) + len(xF2)):
	out_ped.write('\t' + '0')
out_ped.write('\n')
