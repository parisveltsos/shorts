library(qtl)

args <- commandArgs(trailingOnly = TRUE)
line = args[1]
# line <- 664
# permnumber = as.numeric(paste(args[2]))
permnumber = 1000
# method = args[3]
method = "ehk"
# modeltype = args[4]
modeltype <- "normal" # normal or binary


inpath <- paste("/panfs/pfs.local/scratch/kelly/p860v026/qtl/in/", sep="")
outpath <- paste("/panfs/pfs.local/scratch/kelly/p860v026/qtl/out/", sep="")
# outpath <- '~/Desktop/'
dir.create(outpath)

# GenoData = read.cross(format = "csvs", dir="~/Desktop/", genfile = paste(line, "genotypes.txt", sep="."), phefile = paste(line, "phenotypes.txt", sep="."), estimate.map = F)

wData <- read.table(paste(inpath, line, ".weights.txt", sep=""), header=T)
cData <- read.table(paste(inpath, line, ".cohort.txt", sep=""), header=T)
GenoData = read.cross(format = "csvs", dir="/panfs/pfs.local/scratch/kelly/p860v026/qtl/in", genfile = paste(line, "genotypes.txt", sep="."), phefile = paste(line, "phenotypes.txt", sep="."), estimate.map = F)

mapthis <- jittermap(GenoData)
summary(mapthis)

# remove duplicate markers
print(dup <- findDupMarkers(mapthis, exact.only=FALSE))
mapthis <- drop.markers(mapthis, unlist(dup))
# plotMap(mapthis)

# should report no problems
mapthis <- est.rf(mapthis)
checkAlleles(mapthis, threshold=5)

save.image(file=paste(outpath, line, '.Rdata', sep=""))
