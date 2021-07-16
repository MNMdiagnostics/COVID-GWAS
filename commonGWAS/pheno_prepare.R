library(tidyverse)

ped <- read.table('input/plink_data/ped_data.csv',header=T,sep=',')
id_to_include <- read.table('../../genom_polaka/SAMPLES_TO_INCLUDE_210519.txt',
                            col.names = 'IID')


pheno <- ped %>% 
  filter(Polish_Genome_included == 1 & Individual_ID %in% id_to_include$IID) %>%
  mutate(Family_ID = 0, 
         severity = ifelse(Covid_severity == 'COV_SEVERE',2,1),
         resistance = ifelse(Covid_severity == 'COV_RESISTANT',2,1)) %>%
  mutate(severity = ifelse(Covid_severity == 'CTRL',-9,severity),
         resistance = ifelse(Covid_severity == 'CTRL',-9,resistance)
         ) %>%
  select(Family_ID,Individual_ID,severity) 

pheno %>% write.table('input/plink_data/pheno_severe.txt',sep='\t', row.names = F,
                             col.names = T,quote = F)  

covar <- ped %>% 
  filter(Polish_Genome_included == 1 & Individual_ID %in% id_to_include$IID) %>%
  mutate(Family_ID = 0, 
         severity = ifelse(Covid_severity == 'COV_SEVERE',2,1),
         resistance = ifelse(Covid_severity == 'COV_RESISTANT',2,1)) %>%
  mutate(severity = ifelse(Covid_severity == 'CTRL',-9,severity),
         resistance = ifelse(Covid_severity == 'CTRL',-9,resistance)
  ) %>%
  select(Family_ID,Individual_ID,Sex,severity,resistance,Age)
