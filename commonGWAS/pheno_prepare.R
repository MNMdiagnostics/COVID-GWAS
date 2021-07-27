library(tidyverse)

id_to_include <- read.table('../../genom_polaka/SAMPLES_TO_INCLUDE_210716.txt',
                            col.names = 'IID')
ped <- read.table('input/ped.csv',header=T,sep=',') %>% 
  filter(Individual_ID %in% id_to_include$IID) %>%
  arrange(Individual_ID)


pheno <- ped %>% 
  mutate(Family_ID = 0, 
         severity = ifelse(Covid_severity == 'COV_SEVERE',2,1),
         resistance = ifelse(Covid_severity == 'COV_RESISTANT',2,1)) %>%
  mutate(severity = ifelse(Covid_severity == 'CTRL',-9,severity),
         resistance = ifelse(Covid_severity == 'CTRL',-9,resistance)
         ) %>%
  select(Family_ID,Individual_ID,severity,resistance)  %>% 
  arrange(Individual_ID) %>% 
  rename(FID = Family_ID, IID = Individual_ID)


pheno %>% write.table('input/plink_data/pheno_severe_resist.txt',sep='\t', row.names = F,
                             col.names = T,quote = F)  

fam <- read.table('input/plink_data/CARDIAC/multisample_20210716.CARDIAC.splitX.fam',header = F)
fam <- fam %>% rename(Individual_ID = V2) %>% select(-V5)

bcfploidy <- read.table('input/plink_data/sex_check/gender.txt')
bcfploidy <- bcfploidy %>% mutate(V2 = ifelse(bcfploidy$V2 == 'M',1,2)) %>%
  rename(V5 = V2, Individual_ID = V1)

fam_final <- ped %>% select(Individual_ID,Sex) %>% left_join(fam) %>%
  relocate(Sex, .before = V6) %>% relocate(V1, .before=Individual_ID)

fam_final %>% write.table('input/plink_data/CARDIAC/multisample_20210716.CARDIAC.splitX.fam',
                    col.names = F,row.names = F,quote = F)

# 
# covar <- ped %>% 
#   filter(Polish_Genome_included == 1 & Individual_ID %in% id_to_include$IID) %>%
#   mutate(Family_ID = 0, 
#          severity = ifelse(Covid_severity == 'COV_SEVERE',2,1),
#          resistance = ifelse(Covid_severity == 'COV_RESISTANT',2,1)) %>%
#   mutate(severity = ifelse(Covid_severity == 'CTRL',-9,severity),
#          resistance = ifelse(Covid_severity == 'CTRL',-9,resistance)
#   ) %>%
#   select(Family_ID,Individual_ID,Age)
