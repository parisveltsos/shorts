library(qtl)

args <- commandArgs(trailingOnly = TRUE)

imline = args[1] 
pheno = args[2] 

inpath <- paste("/panfs/pfs.local/scratch/kelly/p860v026/qtl/out/", sep="")
outpath <- paste("/panfs/pfs.local/scratch/kelly/p860v026/qtl/out/", imline, "/", sep="")
dir.create(outpath)

load(paste(inpath, imline,'.Rdata', sep=""))

# pheno <- "D0369" # D0488 D0553 D0319 D0369
# Remove missing data
phenopull <- pull.pheno(mapthis, pheno.col=pheno)
# genopull <- pull.geno(mapthis)
mapthis2 <- subset(mapthis, ind=!is.na(phenopull))

mapthis2 <- calc.genoprob(mapthis2, step=1, error.prob=0.001)

mapthis2 <- sim.geno(mapthis2,  n.draws=32, step=0, off.end=0.0, error.prob=1.0e-4, stepwidth = "fixed", map.function="kosambi")

scanone.w.c <- scanone(mapthis2, weights=unlist(wData[pheno]), addcovar=cData$cohort, pheno.col=pheno, method=method, model=modeltype) 

perm.w.c <- scanone(mapthis2, n.perm=permnumber, weights=unlist(wData[pheno]), pheno.col=pheno, method="hk", addcovar=cData$cohort, model=modeltype)

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

write.table(simple.lod.effect.table, file=file.path(outpath, paste(pheno, method, permnumber, 'lods.txt', sep="_")), quote=F, row.names=F, sep="\t") 





# marker <- find.marker(mapthis2, 1, 3.226)
# markerEffect <- effectplot(mapthis2, mname1=marker, main="Chromosome 3", add.legend=T, pheno.col=pheno)



## plot
# pdf(file.path(outpath, paste(pheno, method, permnumber,'scanone.pdf', sep="_")), width=16, height=8)
# par(mar=c(5,5,4,3))
# plot(scanone.w.c, ylab="LOD score", col=c(1), alternate.chrid=TRUE, main=paste(pheno, " single pass"), cex.main=1.8, cex.lab=1.3)
# abline(h=summary(perm.w.c)[1], lty=2, col="grey") # 5% lod single scan
# plot(out.hk.c, out.ehk.w, out.hk.w.c, chr=c(1), ylab="LOD score", col=c(1,2,4), alternate.chrid=TRUE, main=paste(pheno, " single pass"), cex.main=1.8, cex.lab=1.3)# dev.off()

