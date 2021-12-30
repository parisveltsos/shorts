window_size = 100000

out1 = open("split.chr.bed","w")


in1 = open("chr.bed","r")
for line_idx, line in enumerate(in1):
	cols = line.replace('\n', '').split('\t') 
# Chr_14:1-26762607
	vv=cols[0].split(":")
	chrom = vv[0]
	end = int(vv[1].split("-")[1])
	window_number = int(end/window_size)+1
	if window_number == 1:
		out1.write(line)
	else:
		st = 0
		for j in range(window_number):
			if st + window_size < end:
				out1.write(chrom + ":" + str(st+1) + "-" + str(st+window_size) + '\n')
			else:
				out1.write(chrom + ":" + str(st+1) + "-" + str(end) + '\n')
			st+=window_size


			
	
	

