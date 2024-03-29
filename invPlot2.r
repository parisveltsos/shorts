library(dplyr)

args <- commandArgs(trailingOnly = TRUE)

CONTIG=paste(args[1])
EXT1=as.numeric(paste(args[2]))
INT1=as.numeric(paste(args[3]))
INT2=as.numeric(paste(args[4]))
EXT2=as.numeric(paste(args[5]))
GENE1=paste(args[6])
GENE2=paste(args[7])
NOTE=paste(args[8])

gffdatapath <- "/panfs/pfs.local/scratch/kelly/p860v026/minimap"
exdata <- read.table(file.path(gffdatapath, "767_ruby.gff"), header=F)
exdata_gene <- subset(exdata, exdata$V3=="gene" & exdata$V1==CONTIG)


datapath <- paste("/panfs/pfs.local/scratch/kelly/p860v026/minimap/", NOTE, sep="")

k155data <- read.table(file.path(datapath, paste('intervalDepth.pulled', CONTIG, EXT1, EXT2, '155.paf', sep=".")), header=F)
k237data <- read.table(file.path(datapath, paste('intervalDepth.pulled', CONTIG, EXT1, EXT2, '237.paf', sep=".")), header=F)
k444data <- read.table(file.path(datapath, paste('intervalDepth.pulled', CONTIG, EXT1, EXT2, '444.paf', sep=".")), header=F)
k502data <- read.table(file.path(datapath, paste('intervalDepth.pulled', CONTIG, EXT1, EXT2, '502.paf', sep=".")), header=F)
k541data <- read.table(file.path(datapath, paste('intervalDepth.pulled', CONTIG, EXT1, EXT2, '541.paf', sep=".")), header=F)
k664data <- read.table(file.path(datapath, paste('intervalDepth.pulled', CONTIG, EXT1, EXT2, '664.paf', sep=".")), header=F)
k767data <- read.table(file.path(datapath, paste('intervalDepth.pulled', CONTIG, EXT1, EXT2, '767.paf', sep=".")), header=F)
k909data <- read.table(file.path(datapath, paste('intervalDepth.pulled', CONTIG, EXT1, EXT2, '909.paf', sep=".")), header=F)
k1034data <- read.table(file.path(datapath, paste('intervalDepth.pulled', CONTIG, EXT1, EXT2, '1034.paf', sep=".")), header=F)
k1192data <- read.table(file.path(datapath, paste('intervalDepth.pulled', CONTIG, EXT1, EXT2, '1192.paf', sep=".")), header=F)

colnames(k155data) <-  c('int', 'bp', 'c1', 'x155')
colnames(k237data) <-  c('int', 'bp', 'c1', 'x237')
colnames(k444data) <-  c('int', 'bp', 'c1', 'x444')
colnames(k502data) <-  c('int', 'bp', 'c1', 'x502')
colnames(k541data) <-  c('int', 'bp', 'c1', 'x541')
colnames(k664data) <-  c('int', 'bp', 'c1', 'x664')
colnames(k767data) <-  c('int', 'bp', 'c1', 'x767')
colnames(k909data) <-  c('int', 'bp', 'c1', 'x909')
colnames(k1034data) <- c('int', 'bp', 'c1', 'x1034')
colnames(k1192data) <- c('int', 'bp', 'c1', 'x1192')

alldata <- data.frame(k155data$int, k155data$bp, k155data$x155, k237data$x237, k444data$x444, k502data$x502, k541data$x541, k664data$x664, k767data$x767, k909data$x909, k1034data$x1034, k1192data$x1192)

names(alldata) <- c('int', 'bp', 'x155', 'x237', 'x444', 'x502', 'x541', 'x664', 'x767', 'x909', 'x1034', 'x1192')
write.table(alldata, file=file.path(datapath, "rule3.txt"), quote=F, row.names=F, sep="\t")
sub1 <- subset(alldata, alldata$int=='int1')
sub2 <- subset(alldata, alldata$int=='int2')

int1_zero_155 <- nrow(sub1) - as.numeric(summary(sub1$x155==0)[2]) 
int1_zero_237 <- nrow(sub1) - as.numeric(summary(sub1$x237==0)[2]) 
int1_zero_444 <- nrow(sub1) - as.numeric(summary(sub1$x444==0)[2]) 
int1_zero_502 <- nrow(sub1) - as.numeric(summary(sub1$x502==0)[2]) 
int1_zero_541 <- nrow(sub1) - as.numeric(summary(sub1$x541==0)[2]) 
int1_zero_664 <- nrow(sub1) - as.numeric(summary(sub1$x664==0)[2]) 
int1_zero_767 <- nrow(sub1) - as.numeric(summary(sub1$x767==0)[2]) 
int1_zero_909 <- nrow(sub1) - as.numeric(summary(sub1$x909==0)[2]) 
int1_zero_1034 <- nrow(sub1) - as.numeric(summary(sub1$x1034==0)[2]) 
int1_zero_1192 <- nrow(sub1) - as.numeric(summary(sub1$x1192==0)[2]) 

