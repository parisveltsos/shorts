args <- commandArgs(trailingOnly = TRUE)
hetName = paste(args[1])
keyName = paste(args[2])
outName = paste(args[3])

hdata <- read.table(hetName, header=T)
kdata <- read.table(keyName, header=T)

# Manual data read
# datapath <- "~/Downloads"
# hdata <- read.table(file.path(datapath, "het_small.txt"), header=T)
# kdata <- read.table(file.path(datapath, "key_small.txt"), header=T)

# str(hdata)
# str(kdata)

merged1 <- merge(hdata, kdata, by.x="key", by.y="vcf_pos", all=T )
# str(merged1)

# calculations
merged1$homo <- (merged1$X11 + merged1$X00)/(merged1$X11 + merged1$X01 + merged1$X00)
merged1$rhomo <- merged1$X00 /(merged1$X11 + merged1$X01 + merged1$X00)
merged1$ahomo <- merged1$X11 /(merged1$X11 + merged1$X01 + merged1$X00)
merged1$het <- merged1$X01 /(merged1$X11 + merged1$X01 + merged1$X00)
merged1$totals <- merged1$X11 + merged1$X01 + merged1$X00
merged1$fam <- merged1$family.x
# attach(merged1)

head(data.frame(merged1[order(merged1$rhomo, decreasing=T),]), 10)

sumdata<- data.frame(round(tapply(merged1$rhomo, list(merged1$fam), mean), digits=2))
sumdata$sd <- round(tapply(merged1$rhomo, list(merged1$fam), sd), digits=2)
colnames(sumdata) <- c('mean', 'sd')
sumdata


pdf(paste(outName,"_out1.pdf", sep=""), width=9, height=9)
par(mfrow=c(2,2)) 
par(mar=c(5,5,4,3)) 
plot(merged1$het[merged1$type=="F2"],merged1$homo[merged1$type=="F2"], main="Het vs all Homo",pch=20, col='gray', xlab="01", ylab="00 + 11")
points(merged1$het[merged1$fam=="767p"],merged1$homo[merged1$fam=="767p"], col=2, pch=20)
points(merged1$het[merged1$fam=="1192p"],merged1$homo[merged1$fam=="1192p"], col=4, pch=20)
points(merged1$het[merged1$fam=="909p"],merged1$homo[merged1$fam=="909p"], col=7, pch=20)
points(merged1$het[merged1$fam=="664p"],merged1$homo[merged1$fam=="664p"], col=3, pch=20)
points(merged1$het[merged1$fam=="1034p"],merged1$homo[merged1$fam=="1034p"], col=5, pch=20)
legend("topright", inset=0.05, legend=c("767P", "1192P", "909P", "664p", "1034p"), pch =c(20,20), col=c(2,4,7,3,5) )

plot(merged1$het[merged1$type=="F2"], merged1$rhomo[merged1$type=="F2"], main="Het vs Reference Homo", col='gray', pch=20, xlab="01", ylab="00")
points(merged1$het[merged1$fam=="767p"], merged1$rhomo[merged1$fam=="767p"], col=2, pch=20)
points(merged1$het[merged1$fam=="1192p"], merged1$rhomo[merged1$fam=="1192p"], col=4, pch=20)
points(merged1$het[merged1$fam=="909p"], merged1$rhomo[merged1$fam=="909p"], col=7, pch=20)
points(merged1$het[merged1$fam=="664p"], merged1$rhomo[merged1$fam=="664p"], col=3, pch=20)
points(merged1$het[merged1$fam=="1034p"], merged1$rhomo[merged1$fam=="1034p"], col=5, pch=20)
legend("bottomright", inset=0.05, legend=c("767P", "1192P", "909P", "664p", "1034p"), pch =c(20,20), col=c(2,4,7,3,5) )



plot(merged1$ahomo[merged1$type=="F2"], merged1$rhomo[merged1$type=="F2"], main="Homo vs Reference Homo", pch=20, col='gray', xlab="00 + 11", ylab="00")
points(merged1$ahomo[merged1$fam=="767p"], merged1$rhomo[merged1$fam=="767p"], col=2, pch=20)
points(merged1$ahomo[merged1$fam=="1192p"], merged1$rhomo[merged1$fam=="1192p"], col=4, pch=20)
points(merged1$ahomo[merged1$fam=="909p"], merged1$rhomo[merged1$fam=="909p"], col=7, pch=20)
points(merged1$ahomo[merged1$fam=="664p"], merged1$rhomo[merged1$fam=="664p"], col=3, pch=20)
points(merged1$ahomo[merged1$fam=="1034p"], merged1$rhomo[merged1$fam=="1034p"], col=5, pch=20)
legend("topright", inset=0.05, legend=c("767P", "1192P", "909P", "664p", "1034p"), pch =c(20,20), col=c(2,4,7,3,5) )

