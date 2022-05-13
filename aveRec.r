args <- commandArgs(trailingOnly = TRUE)
LINE = as.integer(paste(args[1]))
THRESHOLD = as.double(paste(args[2]))

recData <- read.table(paste(LINE,".recData.txt", sep=""), header=T)
str(recData)

fr <- data.frame(tapply(recData$times, list(recData$id), mean) )
colnames(fr) <- 'aveRec'
# row.names(fr) <- recData$id

head(fr)
pdf(paste(LINE,"recHist.pdf", sep=""), width=9, height=9)
hist(fr$aveRec, breaks=nrow(fr), main=LINE, xlab='Average recombination per LG')
dev.off()

high.fr <- subset(fr, fr$aveRec > THRESHOLD)

nrow(high.fr)
write.table(high.fr, file=paste("above_", THRESHOLD, "lod_threshold.txt", sep=""), quote=F, row.names=T, sep="\t")

