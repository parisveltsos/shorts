library(RColorBrewer)

args <- commandArgs(trailingOnly = TRUE)
line = paste(args[1])
LOD = paste(args[2])
CHR = as.integer(paste(args[3]))
# line="1192"
# LOD="17"
bpcmData <- read.table(paste(line, "_", LOD, "_bpcmData.txt", sep=""), header=T)
str(bpcmData)

# for ( LG in c('LG1','LG2','LG3','LG4', 'LG5', 'LG6', 'LG7', 'LG8', 'LG9', 'LG10', 'LG11', 'LG12', 'LG13', 'LG14') ) {
  for ( LG in seq(1:CHR) ) {
	subdata <- subset(bpcmData, bpcmData$lg==LG)
	pdf(paste(LG,"_out.pdf", sep=""), width=12, height=12)
	par(mar=c(5,5,4,3))
	plot(subdata$cm, subdata$bp, main=paste(LG), cex.main=1.8, cex.lab=1.3, xlab="cM", ylab="bp", type='n')

	cols <- brewer.pal(length(levels(factor(subdata$contig))),'Set1')
	count <- 1
	for (i in levels(factor(subdata$contig))) {
		points(subdata$cm[subdata$contig==i], subdata$bp[subdata$contig==i], col=cols[count], pch=19)
		count <- count+1
		}
	legend("topleft", inset=0.05, legend=levels(factor(subdata$contig)), pch =c(19), col=cols )
	dev.off()
	}
	