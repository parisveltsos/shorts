R_NAME=IM767
Q_NAME=$1
FOLDER_NAME=$Q_NAME\_TO_$R_NAME

# R_NAME=62
# Q_NAME=tig00000722
# QGENOME_NAME=767

WFOLDER=/panfs/pfs.local/scratch/kelly/p860v026/mummer2/$FOLDER_NAME

# sbatch svmu_02b_lastz.sh 62 tig00000722 767

# 62 tig00000742 664 is chr6 and shows many inversions
# 62 tig00000722 767 is chr 6 should show fewer inversions
# 62 tig00000794 664 is chr 11 should show fewer inversions some common with 767
# 62 tig00000804 767 is chr 11 should show fewer inversions some common with 767



# run 3 

# write cleanup code
