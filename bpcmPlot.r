library(RColorBrewer)

args <- commandArgs(trailingOnly = TRUE)
line = paste(args[1])
# line="664"
bpcmData <- read.table(paste(line, "_excel.txt", sep=""), header=T)
str(bpcmData)

for ( LG in c('LG1','LG2','LG3','LG4', 'LG5', 'LG6', 'LG7', 'LG8', 'LG9', 'LG10', 'LG11', 'LG12', 'LG13', 'LG14') ) {
	subdata <- subset(bpcmData, bpcmData$lg==LG)
	pdf(paste(LG,"_out.pdf", sep=""), width=12, height=6)
	par(mar=c(5,5,4,3))
	plot(subdata$bp, subdata$cm, main=paste(LG), cex.main=1.8, cex.lab=1.3, xlab="v5 bp", ylab="cM", type='n')

	cols <- brewer.pal(length(levels(factor(subdata$chr))),'Set1')
	count <- 1
	for (i in levels(factor(subdata$chr))) {
		points(subdata$bp[subdata$chr==i], subdata$cm[subdata$chr==i], col=cols[count], pch=19)
		count <- count+1
		}
	legend("topleft", inset=0.05, legend=levels(factor(subdata$chr)), pch =c(19), col=cols )
	dev.off()
	}
	