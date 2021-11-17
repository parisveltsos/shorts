args <- commandArgs(trailingOnly = TRUE)
hetName = paste(args[1])
keyName = paste(args[2])
outName = paste(args[3])

hdata <- read.table(hetName, header=T)
kdata <- read.table(keyName, header=T)

# Manual data read
# datapath <- "~/Desktop"
# hdata <- read.table(file.path(datapath, "het_1192.txt"), header=T)
# kdata <- read.table(file.path(datapath, "key_1192.txt"), header=T)

# str(hdata)
# str(kdata)

merged1 <- merge(hdata, kdata, by.x="id", by.y="sample_name", all=T )
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

sumdata <- data.frame(round(tapply(merged1$rhomo, list(merged1$fam), mean), digits=2))
sumdata$sd <- round(tapply(merged1$rhomo, list(merged1$fam), sd), digits=2)
colnames(sumdata) <- c('mean', 'sd')
sumdata


pdf(paste(outName,"_out1.pdf", sep=""), width=9, height=9)
par(mfrow=c(2,2)) 
par(mar=c(5,5,4,3)) 
plot(merged1$het[merged1$type=="F2"],merged1$homo[merged1$type=="F2"], main="Het vs all Homo",pch=20, col='gray', xlab="01", ylab="00 + 11")
points(merged1$het[merged1$fam=="767" & merged1$type=="Parental_line"],merged1$homo[merged1$fam=="767" & merged1$type=="Parental_line"], col=2, pch=20)
points(merged1$het[merged1$fam=="1192" & merged1$type=="Parental_line"],merged1$homo[merged1$fam=="1192" & merged1$type=="Parental_line"], col=4, pch=20)
points(merged1$het[merged1$fam=="909" & merged1$type=="Parental_line"],merged1$homo[merged1$fam=="909" & merged1$type=="Parental_line"], col=7, pch=20)
points(merged1$het[merged1$fam=="664" & merged1$type=="Parental_line"],merged1$homo[merged1$fam=="664" & merged1$type=="Parental_line"], col=3, pch=20)
points(merged1$het[merged1$fam=="1034" & merged1$type=="Parental_line"],merged1$homo[merged1$fam=="1034" & merged1$type=="Parental_line"], col=5, pch=20)
legend("topright", inset=0.05, legend=c("767P", "1192P", "909P", "664P", "1034P"), pch =c(20,20), col=c(2,4,7,3,5) )

plot(merged1$het[merged1$type=="F2"], merged1$rhomo[merged1$type=="F2"], main="Het vs Reference Homo", col='gray', pch=20, xlab="01", ylab="00")
points(merged1$het[merged1$fam=="767" & merged1$type=="Parental_line"], merged1$rhomo[merged1$fam=="767" & merged1$type=="Parental_line"], col=2, pch=20)
points(merged1$het[merged1$fam=="1192" & merged1$type=="Parental_line"], merged1$rhomo[merged1$fam=="1192" & merged1$type=="Parental_line"], col=4, pch=20)
points(merged1$het[merged1$fam=="909" & merged1$type=="Parental_line"], merged1$rhomo[merged1$fam=="909" & merged1$type=="Parental_line"], col=7, pch=20)
points(merged1$het[merged1$fam=="664" & merged1$type=="Parental_line"], merged1$rhomo[merged1$fam=="664" & merged1$type=="Parental_line"], col=3, pch=20)
points(merged1$het[merged1$fam=="1034" & merged1$type=="Parental_line"], merged1$rhomo[merged1$fam=="1034" & merged1$type=="Parental_line"], col=5, pch=20)
# legend("topright", inset=0.05, legend=c("767P", "1192P", "909P", "664P", "1034P"), pch =c(20,20), col=c(2,4,7,3,5) )


