import sys

infile = sys.argv[1] # slim.10.767.pb.paf
focalsc = sys.argv[2] # tig00000003_1
stpt1 = int(sys.argv[3])
endpt1 = int(sys.argv[4])
stpt2 = int(sys.argv[5])
endpt2 = int(sys.argv[6])


# out1 =open(focalsc+".coverage.txt", "w")
out2 =open(focalsc + "." + infile, "w")
src  =open(infile, "r")
for line_idx, line in enumerate(src):
	cols = line.replace('\n', '').split('\t')
# m64060_211111_043657/81/16976_38403	21427	57	21303	-	tig00000003_1	8252429	637366	657298	7552	21323	60	tp:A:P	cm:i:514	s1:i:7128	s2:i:448	dv:f:0.0586

	if cols[5]==focalsc:
		pos1=int(cols[7])
		pos2=int(cols[8])
		qual=int(cols[11])
		if pos1 > endpt2 or pos2 < stpt1 or qual==0: # outside of range or bad mapping
			pass
		elif pos1 < stpt1: # all cases where longread starts before start 1
			if pos2< endpt1:
				out2.write(line.replace('\n', '')+'\tWithin_interval_1\n')
			elif pos2<stpt2:
				out2.write(line.replace('\n', '')+'\tSpanning_interval_1\n')
			elif pos2<endpt2:
				out2.write(line.replace('\n', '')+'\tSpanning_interval_1_and_cross_Start2\n')
			else:
				out2.write(line.replace('\n', '')+'\tSpanning_full_region\n')
		elif pos1 >= stpt1 and pos1 < endpt1:
			if pos2 < endpt1:
				out2.write(line.replace('\n', '')+'\tWithin_interval_1\n')
			elif pos2 < stpt2:
				out2.write(line.replace('\n', '')+'\tWithin_interval_1\n')
			elif pos2 < endpt2:
				out2.write(line.replace('\n', '')+'\tSpan_end1_and_start_2\n')
			else:
				out2.write(line.replace('\n', '')+'\tcross_end1_and_span_interval_2\n')

		elif pos1 >= endpt1 and pos1 < stpt2:
			if pos2 < stpt2:
				out2.write(line.replace('\n', '')+'\tBetween_End1_and_Start2\n')
			elif pos2 < endpt2:
				out2.write(line.replace('\n', '')+'\tWithin_interval_2\n')
			else:
				out2.write(line.replace('\n', '')+'\tSpanning_interval_2\n')
		elif pos1 >= stpt2:
			if pos2 < endpt2:
				out2.write(line.replace('\n', '')+'\tWithin_interval_2\n')
			else:
				out2.write(line.replace('\n', '')+'\tWithin_interval_2\n')

