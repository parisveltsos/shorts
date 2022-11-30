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
mapthis <- replace.map(mapthis, newmap)

# pdf(file.path(outpath,paste(line,".map.pdf", sep="")), width=12, height=9)
# plotMap(mapthis, main=line)
# dev.off()

# summary(newmap)
# write.table(round(summary(newmap), 3), file=file.path(outpath, paste(line, "mapstats.txt", sep=".")), quote=F, row.names=F, sep="\t")
# mapthis <- calc.errorlod(mapthis, error.prob=0.01)
# etable <- top.errorlod(mapthis)
# etable$id <- factor(etable$id)
# levels(etable$id)
# 
# etable$chr <- factor(etable$chr)
# summary(etable$chr)
# 
# for (chrom in seq(1:14)) {
# pdf(file.path(outpath,paste(line,chrom,"error.pdf", sep=".")), width=16, height=9)
# plotGeno(mapthis, chr=chrom, ing=levels(etable$id))
# dev.off()
# }

# should report no problems
mapthis <- est.rf(mapthis)
checkAlleles(mapthis, threshold=5)

save.image(file=paste(outpath, line, '_long.Rdata', sep=""))
