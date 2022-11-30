library(qtl)
library(dplyr)

args <- commandArgs(trailingOnly = TRUE)
line = args[1]
# line <- 664
# permnumber = as.numeric(paste(args[2]))
permnumber = 1000
# method = args[3]
method = "mr" # em hk ehk imp mr
# modeltype = args[4]
modeltype <- "normal" # normal or binary


inpath <- paste("/panfs/pfs.local/scratch/kelly/p860v026/qtl/in/", sep="")
# inpath <- paste("/Users/pveltsos/Documents/Uni Projects/Mimulus/mim_voom/", sep="")
# outpath <- paste("/Users/pveltsos/Documents/Uni Projects/Mimulus/mim_voom/", sep="")
outpath <- paste("/panfs/pfs.local/scratch/kelly/p860v026/qtl/out/", sep="")
# outpath <- '~/Desktop/'
dir.create(outpath)

# GenoData = read.cross(format = "csvs", dir="~/Desktop/", genfile = paste(line, "genotypes.txt", sep="."), phefile = paste(line, "phenotypes.txt", sep="."), estimate.map = F)

wData <- read.table(paste(inpath, line, ".weight.txt", sep=""), header=T)
cData <- read.table(paste(inpath, line, ".cohort.txt", sep=""), header=T)
GenoData = read.cross(format = "csvs", dir="/panfs/pfs.local/scratch/kelly/p860v026/qtl/in", genfile = paste(line, "genotypes.txt", sep="."), phefile = paste(line, "count.txt", sep="."), estimate.map = F)
# GenoData = read.cross(format = "csvs", dir="/Users/pveltsos/Documents/Uni Projects/Mimulus/mim_voom/", genfile = paste(line, "genotypes.txt", sep="."), phefile = paste(line, "count.txt", sep="."), estimate.map = T)

mapthis <- jittermap(GenoData)
summary(mapthis)

# remove duplicate markers
# print(dup <- findDupMarkers(mapthis, exact.only=FALSE))
# mapthis <- drop.markers(mapthis, unlist(dup))
newmap <- est.map(mapthis, error.prob=0.01)

write.table(c(newmap$'1'), file=file.path(inpath, paste(line, "_lg_1.txt", sep="")), quote=F, row.names=F, sep="\t")
write.table(c(newmap$'2'), file=file.path(outpath, paste(line, "_lg_2.txt", sep="")), quote=F, row.names=F, sep="\t")
write.table(c(newmap$'3'), file=file.path(outpath, paste(line, "_lg_3.txt", sep="")), quote=F, row.names=F, sep="\t")
write.table(c(newmap$'4'), file=file.path(outpath, paste(line, "_lg_4.txt", sep="")), quote=F, row.names=F, sep="\t")
write.table(c(newmap$'5'), file=file.path(outpath, paste(line, "_lg_5.txt", sep="")), quote=F, row.names=F, sep="\t")
write.table(c(newmap$'6'), file=file.path(outpath, paste(line, "_lg_6.txt", sep="")), quote=F, row.names=F, sep="\t")
write.table(c(newmap$'7'), file=file.path(outpath, paste(line, "_lg_7.txt", sep="")), quote=F, row.names=F, sep="\t")
write.table(c(newmap$'8'), file=file.path(outpath, paste(line, "_lg_8.txt", sep="")), quote=F, row.names=F, sep="\t")
write.table(c(newmap$'9'), file=file.path(outpath, paste(line, "_lg_9.txt", sep="")), quote=F, row.names=F, sep="\t")
write.table(c(newmap$'10'), file=file.path(outpath, paste(line, "_lg_10.txt", sep="")), quote=F, row.names=F, sep="\t")
write.table(c(newmap$'11'), file=file.path(outpath, paste(line, "_lg_11.txt", sep="")), quote=F, row.names=F, sep="\t")
write.table(c(newmap$'12'), file=file.path(outpath, paste(line, "_lg_12.txt", sep="")), quote=F, row.names=F, sep="\t")
write.table(c(newmap$'13'), file=file.path(outpath, paste(line, "_lg_13.txt", sep="")), quote=F, row.names=F, sep="\t")
write.table(c(newmap$'14'), file=file.path(outpath, paste(line, "_lg_14.txt", sep="")), quote=F, row.names=F, sep="\t")

# paste markerNames.txt <(cat 664_lg_1.txt 664_lg_2.txt 664_lg_3.txt 664_lg_4.txt 664_lg_5.txt 664_lg_6.txt 664_lg_7.txt 664_lg_8.txt 664_lg_9.txt 664_lg_10.txt 664_lg_11.txt 664_lg_12.txt 664_lg_13.txt 664_lg_14.txt | grep -v x) > 664All.txt