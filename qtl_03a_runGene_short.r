library(qtl)
library(dplyr)

args <- commandArgs(trailingOnly = TRUE)

imline = args[1] 
# imline = 664
pheno = args[2] 
# inpath <- "/Users/pveltsos/Documents/Uni Projects/Mimulus/mim_voom/"
# inpath <- "/Users/pveltsos/Downloads/"
inpath <- paste("/panfs/pfs.local/scratch/kelly/p860v026/qtl/out/", sep="")

load(paste(inpath, imline,'_short.Rdata', sep=""))
outpath <- paste("/panfs/pfs.local/scratch/kelly/p860v026/qtl/out/", imline, "/", sep="")
dir.create(outpath)

# pheno <- "G0801" # D0488 D0553 D0319 D0369 O1250
# Remove missing data
phenopull <- pull.pheno(mapthis, pheno.col=pheno)
# genopull <- pull.geno(mapthis)
mapthis2 <- subset(mapthis, ind=!is.na(phenopull))
# plot.map(mapthis, main=imline)
 
mapthis2 <- calc.genoprob(mapthis2, step=1, error.prob=0.001)

mapthis2 <- sim.geno(mapthis2,  n.draws=32, step=0, off.end=0.0, error.prob=1.0e-4, stepwidth = "fixed", map.function="kosambi")

scanone.w.c <- scanone(mapthis2, weights=unlist(wData[pheno]), addcovar=cData$cohort, pheno.col=pheno, method=method, model=modeltype) 

perm.w.c <- scanone(mapthis2, n.perm=permnumber, weights=unlist(wData[pheno]), pheno.col=pheno, method=method, addcovar=cData$cohort, model=modeltype)

# sink(file=file.path(outpath, paste(pheno, method, permnumber, 'threshold.txt', sep="_")), split=T)
# paste('lod',round(summary(perm.w.c)[1], digits=3))
# sink()


lodTable <- data.frame(summary(scanone.w.c, perms=perm.w.c , pvalues=TRUE))
lodTable$markers <- rownames(lodTable)


effectTable <- effectscan(mapthis2, main="Chromosome", add.legend=T, pheno.col=pheno, get.se=T)
effectTable$markers <- rownames(effectTable)
effectTable$threshold <- round(summary(perm.w.c)[1], digits=3)
effectTable$pheno <- pheno

lod.effect.table <- merge(lodTable, effectTable, by.x="markers", by.y="markers", all=F )

simple.lod.effect.table <- data.frame(
									lod.effect.table$pheno,
									lod.effect.table$markers, 
									lod.effect.table$chr.x, 
									round(lod.effect.table$pos.x, digits=3), 
									round(lod.effect.table$lod, digits=3), 
									round(lod.effect.table$pval, digits=3), 
									round(lod.effect.table$a, digits=3), 
									round(lod.effect.table$d, digits=3), 
									round(lod.effect.table$se.a, digits=3), 
									round(lod.effect.table$se.d, digits=3), 
									lod.effect.table$threshold
									)

colnames(simple.lod.effect.table) <- c('pheno', 'snp', 'lg', 'cm', 'lod', 'p', 'a', 'd', 'se.a', 'se.d', 'threshold')

citable <- data.frame(summary(scanone.w.c, format="tabByChr"))
citable$snp <- rownames(citable)
merged1 <- merge(citable, simple.lod.effect.table, by.x="snp", by.y="snp", all=F )

outTable <- select(merged1, pheno, snp, lg, cm, lod, p, a, d, se.a, se.d, threshold, lod.ci.low, lod.ci.high)

write.table(outTable, file=file.path(outpath, paste(pheno, method, permnumber, 'lods.txt', sep="_")), quote=F, row.names=F, sep="\t") 


# marker <- find.marker(mapthis2, 7, 43.279398)
# markerEffect <- effectplot(mapthis2, mname1=marker, main="Chromosome 7", add.legend=T, pheno.col=pheno)

## plot
# pdf(file.path(outpath, paste(pheno, method, permnumber,'scanone.pdf', sep="_")), width=16, height=8)
# par(mar=c(5,5,4,3))
# plot(scanone.w.c, ylab="LOD score", col=c(1), alternate.chrid=TRUE, main=paste(pheno, " single pass"), cex.main=1.8, cex.lab=1.3)
# abline(h=summary(perm.w.c)[1], lty=2, col="grey") # 5% lod single scan
# dev.off()
# 
# plot(out.hk.c, out.ehk.w, out.hk.w.c, chr=c(1), ylab="LOD score", col=c(1,2,4), alternate.chrid=TRUE, main=paste(pheno, " single pass"), cex.main=1.8, cex.lab=1.3)# dev.off()
# plot(scanone.w.c,scanone.w.c2, scanone.w.c3, ylab="LOD score", col=c(1,2,3), alternate.chrid=TRUE, main=paste(pheno, " single pass"), cex.main=1.8, cex.lab=1.3)# dev.off()
# 
