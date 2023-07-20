import sys
import decimal

minMQ = 1

infile = sys.argv[1] # 767.paf
focalsc = sys.argv[2] # tig00000003_1
stpt1 = int(sys.argv[3])
endpt1 = int(sys.argv[4])
stpt2 = int(sys.argv[5])
endpt2 = int(sys.argv[6])


# out1 =open(focalsc+".coverage.txt", "w")
out2 =open("pulled." + infile, "w")
src  =open(infile, "r")
for line_idx, line in enumerate(src):
	cols = line.replace('\n', '').split('\t')
# m64060_211111_043657/81/16976_38403	21427	57	21303	-	tig00000003_1	8252429	637366	657298	7552	21323	60	tp:A:P	cm:i:514	s1:i:7128	s2:i:448	dv:f:0.0586

	if cols[5]==focalsc and int(cols[11])>=minMQ:
		pos1=int(cols[7])
		pos2=int(cols[8])
		pcused=round((decimal.Decimal(int(cols[3])) - decimal.Decimal(int(cols[2]))) / decimal.Decimal(int(cols[1])), 3)
		if pos1> endpt2 or pos2<stpt1: # outside of range
			pass
		elif pos1 < stpt1: # all cases where longread starts before start 1
			if pos2< endpt1:
				out2.write(line.replace('\n', '') + '\ta_b\t' + str(pcused) + '\n') # cross_start1_and_end_within_interval_1
			elif pos2<stpt2:
				out2.write(line.replace('\n', '') + '\ta_c\t' + str(pcused) + '\n') # Spanning_interval_1
			elif pos2<endpt2:
				out2.write(line.replace('\n', '') + '\ta_d\t' + str(pcused) + '\n') # Spanning_interval_1_and_cross_Start2
			else:
				out2.write(line.replace('\n', '') + '\ta_e\t' + str(pcused) + '\n') # Spanning_full_region
		elif pos1 >= stpt1 and pos1 < endpt1:
			if pos2 < endpt1:
				out2.write(line.replace('\n', '') + '\tb_b\t' + str(pcused) + '\n') # Within_interval_1
			elif pos2 < stpt2:
				out2.write(line.replace('\n', '') + '\tb_c\t' + str(pcused) + '\n') # start_within_interval_1_end_in_middle
			elif pos2 < endpt2:
				out2.write(line.replace('\n', '') + '\tb_d\t' + str(pcused) + '\n') # Span_end1_and_start_2
			else:
				out2.write(line.replace('\n', '') + '\tb_e\t' + str(pcused) + '\n') # cross_end1_and_span_interval_2

		elif pos1 >= endpt1 and pos1 < stpt2:
			if pos2 < stpt2:
				out2.write(line.replace('\n', '') + '\tc_c\t' + str(pcused) + '\n') # Between_End1_and_Start2
			elif pos2 < endpt2:
				out2.write(line.replace('\n', '') + '\tc_d\t' + str(pcused) + '\n') # start_in_middle_and_cross_start2
			else:
				out2.write(line.replace('\n', '') + '\tc_e\t' + str(pcused) + '\n') # Spanning_interval_2
		elif pos1 >= stpt2:
			if pos2 < endpt2:
				out2.write(line.replace('\n', '') + '\td_d\t' + str(pcused) + '\n') # Within_interval_2
			else:
				out2.write(line.replace('\n', '') + '\td_e\t' + str(pcused) + '\n') # start_Within_interval_2_and_end_after_end2

