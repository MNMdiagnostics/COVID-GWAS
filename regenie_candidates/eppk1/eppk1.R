library(qvalue)
library(tidyverse)


eppk <- read.table('regenie_candidates/eppk1/eppk1.assoc.fisher',header=T)
vep <- read.table('regenie_candidates/eppk1/eppk1.vcf.gz.vep.tsv.gz') %>%
  select(V1,V4,V7,V14)
colnames(vep) <- c('SNP','Gene','Consequence','IMPACT')

eppk <- eppk %>% mutate(q = qvalue(eppk$P)$qvalue) %>% arrange(q) %>%
  left_join(vep)

resist_pheno <- read.table('/mnt/theta/output_data/MS_gwas_data/pheno_resist.txt',
                           col.names = c('FID','IID','Resistance')) %>%
  dplyr::select(-FID)
rare1perc <- read.table('/mnt/theta/output_data/OUTPUT/210719/regenieRes/MNM/burden.res.common.1.perc.recessive_Covid_resistance.regenie',header = T) %>%
  arrange(Pval)

toinclude <- read.table('/mnt/theta/output_data/MS_gwas_data/to_include')


anno <- read.table('/mnt/theta/output_data/OUTPUT/210719/regenieInputs/regenie.set.list.txt') %>%
  dplyr::select(V1,V4) %>%
  filter(V1 == 'ENSG00000261150') %>% 
  dplyr::select(V4) 

anno <- unlist(strsplit(anno$V4,','))


aaf <- read.table('/mnt/theta/output_data/OUTPUT/210719/regenieInputs/regenie.aaf.file.txt') %>%
  filter(V1 %in% anno & V2 == 0.1) %>%
  rename(SNP = V1, AF = V2)

masks <- read.table('/mnt/theta/output_data/OUTPUT/210719/regenieInputs/regenie.anno.file.txt') %>%
  filter(V1 %in% anno) %>%
  dplyr::select(-V2) %>%
  rename(SNP=V1,IMPACT=V3)


masks_filtered <- aaf %>% left_join(masks)


eppk1GT <- fread('regenie_candidates/eppk1/eppk1_gt.tsv') %>%
  select(V3,V4,V5) %>%
  rename(SNP=V3,sample_id=V4,GT=V5) %>%
  left_join(masks_filtered) %>%
  na.omit() %>%
  filter(IMPACT != 'missense.0in5' & GT != './.' & GT!='0/0')

eppk1GT %>% write.table('regenie_candidates/eppk1/eppk1_samples.tsv',
                        col.names = T,
                        row.names = F,
                        quote = F,
                        sep='\t')



