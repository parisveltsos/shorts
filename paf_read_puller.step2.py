import sys
import decimal

minMQ = 1

infile = sys.argv[1] # (output file from step 1)
focalsc = sys.argv[2] # tig00000003_1
stpt1 = int(sys.argv[3])
endpt1 = int(sys.argv[4])
stpt2 = int(sys.argv[5])
endpt2 = int(sys.argv[6])

counts_for_genome={}
read_data={}
out2 =open("intervalDepth." + infile, "w")
src  =open(infile, "r")
for line_idx, line in enumerate(src):
	cols = line.replace('\n', '').split('\t')
# m64060_210312_131644/263685/0_34555	34555	8856	9297	-	tig00000708_1	11165459	1991986	1992446	390	473	12	tp:A:P	mm:i:38	gn:i:45	go:i:35	b_b	0.013

	try:
		uk=read_data[cols[0]]
	except KeyError:
		read_data[cols[0]]=[]

	pos1=int(cols[7])
	pos2=int(cols[8])
	read_data[cols[0]].append([pos1,pos2])


src.close()

Interval1depth={}
for j in range(stpt1,endpt1+1):
	Interval1depth[j]=0
	counts_for_genome[j]=[0,0]
Interval2depth={}
for j in range(stpt2,endpt2+1):
	Interval2depth[j]=0
	counts_for_genome[j]=[0,0]

for rds in read_data:
	if len(read_data[rds])==1:
		pos1=read_data[rds][0][0]
		pos2=read_data[rds][0][1]
		if pos1<=endpt1 and pos2>=stpt1: # covers some of interval 1		
			c1 = max(pos1,stpt1)
			c2 = min(pos2,endpt1)
			for j in range(c1,c2+1):
				Interval1depth[j]+=1
		if pos1<=endpt2 and pos2>=stpt2: # covers some of interval 2
			c1 = max(pos1,stpt2)
			c2 = min(pos2,endpt2)
			for j in range(c1,c2+1):
				Interval2depth[j]+=1



for j in range(stpt1,endpt1+1):
	counts_for_genome[j]=Interval1depth[j]
for j in range(stpt2,endpt2+1):
	counts_for_genome[j]=Interval2depth[j]


for rds in read_data:
	if len(read_data[rds])>1:
		for mread in range(len(read_data[rds])):
			
			pos1=read_data[rds][mread][0]
			pos2=read_data[rds][mread][1]
			if pos1<=endpt1 and pos2>=stpt1: # covers some of interval 1		
				c1 = max(pos1,stpt1)
				c2 = min(pos2,endpt1)
				for j in range(c1,c2+1):
					Interval1depth[j]+=1
			if pos1<=endpt2 and pos2>=stpt2: # covers some of interval 2
				c1 = max(pos1,stpt2)
				c2 = min(pos2,endpt2)
				for j in range(c1,c2+1):
					Interval2depth[j]+=1


for j in range(stpt1,endpt1+1):
	out2.write("int1\t"+str(j)+'\t'+str(counts_for_genome[j])+'\t'+str(Interval1depth[j])+'\n')
for j in range(stpt2,endpt2+1):
	out2.write("int2\t"+str(j)+'\t'+str(counts_for_genome[j])+'\t'+str(Interval2depth[j])+'\n')	


