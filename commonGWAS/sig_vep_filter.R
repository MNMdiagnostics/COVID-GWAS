library(tidyverse)
library(data.table)

sig <- read.table('sig_snp.tsv', header=F)

vep <- fread('/genom_polaka/input/multisample_20210519.dv.bcfnorm.filtered.vep_CLINVAR.tsv.gz',skip=120,showProgress=T) %>% 
  filter(PICK == 1)

sig_vep <- vep %>% filter(`#Uploaded_variation` %in% sig$V1)

sig_vep %>% write.table('sig_snp.vep.tsv',col.names = T,row.names = F,quote = F,sep='\t')
