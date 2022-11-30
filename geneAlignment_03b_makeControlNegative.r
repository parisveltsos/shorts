args <- commandArgs(trailingOnly = TRUE)
GENE = args[1]
DISTANCE = as.numeric(paste(args[2]))

datapath <- "/panfs/pfs.local/scratch/kelly/p860v026/compareGenomes"
kdata <- read.table(file.path(datapath, paste(GENE, "_", DISTANCE, "_temp_control_negative.txt", sep="")), header=F)
#F1509_200_temp_control_negative.txt
#1034    tig00000018_1   9145595 9146683
#1034    tig00000018_1   9148940 9149650

colnames(kdata) <- c('line', 'chromosome', 'min', 'max')

l62_min <- min(kdata$min[kdata$line=='62'])
l62_max <- max(kdata$max[kdata$line=='62'])
l62_chr <- kdata$chromosome[kdata$line=='62'][1]

l155_min <- min(kdata$min[kdata$line=='155'])
l155_max <- max(kdata$max[kdata$line=='155'])
l155_chr <- kdata$chromosome[kdata$line=='155'][1]

l444_min <- min(kdata$min[kdata$line=='444'])
l444_max <- max(kdata$max[kdata$line=='444'])
l444_chr <- kdata$chromosome[kdata$line=='444'][1]

l502_min <- min(kdata$min[kdata$line=='502'])
l502_max <- max(kdata$max[kdata$line=='502'])
l502_chr <- kdata$chromosome[kdata$line=='502'][1]

l541_min <- min(kdata$min[kdata$line=='541'])
l541_max <- max(kdata$max[kdata$line=='541'])
l541_chr <- kdata$chromosome[kdata$line=='541'][1]

l664_min <- min(kdata$min[kdata$line=='664'])
l664_max <- max(kdata$max[kdata$line=='664'])
l664_chr <- kdata$chromosome[kdata$line=='664'][1]

l767_min <- min(kdata$min[kdata$line=='767'])
l767_max <- max(kdata$max[kdata$line=='767'])
l767_chr <- kdata$chromosome[kdata$line=='767'][1]

l909_min <- min(kdata$min[kdata$line=='909'])
l909_max <- max(kdata$max[kdata$line=='909'])
l909_chr <- kdata$chromosome[kdata$line=='909'][1]

l1034_min <- min(kdata$min[kdata$line=='1034'])
l1034_max <- max(kdata$max[kdata$line=='1034'])
l1034_chr <- kdata$chromosome[kdata$line=='1034'][1]

l1192_min <- min(kdata$min[kdata$line=='1192'])
l1192_max <- max(kdata$max[kdata$line=='1192'])
l1192_chr <- kdata$chromosome[kdata$line=='1192'][1]

kdata2 <- data.frame(cbind (	c("62", "155", "444", "502", "541", "664", "767", "909", "1034", "1192") ,
		c(l62_chr, l155_chr, l444_chr, l502_chr, l541_chr, l664_chr, l767_chr, l909_chr, l1034_chr, l1192_chr) , 
		c(l62_min, l155_min, l444_min, l502_min, l541_min, l664_min, l767_min, l909_min, l1034_min, l1192_min) , 
		c(l62_max, l155_max, l444_max, l502_max, l541_max, l664_max, l767_max, l909_max, l1034_max, l1192_max)
		))

names(kdata2) <- c("line", "chr", "min", "max")

kdata2$min <- as.numeric(kdata2$min) - DISTANCE
kdata2$max <- as.numeric(kdata2$max) + DISTANCE

kdata3 <- subset(kdata2, !is.na(kdata2$chr))


write.table(kdata3, file=file.path(datapath, paste(GENE, DISTANCE, "temp_control_negative2.txt", sep="_")), quote=F, row.names=F, sep="\t")

