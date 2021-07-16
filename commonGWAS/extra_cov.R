library(tidyverse)

ped <- read.table('input/plink_data/ped_data.csv',header=T,sep=',')
id_to_include <- read.table('../../genom_polaka/SAMPLES_TO_INCLUDE_210519.txt',
                            col.names = 'IID')

pheno <- ped %>% 
  filter(Polish_Genome_included == 1 & Individual_ID %in% id_to_include$IID) %>%
  mutate(Family_ID = 0)

covar <- pheno %>% select(Family_ID,Individual_ID,Sex) %>%
  mutate(Sex = ifelse(Sex == 1,'M','F'))

covar %>% write.table('input/GCTA/sex.covar',sep='\t', row.names = F,
                      col.names = T,quote = F)

extra_covars <- read.table('commonGWAS/extra_cov.tsv',header=T) %>%
  mutate(BMI = w/((h/100)^2)) %>% select(Individual_ID,BMI)


covar <- pheno %>% select(Family_ID,Individual_ID,Age) %>% 
  left_join(extra_covars) %>% select(-BMI)

covar %>% write.table('input/GCTA/age.qcovar',sep='\t', row.names = F,
                      col.names = T,quote = F)