plot(merged1$ahomo[merged1$type=="F2"], merged1$rhomo[merged1$type=="F2"], main="Homo vs Reference Homo", pch=20, col='gray', xlab="00 + 11", ylab="00")
points(merged1$ahomo[merged1$fam=="767" & merged1$type=="Parental_line"], merged1$rhomo[merged1$fam=="767" & merged1$type=="Parental_line"], col=2, pch=20)
points(merged1$ahomo[merged1$fam=="1192" & merged1$type=="Parental_line"], merged1$rhomo[merged1$fam=="1192" & merged1$type=="Parental_line"], col=4, pch=20)
points(merged1$ahomo[merged1$fam=="909" & merged1$type=="Parental_line"], merged1$rhomo[merged1$fam=="909" & merged1$type=="Parental_line"], col=7, pch=20)
points(merged1$ahomo[merged1$fam=="664" & merged1$type=="Parental_line"], merged1$rhomo[merged1$fam=="664" & merged1$type=="Parental_line"], col=3, pch=20)
points(merged1$ahomo[merged1$fam=="1034" & merged1$type=="Parental_line"], merged1$rhomo[merged1$fam=="1034" & merged1$type=="Parental_line"], col=5, pch=20)
# legend("topright", inset=0.05, legend=c("767P", "1192P", "909P", "664P", "1034P"), pch =c(20,20), col=c(2,4,7,3,5) )

plot(merged1$het[merged1$type=="F2"], merged1$totals[merged1$type=="F2"], main="Het vs all Homo LINE",pch=20, col='gray', xlab="01", ylab="Total coverage (11 + 01 + 00)")
points(merged1$het[merged1$fam=="767" & merged1$type=="Parental_line"], merged1$totals[merged1$fam=="767" & merged1$type=="Parental_line"], col=2, pch=20)
points(merged1$het[merged1$fam=="1192" & merged1$type=="Parental_line"], merged1$totals[merged1$fam=="1192" & merged1$type=="Parental_line"], col=4, pch=20)
points(merged1$het[merged1$fam=="909" & merged1$type=="Parental_line"], merged1$totals[merged1$fam=="909" & merged1$type=="Parental_line"], col=7, pch=20)
points(merged1$het[merged1$fam=="664" & merged1$type=="Parental_line"], merged1$totals[merged1$fam=="664" & merged1$type=="Parental_line"], col=3, pch=20)
points(merged1$het[merged1$fam=="1034" & merged1$type=="Parental_line"], merged1$totals[merged1$fam=="1034" & merged1$type=="Parental_line"], col=5, pch=20)
# legend("topright", inset=0.05, legend=c("767P", "1192P", "909P", "664P", "1034P"), pch =c(20,20), col=c(2,4,7,3,5) )

dev.off()


pdf(paste(outName,"_out2.pdf", sep=""), width=9, height=9)
par(mfrow=c(2,2)) 
par(mar=c(5,5,4,3)) 
plot(merged1$het[merged1$type=="F2"],merged1$homo[merged1$type=="F2"], main="Het vs all Homo",pch=20, col='gray', xlab="01", ylab="00 + 11")
points(merged1$het[merged1$fam=="155" & merged1$type=="Parental_line"],merged1$homo[merged1$fam=="155" & merged1$type=="Parental_line"], col=2, pch=20)
points(merged1$het[merged1$fam=="237" & merged1$type=="Parental_line"],merged1$homo[merged1$fam=="237" & merged1$type=="Parental_line"], col=4, pch=20)
points(merged1$het[merged1$fam=="444" & merged1$type=="Parental_line"],merged1$homo[merged1$fam=="444" & merged1$type=="Parental_line"], col=7, pch=20)
points(merged1$het[merged1$fam=="502" & merged1$type=="Parental_line"],merged1$homo[merged1$fam=="502" & merged1$type=="Parental_line"], col=3, pch=20)
points(merged1$het[merged1$fam=="541" & merged1$type=="Parental_line"],merged1$homo[merged1$fam=="541" & merged1$type=="Parental_line"], col=5, pch=20)
points(merged1$het[merged1$fam=="62" & merged1$type=="Parental_line"],merged1$homo[merged1$fam=="62" & merged1$type=="Parental_line"], col=6, pch=20)
legend("topright", inset=0.05, legend=c("155P", "237P", "444P", "502P", "541P", "62P"), pch =c(20,20), col=c(2,4,7,3,5,6) )

