library(dplyr)

args <- commandArgs(trailingOnly = TRUE)
LINE = args[1]

datapath <- "/panfs/pfs.local/scratch/kelly/p860v026/vcf767/"
datapath2 <- paste(datapath, LINE, sep="")
mdata <- read.table(file.path(datapath2, paste(LINE, ".corr.map.txt", sep="")), header=T)
str(mdata)
gdata <- read.table(file.path(datapath2, paste(LINE, ".genotypes_temp2.txt", sep="")), header=T)
head(str(gdata))

merged1 <- merge(mdata, gdata, by.x="bp", by.y="id", all=F )  
merged1 <- arrange(merged1, lg, cm)
merged1 <- select(merged1, -c(gene, oldlg, oldcm))
merged2 <- t(merged1)
write.table(merged2, file=file.path(datapath2, paste(LINE, ".genotypes_temp3.txt", sep="")), quote=F, row.names=F, sep=",")


