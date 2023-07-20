#!/bin/bash
#SBATCH --job-name=invPlot              # Job name
#SBATCH --partition=sixhour           # Partition Name (Required)
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=pveltsos@ku.edu      # Where to send mail
#SBATCH --ntasks=1                          # Run on a single CPU
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1g                     # Job memory request
#SBATCH --time=00-01:59:00             # Time limit days-hrs:min:sec
#SBATCH --output=R-%x.%j.out
#SBATCH --error=R-%x.%j.err

cd /panfs/pfs.local/scratch/kelly/p860v026/minimap


# sbatch ~/code/invPlot.sh tig00000708_1 1987519 2066816 2252813 2310963 NA NA INV8sa 237

module load R

CONTIG=$1
EXT1=$2
INT1=$3
INT2=$4
EXT2=$5
GENE1=$6
GENE2=$7
NOTE=$8
LINE=$9

# CONTIG=tig00000708_1
# EXT1=1987519
# INT1=2066816
# INT2=2252813
# EXT2=2310963
# GENE1=NA
# GENE2=NA
# NOTE=INV8sa
# LINE=767

# while read p; do
# 	for LINE in $(echo -e "155\t237\t444\t502\t541\t664\t767\t909\t1034\t1192"); do
# 		echo "sbatch ~/code/invPlot.sh $p $LINE";
# 		done;
# done < inversions.txt > run.sh 

# for LINE in $(echo -e "155\t237\t444\t502\t541\t664\t767\t909\t1034\t1192"); do
# 	echo "sbatch ~/code/invPlot.sh $(cat inversions.txt) $LINE";
# 	done > run.sh



# for LINE in $(echo -e "155\t237\t444\t502\t541\t664\t767\t909\t1034\t1192")
# 	do 
	mkdir $NOTE
	cd $LINE\mapping
	cp $LINE.paf $CONTIG.$EXT1.$EXT2.$LINE.paf # python reading the same input in parallel fails
	
	python ~/code/paf_read_puller.py $CONTIG.$EXT1.$EXT2.$LINE.paf $CONTIG $EXT1 $INT1 $INT2 $EXT2
	python ~/code/paf_read_puller.step2.py pulled.$CONTIG.$EXT1.$EXT2.$LINE.paf $CONTIG $EXT1 $INT1 $INT2 $EXT2
	mv intervalDepth.pulled.$CONTIG.$EXT1.$EXT2.$LINE.paf ../$NOTE/
	rm $CONTIG.$EXT1.$EXT2.$LINE.paf

	cat <(echo $LINE 'category') <(echo -e 'a_b\nb_b\nb_c\nc_c\nc_d\nc_e\nd_d\nd_e') <(cut -f 17 pulled.$CONTIG.$EXT1.$EXT2.$LINE.paf | sort | uniq -c  | grep '_') | perl -pe 's/^ +// ; s/ /\t/' > ../$NOTE/rule1.$CONTIG.$EXT1.$EXT2.$LINE.txt

	mkdir $CONTIG$EXT1
	cut -f1 pulled.$CONTIG.$EXT1.$EXT2.$LINE.paf | sort | uniq -c | sort | perl -pe 's/ +/\t/g' | awk '$1>1' | awk '{print $2}' > $CONTIG$EXT1/temp_toKeep.txt
	cat ../header.txt <(awk 'FNR==NR { a[$1]; next } ($1 in a)' $CONTIG$EXT1/temp_toKeep.txt pulled.$CONTIG.$EXT1.$EXT2.$LINE.paf) > $CONTIG$EXT1/over1.$CONTIG.$LINE.txt
	cut -f1 pulled.$CONTIG.$EXT1.$EXT2.$LINE.paf | sort | uniq -c | sort | perl -pe 's/ +/\t/g' | awk '$1==1' | awk '{print $2}' > $CONTIG$EXT1/temp_toKeep.txt
	cat ../header.txt <(awk 'FNR==NR { a[$1]; next } ($1 in a)' $CONTIG$EXT1/temp_toKeep.txt pulled.$CONTIG.$EXT1.$EXT2.$LINE.paf) > $CONTIG$EXT1/only1.$CONTIG.$LINE.txt
	Rscript ~/code/invPlot.r $LINE $CONTIG $EXT1 $INT1 $INT2 $EXT2 $GENE1 $GENE2 $NOTE
	mv $CONTIG$EXT1/$LINE\_$CONTIG\_$EXT1.pdf ../$NOTE
	
# tar -zcvf *$CONTIG_$EXT1*.tar.gz  *$CONTIG_$EXT1.pdf
# rm *$CONTIG_$EXT1.pdf


