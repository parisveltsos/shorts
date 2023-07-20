library(qtl)
library(dplyr)

args <- commandArgs(trailingOnly = TRUE)

imline = args[1] 
# imline = 664
pheno = args[2] 
# inpath <- "/Users/pveltsos/Documents/Uni Projects/Mimulus/mim_voom/"
# inpath <- "/Users/pveltsos/Downloads/"
inpath <- paste("/panfs/pfs.local/scratch/kelly/p860v026/qtl/out/", sep="")
inpath2 <- paste("/panfs/pfs.local/scratch/kelly/p860v026/qtl/in/", sep="")

load(paste(inpath, imline,'_long.Rdata', sep=""))
outpath <- paste("/panfs/pfs.local/scratch/kelly/p860v026/qtl/out/", imline, "/", sep="")
dir.create(outpath)

# pheno <- "O1250" # D0488 D0553 D0319 D0369
# Remove missing data
phenopull <- pull.pheno(mapthis, pheno.col=pheno)
# genopull <- pull.geno(mapthis)
mapthis2 <- subset(mapthis, ind=!is.na(phenopull))
# plot.map(mapthis, main=imline)
 
mapthis2 <- calc.genoprob(mapthis2, step=1, error.prob=0.001)

mapthis2 <- sim.geno(mapthis2,  n.draws=32, step=0, off.end=0.0, error.prob=1.0e-4, stepwidth = "fixed", map.function="kosambi")

wData <- read.table(paste(inpath2, line, ".weight.txt", sep=""), header=T)

# scanone.w.c <- scanone(mapthis2, weights=unlist(wData[pheno]), pheno.col=pheno, method=method, model=modeltype) # for 62 which has no cohort

scanone.w.c <- scanone(mapthis2, weights=unlist(wData[pheno]), addcovar=cData$cohort, pheno.col=pheno, method=method, model=modeltype) 


# perm.w.c <- scanone(mapthis2, n.perm=permnumber, weights=unlist(wData[pheno]), pheno.col=pheno, method=method, addcovar=cData$cohort, model=modeltype) # not used
# 
# # sink(file=file.path(outpath, paste(pheno, method, permnumber, 'threshold.txt', sep="_")), split=T)
# # paste('lod',round(summary(perm.w.c)[1], digits=3))
# # sink()
# 
# 
# lodTable <- data.frame(summary(scanone.w.c, perms=perm.w.c , pvalues=TRUE))
# lodTable$markers <- rownames(lodTable)
# 
# 
effectTable <- effectscan(mapthis2, main="Chromosome", add.legend=T, pheno.col=pheno, get.se=T)
effectTable$markers <- rownames(effectTable)
# effectTable$threshold <- round(summary(perm.w.c)[1], digits=3)
effectTable$pheno <- pheno
# 
# lod.effect.table <- merge(lodTable, effectTable, by.x="markers", by.y="markers", all=F )
# 
# simple.lod.effect.table <- data.frame(
# 									lod.effect.table$pheno,
# 									lod.effect.table$markers, 
# 									lod.effect.table$chr.x, 
# 									round(lod.effect.table$pos.x, digits=3), 
# 									round(lod.effect.table$lod, digits=3), 
# 									round(lod.effect.table$pval, digits=3), 
# 									round(lod.effect.table$a, digits=3), 
# 									round(lod.effect.table$d, digits=3), 
# 									round(lod.effect.table$se.a, digits=3), 
# 									round(lod.effect.table$se.d, digits=3), 
# 									lod.effect.table$threshold
# 									)
# 
# colnames(simple.lod.effect.table) <- c('pheno', 'snp', 'lg', 'cm', 'lod', 'p', 'a', 'd', 'se.a', 'se.d', 'threshold')
# 
# citable <- data.frame(summary(scanone.w.c, format="tabByChr"))
# citable$snp <- rownames(citable)
# merged1 <- merge(citable, simple.lod.effect.table, by.x="snp", by.y="snp", all=F )
# 
# outTable <- select(merged1, pheno, snp, lg, cm, lod, p, a, d, se.a, se.d, threshold, lod.ci.low, lod.ci.high)
# 
# write.table(outTable, file=file.path(outpath, paste(pheno, method, permnumber, 'lods.txt', sep="_")), quote=F, row.names=F, sep="\t") 

scanone.w.c$markers <- rownames(scanone.w.c)

lod.all.effect.table <- merge(scanone.w.c, effectTable, by.x="markers", by.y="markers", all=T )

simple.lod.all.effect.table <- data.frame(
									lod.all.effect.table$pheno,
									lod.all.effect.table$markers, 
									lod.all.effect.table$chr.y, 
									round(lod.all.effect.table$pos.y, digits=3), 
									round(lod.all.effect.table$lod, digits=3), 
# 									round(lod.all.effect.table$pval, digits=3), 
									round(lod.all.effect.table$a, digits=3), 
									round(lod.all.effect.table$d, digits=3), 
									round(lod.all.effect.table$se.a, digits=3), 
									round(lod.all.effect.table$se.d, digits=3) 
#									lod.all.effect.table$threshold
									)

colnames(simple.lod.all.effect.table) <- c('pheno', 'snp', 'lg', 'cm', 'lod', 'a', 'd', 'se.a', 'se.d')

write.table(simple.lod.all.effect.table, file=file.path(outpath, paste(pheno, method, permnumber, 'lodsAll.txt', sep="_")), quote=F, row.names=F, sep="\t") 