int2_zero_155 <- nrow(sub2) - as.numeric(summary(sub2$x155==0)[2]) 
int2_zero_237 <- nrow(sub2) - as.numeric(summary(sub2$x237==0)[2]) 
int2_zero_444 <- nrow(sub2) - as.numeric(summary(sub2$x444==0)[2]) 
int2_zero_502 <- nrow(sub2) - as.numeric(summary(sub2$x502==0)[2]) 
int2_zero_541 <- nrow(sub2) - as.numeric(summary(sub2$x541==0)[2]) 
int2_zero_664 <- nrow(sub2) - as.numeric(summary(sub2$x664==0)[2]) 
int2_zero_767 <- nrow(sub2) - as.numeric(summary(sub2$x767==0)[2]) 
int2_zero_909 <- nrow(sub2) - as.numeric(summary(sub2$x909==0)[2]) 
int2_zero_1034 <- nrow(sub2) - as.numeric(summary(sub2$x1034==0)[2]) 
int2_zero_1192 <- nrow(sub2) - as.numeric(summary(sub2$x1192==0)[2]) 

int1 <- c(int1_zero_155 , int1_zero_237 , int1_zero_444 , int1_zero_502 , int1_zero_541 , int1_zero_664 , int1_zero_767 , int1_zero_909 , int1_zero_1034, int1_zero_1192)
int2 <- c(int2_zero_155 , int2_zero_237 , int2_zero_444 , int2_zero_502 , int2_zero_541 , int2_zero_664 , int2_zero_767 , int2_zero_909 , int2_zero_1034, int2_zero_1192)

rule2 <- data.frame(int1, int2)
rule2$int1pc <- round(rule2$int1/nrow(sub1), 3) * 100
rule2$int2pc <- round(rule2$int2/nrow(sub2), 3) * 100
rownames(rule2) <- c("155", "237", "444","502","541","664","767","909","1034","1192")
rule2 <- arrange(rule2, int1pc, int2pc)
write.table(rule2, file=file.path(datapath, "rule2.txt"), quote=F, row.names=T, sep="\t")
 

maxy1 <- max(k155data$x155, k237data$x237, k444data$x444, k502data$x502, k541data$x541, k664data$x664, k767data$x767, k909data$x909, k1034data$x1034, k1192data$x1192)

pdf(file.path(datapath, "rule3.pdf"), width=12, height=6)

par(mfrow=c(2,2)) 
plot(c(EXT1, INT1), c(0, maxy1),type='n', xlab="bp", ylab="coverage", main=CONTIG, cex.main=1.8, cex.lab=1.3)
lines(k155data$bp, k155data$c1, lw=2)
lines(k237data$bp, k237data$c1, col=2, lw=2)
lines(k444data$bp, k444data$c1, col=3, lw=2)
lines(k502data$bp, k502data$c1, col=4, lw=2)
lines(k541data$bp, k541data$c1, col=5, lw=2)
lines(k767data$bp, k767data$c1, col=6, lw=2)
segments(exdata_gene$V4, maxy1, exdata_gene$V5, maxy1, lty=1, lw=4, col=4)
legend("top", inset=0.05, legend=c("155", "237", "444", "502", "541", "767"), pch =c(19), col=c(1,2,3,4,5,6), cex=.7)

plot(c(EXT1-2000, INT1+2000), c(0, maxy1),type='n', xlab="bp", ylab="coverage", main=CONTIG, cex.main=1.8, cex.lab=1.3)
lines(k664data$bp, k664data$c1, lw=2)
lines(k767data$bp, k767data$c1, col=6, lw=2)
lines(k909data$bp, k909data$c1, col=3, lw=2)
lines(k1034data$bp, k1034data$c1, col=4, lw=2)
lines(k1192data$bp, k1192data$c1, col=5, lw=2)
segments(exdata_gene$V4, maxy1, exdata_gene$V5, maxy1, lty=1, lw=4, col=4)
legend("top", inset=0.05, legend=c("664", "767", "909", "1034", "1192"), pch =c(19), col=c(1,6,3,4,5), cex=.7)

plot(c(INT2, EXT2), c(0, maxy1),type='n', xlab="bp", ylab="coverage", main=CONTIG, cex.main=1.8, cex.lab=1.3)
lines(k155data$bp, k155data$c1, lw=2)
lines(k237data$bp, k237data$c1, col=2, lw=2)
lines(k444data$bp, k444data$c1, col=3, lw=2)
lines(k502data$bp, k502data$c1, col=4, lw=2)
lines(k541data$bp, k541data$c1, col=5, lw=2)
lines(k767data$bp, k767data$c1, col=6, lw=2)
segments(exdata_gene$V4, maxy1, exdata_gene$V5, maxy1, lty=1, lw=4, col=4)
legend("top", inset=0.05, legend=c("155", "237", "444", "502", "541", "767"), pch =c(19), col=c(1,2,3,4,5,6), cex=.7)

plot(c(INT2, EXT2), c(0, maxy1),type='n', xlab="bp", ylab="coverage", main=CONTIG, cex.main=1.8, cex.lab=1.3)
lines(k664data$bp, k664data$c1, lw=2)
lines(k767data$bp, k767data$c1, col=6, lw=2)
lines(k909data$bp, k909data$c1, col=3, lw=2)
lines(k1034data$bp, k1034data$c1, col=4, lw=2)
lines(k1192data$bp, k1192data$c1, col=5, lw=2)
segments(exdata_gene$V4, maxy1, exdata_gene$V5, maxy1, lty=1, lw=4, col=4)
legend("top", inset=0.05, legend=c("664", "767", "909", "1034", "1192"), pch =c(19), col=c(1,6,3,4,5), cex=.7)
dev.off()