plot(merged1$het[merged1$type=="F2"], merged1$totals[merged1$type=="F2"], main="Het vs all Homo 909",pch=20, col='gray', xlab="01", ylab="Total coverage (11 + 01 + 00)")
points(merged1$het[merged1$fam=="767p"], merged1$totals[merged1$fam=="767p"], col=2, pch=20)
points(merged1$het[merged1$fam=="1192p"], merged1$totals[merged1$fam=="1192p"], col=4, pch=20)
points(merged1$het[merged1$fam=="909p"], merged1$totals[merged1$fam=="909p"], col=7, pch=20)
points(merged1$het[merged1$fam=="664p"], merged1$totals[merged1$fam=="664p"], col=3, pch=20)
points(merged1$het[merged1$fam=="1034p"], merged1$totals[merged1$fam=="1034p"], col=5, pch=20)
legend("topright", inset=0.05, legend=c("767P", "1192P", "909P", "664p", "1034p"), pch =c(20,20), col=c(2,4,7,3,5) )

dev.off()


pdf(paste(outName,"_out2.pdf", sep=""), width=9, height=9)
par(mfrow=c(2,2)) 
par(mar=c(5,5,4,3)) 
plot(merged1$het[merged1$type=="F2"],merged1$homo[merged1$type=="F2"], main="Het vs all Homo",pch=20, col='gray', xlab="01", ylab="00 + 11")
points(merged1$het[merged1$fam=="155p"],merged1$homo[merged1$fam=="155p"], col=2, pch=20)
points(merged1$het[merged1$fam=="237p"],merged1$homo[merged1$fam=="237p"], col=4, pch=20)
points(merged1$het[merged1$fam=="444p"],merged1$homo[merged1$fam=="444p"], col=7, pch=20)
points(merged1$het[merged1$fam=="502p"],merged1$homo[merged1$fam=="502p"], col=3, pch=20)
points(merged1$het[merged1$fam=="541p"],merged1$homo[merged1$fam=="541p"], col=5, pch=20)
points(merged1$het[merged1$fam=="62p"],merged1$homo[merged1$fam=="62p"], col=6, pch=20)
legend("topright", inset=0.05, legend=c("155P", "237P", "444P", "502p", "541p", "62p"), pch =c(20,20), col=c(2,4,7,3,5,6) )

plot(merged1$het[merged1$type=="F2"], merged1$rhomo[merged1$type=="F2"], main="Het vs Reference Homo", col='gray', pch=20, xlab="01", ylab="00")
points(merged1$het[merged1$fam=="155p"], merged1$rhomo[merged1$fam=="155p"], col=2, pch=20)
points(merged1$het[merged1$fam=="237p"], merged1$rhomo[merged1$fam=="237p"], col=4, pch=20)
points(merged1$het[merged1$fam=="444p"], merged1$rhomo[merged1$fam=="444p"], col=7, pch=20)
points(merged1$het[merged1$fam=="502p"], merged1$rhomo[merged1$fam=="502p"], col=3, pch=20)
points(merged1$het[merged1$fam=="541p"], merged1$rhomo[merged1$fam=="541p"], col=5, pch=20)
points(merged1$het[merged1$fam=="62p"], merged1$rhomo[merged1$fam=="62p"], col=6, pch=20)
legend("bottomright", inset=0.05, legend=c("155P", "237P", "444P", "502p", "541p", "62p"), pch =c(20,20), col=c(2,4,7,3,5,6) )



plot(merged1$ahomo[merged1$type=="F2"], merged1$rhomo[merged1$type=="F2"], main="Homo vs Reference Homo", pch=20, col='gray', xlab="00 + 11", ylab="00")
points(merged1$ahomo[merged1$fam=="155p"], merged1$rhomo[merged1$fam=="155p"], col=2, pch=20)
points(merged1$ahomo[merged1$fam=="237p"], merged1$rhomo[merged1$fam=="237p"], col=4, pch=20)
points(merged1$ahomo[merged1$fam=="444p"], merged1$rhomo[merged1$fam=="444p"], col=7, pch=20)
points(merged1$ahomo[merged1$fam=="502p"], merged1$rhomo[merged1$fam=="502p"], col=3, pch=20)
points(merged1$ahomo[merged1$fam=="541p"], merged1$rhomo[merged1$fam=="541p"], col=5, pch=20)
points(merged1$ahomo[merged1$fam=="62p"], merged1$rhomo[merged1$fam=="62p"], col=6, pch=20)
legend("topright", inset=0.05, legend=c("155P", "237P", "444P", "502p", "541p", "62p"), pch =c(20,20), col=c(2,4,7,3,5,6) )

plot(merged1$het[merged1$type=="F2"], merged1$totals[merged1$type=="F2"], main="Het vs all Homo 444",pch=20, col='gray', xlab="01", ylab="Total coverage (11 + 01 + 00)")
points(merged1$het[merged1$fam=="155p"], merged1$totals[merged1$fam=="155p"], col=2, pch=20)
points(merged1$het[merged1$fam=="237p"], merged1$totals[merged1$fam=="237p"], col=4, pch=20)
points(merged1$het[merged1$fam=="444p"], merged1$totals[merged1$fam=="444p"], col=7, pch=20)
points(merged1$het[merged1$fam=="502p"], merged1$totals[merged1$fam=="502p"], col=3, pch=20)
points(merged1$het[merged1$fam=="541p"], merged1$totals[merged1$fam=="541p"], col=5, pch=20)
points(merged1$het[merged1$fam=="62p"], merged1$totals[merged1$fam=="62p"], col=6, pch=20)
legend("topright", inset=0.05, legend=c("155P", "237P", "444P", "502p", "541p", "62p"), pch =c(20,20), col=c(2,4,7,3,5,6) )

dev.off()

