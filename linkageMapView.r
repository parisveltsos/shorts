library(LinkageMapView)


datapath <- "~/Desktop"
chr6 <- read.table(file.path(datapath, "chr6.genotypes.txt"), header=T)
outfile = file.path("~/Desktop/chr6.pdf")
lmv.linkage.plot(chr6, outfile)

lmv.linkage.plot(mapthis2, qtlscanone=scanone.w.c, outfile)
lmv.linkage.plot(mapthis, denmap=TRUE, rsegcol="2", outfile)

