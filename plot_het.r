args <- commandArgs(trailingOnly = TRUE)
hetName = paste(args[1])
keyName = paste(args[2])
outName = paste(args[3])

hdata <- read.table(hetName, header=T)
kdata <- read.table(keyName, header=T)

# Manual data read
# datapath <- "~/Desktop"
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
attach(merged1)

pdf(paste(outName,"_out.pdf", sep=""), width=9, height=9)
par(mfrow=c(2,2)) 
par(mar=c(5,5,4,3)) 
plot(het[type=="F2"], homo[type=="F2"], main="Het vs all Homo",pch=20, col='gray', xlab="01", ylab="00 + 11")
points(het[fam=="767p"], homo[fam=="767p"], col=2, pch=20)
points(het[fam=="1192p"], homo[fam=="1192p"], col=4, pch=20)
points(het[fam=="909p"], homo[fam=="909p"], col=7, pch=20)
points(het[fam=="664p"], homo[fam=="664p"], col=3, pch=20)
legend("topright", inset=0.05, legend=c("767P", "1192P", "909P", "664p"), pch =c(20,20), col=c(2,4,7,3) )

plot(het[type=="F2"], rhomo[type=="F2"], main="Het vs Reference Homo", col='gray', pch=20, xlab="01", ylab="00")
points(het[fam=="767p"], rhomo[fam=="767p"], col=2, pch=20)
points(het[fam=="1192p"], rhomo[fam=="1192p"], col=4, pch=20)
points(het[fam=="909p"], rhomo[fam=="909p"], col=7, pch=20)
points(het[fam=="664p"], rhomo[fam=="664p"], col=3, pch=20)
legend("bottomright", inset=0.05, legend=c("767P", "1192P", "909P", "664p"), pch =c(20,20), col=c(2,4,7,3) )



plot(ahomo[type=="F2"], rhomo[type=="F2"], main="Homo vs Reference Homo", pch=20, col='gray', xlab="00 + 11", ylab="00")
points(ahomo[fam=="767p"], rhomo[fam=="767p"], col=2, pch=20)
points(ahomo[fam=="1192p"], rhomo[fam=="1192p"], col=4, pch=20)
points(ahomo[fam=="909p"], rhomo[fam=="909p"], col=7, pch=20)
points(ahomo[fam=="664p"], rhomo[fam=="664p"], col=3, pch=20)
legend("topright", inset=0.05, legend=c("767P", "1192P", "909P", "664p"), pch =c(20,20), col=c(2,4,7,3) )

plot(het[type=="F2"], totals[type=="F2"], main="Het vs all Homo 909",pch=20, col='gray', xlab="01", ylab="Total coverage (11 + 01 + 00)")
points(het[fam=="767p"], totals[fam=="767p"], col=2, pch=20)
points(het[fam=="1192p"], totals[fam=="1192p"], col=4, pch=20)
points(het[fam=="909p"], totals[fam=="909p"], col=7, pch=20)
points(het[fam=="664p"], totals[fam=="664p"], col=3, pch=20)
legend("topright", inset=0.05, legend=c("767P", "1192P", "909P", "664p"), pch =c(20,20), col=c(2,4,7,3) )

dev.off()

