args <- commandArgs(trailingOnly = TRUE)
line = paste(args[1])
line="664"
bpcmData <- read.table(paste(line, "_excel.txt", sep=""), header=T)
str(bpcmData)

for ( LG in c('LG1','LG2','LG3','LG4') ) {
	subdata <- subset(bpcmData, bpcmData$lg==LG)
	pdf(paste(LG,"_out.pdf", sep=""), width=12, height=6)
	par(mar=c(5,5,4,3))
	plot(subdata$bp, subdata$cm, main=paste(LG, levels(factor(subdata$chr))), cex.main=1.8, cex.lab=1.3, xlab="v5 bp", ylab="cM")
	dev.off()
	}
	