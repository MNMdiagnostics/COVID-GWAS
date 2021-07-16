#!/usr/bin/env Rscript
library(data.table)
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  #args[2] = "out.txt"
}

lds_seg = fread(args[1],header=T,colClasses=c("character",rep("numeric",8)))
quartiles=summary(lds_seg$ldscore_SNP)

lb1 = which(lds_seg$ldscore_SNP <= quartiles[2])
lb2 = which(lds_seg$ldscore_SNP > quartiles[2] & lds_seg$ldscore_SNP <= quartiles[3])
lb3 = which(lds_seg$ldscore_SNP > quartiles[3] & lds_seg$ldscore_SNP <= quartiles[5])
lb4 = which(lds_seg$ldscore_SNP > quartiles[5])

lb1_snp = lds_seg$SNP[lb1]
lb2_snp = lds_seg$SNP[lb2]
lb3_snp = lds_seg$SNP[lb3]
lb4_snp = lds_seg$SNP[lb4]

write.table(lb1_snp, "../input/GCTA/snp_group1.txt", row.names=F, quote=F, col.names=F)
write.table(lb2_snp, "../input/GCTA/snp_group2.txt", row.names=F, quote=F, col.names=F)
write.table(lb3_snp, "../input/GCTA/snp_group3.txt", row.names=F, quote=F, col.names=F)
write.table(lb4_snp, "../input/GCTA/snp_group4.txt", row.names=F, quote=F, col.names=F)

df <- data.frame(paste('snp_group',1:4,sep=''))
write.table(df,'../input/GCTA/multi_GRMs.txt',col.names = F,row.names = F,
                   quote = F,sep='\t')