plot(merged1$het[merged1$type=="F2"], merged1$rhomo[merged1$type=="F2"], main="Het vs Reference Homo", col='gray', pch=20, xlab="01", ylab="00")
points(merged1$het[merged1$fam=="155" & merged1$type=="Parental_line"], merged1$rhomo[merged1$fam=="155" & merged1$type=="Parental_line"], col=2, pch=20)
points(merged1$het[merged1$fam=="237" & merged1$type=="Parental_line"], merged1$rhomo[merged1$fam=="237" & merged1$type=="Parental_line"], col=4, pch=20)
points(merged1$het[merged1$fam=="444" & merged1$type=="Parental_line"], merged1$rhomo[merged1$fam=="444" & merged1$type=="Parental_line"], col=7, pch=20)
points(merged1$het[merged1$fam=="502" & merged1$type=="Parental_line"], merged1$rhomo[merged1$fam=="502" & merged1$type=="Parental_line"], col=3, pch=20)
points(merged1$het[merged1$fam=="541" & merged1$type=="Parental_line"], merged1$rhomo[merged1$fam=="541" & merged1$type=="Parental_line"], col=5, pch=20)
points(merged1$het[merged1$fam=="62" & merged1$type=="Parental_line"], merged1$rhomo[merged1$fam=="62" & merged1$type=="Parental_line"], col=6, pch=20)
legend("topright", inset=0.05, legend=c("155P", "237P", "444P", "502P", "541P", "62P"), pch =c(20,20), col=c(2,4,7,3,5,6) )



plot(merged1$ahomo[merged1$type=="F2"], merged1$rhomo[merged1$type=="F2"], main="Homo vs Reference Homo", pch=20, col='gray', xlab="00 + 11", ylab="00")
points(merged1$ahomo[merged1$fam=="155" & merged1$type=="Parental_line"], merged1$rhomo[merged1$fam=="155" & merged1$type=="Parental_line"], col=2, pch=20)
points(merged1$ahomo[merged1$fam=="237" & merged1$type=="Parental_line"], merged1$rhomo[merged1$fam=="237" & merged1$type=="Parental_line"], col=4, pch=20)
points(merged1$ahomo[merged1$fam=="444" & merged1$type=="Parental_line"], merged1$rhomo[merged1$fam=="444" & merged1$type=="Parental_line"], col=7, pch=20)
points(merged1$ahomo[merged1$fam=="502" & merged1$type=="Parental_line"], merged1$rhomo[merged1$fam=="502" & merged1$type=="Parental_line"], col=3, pch=20)
points(merged1$ahomo[merged1$fam=="541" & merged1$type=="Parental_line"], merged1$rhomo[merged1$fam=="541" & merged1$type=="Parental_line"], col=5, pch=20)
points(merged1$ahomo[merged1$fam=="62" & merged1$type=="Parental_line"], merged1$rhomo[merged1$fam=="62" & merged1$type=="Parental_line"], col=6, pch=20)
legend("topright", inset=0.05, legend=c("155P", "237P", "444P", "502P", "541P", "62P"), pch =c(20,20), col=c(2,4,7,3,5,6) )

plot(merged1$het[merged1$type=="F2"], merged1$totals[merged1$type=="F2"], main="Het vs all Homo 444",pch=20, col='gray', xlab="01", ylab="Total coverage (11 + 01 + 00)")
points(merged1$het[merged1$fam=="155" & merged1$type=="Parental_line"], merged1$totals[merged1$fam=="155" & merged1$type=="Parental_line"], col=2, pch=20)
points(merged1$het[merged1$fam=="237" & merged1$type=="Parental_line"], merged1$totals[merged1$fam=="237" & merged1$type=="Parental_line"], col=4, pch=20)
points(merged1$het[merged1$fam=="444" & merged1$type=="Parental_line"], merged1$totals[merged1$fam=="444" & merged1$type=="Parental_line"], col=7, pch=20)
points(merged1$het[merged1$fam=="502" & merged1$type=="Parental_line"], merged1$totals[merged1$fam=="502" & merged1$type=="Parental_line"], col=3, pch=20)
points(merged1$het[merged1$fam=="541" & merged1$type=="Parental_line"], merged1$totals[merged1$fam=="541" & merged1$type=="Parental_line"], col=5, pch=20)
points(merged1$het[merged1$fam=="62" & merged1$type=="Parental_line"], merged1$totals[merged1$fam=="62" & merged1$type=="Parental_line"], col=6, pch=20)
legend("topright", inset=0.05, legend=c("155P", "237P", "444P", "502P", "541P", "62P"), pch =c(20,20), col=c(2,4,7,3,5,6) )

dev.off()

