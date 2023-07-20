library(dplyr)
# run with Rscript invPlot_sharif.r toPlot664_1.txt $CONTIG $EXT1 $INT1 $INT2 $EXT2
args <- commandArgs(trailingOnly = TRUE)
LINE = paste(args[1])
CONTIG = paste(args[2])
INFILEONE = paste("only1.", CONTIG, ".", LINE,".txt", sep="")
INFILEREST = paste("over1.", CONTIG, ".", LINE,".txt", sep="")
# CONTIG = 'tig00000804_1'
EXT1=as.numeric(paste(args[3]))
INT1=as.numeric(paste(args[4]))
INT2=as.numeric(paste(args[5]))
EXT2=as.numeric(paste(args[6]))
GENE1=paste(args[7])
GENE2=paste(args[8])
NOTE=paste(args[9])

datapath <- "/panfs/pfs.local/scratch/kelly/p860v026/minimap"
datapath2 <- paste("/panfs/pfs.local/scratch/kelly/p860v026/minimap/", LINE, "mapping/", CONTIG, EXT1, sep="")

rdata <- read.table(file.path(datapath, "repeats.gff"), header=F)
rdata <- subset(rdata, rdata$V1==CONTIG)
exdata <- read.table(file.path(datapath, "767_ruby.gff"), header=F)
exdata_gene <- subset(exdata, exdata$V3=="gene" & exdata$V1==CONTIG)

kdata1 <- read.table(file.path(datapath2, INFILEONE), header=T)
kdata1 <- kdata1 %>% arrange(interpretation, direction, q_end, quality)

kdata2 <- read.table(file.path(datapath2, INFILEREST), header=T)
kdata2 <- kdata2 %>% arrange(desc(id_length), id, q_end)

family <- data.frame(kdata2$id)
hit_size <- dplyr::count(family, kdata2.id)
merged1 <- merge(kdata2, hit_size, by.x="id", by.y="kdata2.id", all=F )
merged1 <- merged1 %>% arrange(desc(n), desc(id_length), id, id_start)

str(merged1)


pdf(file.path(datapath2, paste(LINE,'_', CONTIG, '_', EXT1, '.pdf', sep="")), width=12, height=40)

par(mar=c(5,5,4,3))

plot(c(min(kdata1$q_start), max(kdata1$q_end)), c(1,nrow(kdata1) + nrow(hit_size)), type="n", xlab="767 contig", ylab="read", main=paste(LINE, NOTE, GENE1, GENE2), cex.main=1.8, cex.lab=1.3)

segments(exdata_gene$V4, 1, exdata_gene$V5, 1, lty=1, lw=4, col=4)
segments(rdata$V4, -1, rdata$V5, -1, lty=1, lw=4, col='gray')


ycount=1
colour=2
i=1
name=kdata1[1,]$id
min_dotted <- 19000
# for(i in 1:500) {
for(i in 1:nrow(kdata1)) {
	if (i > 1) {
		if (kdata1[i,]$id != kdata1[i-1,]$id) {
		min_dotted <- max(kdata1[i,]$q_start, kdata1[i,]$q_end)
		}
	}
	if(kdata1[i,]$direction=="+") {
		arrows(kdata1[i,]$q_start, ycount, kdata1[i,]$q_end, ycount, col=colour, code=2, length=.1, lw=2)  
	}
	
	if(kdata1[i,]$direction=="-") {
		arrows(kdata1[i,]$q_start, ycount, kdata1[i,]$q_end, ycount, col=4, code=1, length=.1, lw=2)  
	}

if (i<nrow(kdata1)) {
	if (kdata1[i,]$id != kdata1[i+1,]$id) {
		#if(kdata1[i,]$change=="TRUE") { 
		max_dotted <- min(kdata1[i,]$q_end, kdata1[i,]$q_start)
		segments(min_dotted, ycount, max_dotted, ycount, lty=3)
#		text((min_dotted + max_dotted)/2, ycount, kdata1[i,]$id, cex=.5)
		ycount <- ycount + 1
		}
	}
}

for(i in 1:nrow(merged1)) {
#for(i in nrow(kdata1):nrow(kdata1) + nrow(hit_size)) {
	if (i > 1) {
		if (merged1[i,]$id != merged1[i-1,]$id) {
		min_dotted <- max(merged1[i,]$q_start, merged1[i,]$q_end)
		}
	}
	if(merged1[i,]$direction=="+") {
		arrows(merged1[i,]$q_start, ycount, merged1[i,]$q_end, ycount, col=colour, code=2, length=.1, lw=2)  
	}
	
	if(merged1[i,]$direction=="-") {
		arrows(merged1[i,]$q_start, ycount, merged1[i,]$q_end, ycount, col=4, code=1, length=.1, lw=2)  
	}

if (i<nrow(merged1)) {
	if (merged1[i,]$id != merged1[i+1,]$id) {
		#if(merged1[i,]$change=="TRUE") { 
		max_dotted <- min(merged1[i,]$q_end, merged1[i,]$q_start)
		segments(min_dotted, ycount, max_dotted, ycount, lty=3)
#		text((min_dotted + max_dotted)/2, ycount, merged1[i,]$id, cex=.5)
		ycount <- ycount + 1
		}
	}
}

abline(v=EXT1, col=3)
abline(v=INT1, col=4)
abline(v=EXT1-5000)
abline(v=EXT1+5000)
abline(v=EXT2-5000)
abline(v=EXT2+5000)
abline(v=INT2, col=3)
abline(v=EXT2, col=4)


dev.off()
