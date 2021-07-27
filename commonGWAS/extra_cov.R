library(tidyverse)
new_age <- read.table('new_age.csv',header=T,sep=',') 
ped <- read.table('input/ped.csv',header=T,sep=',') %>% arrange(Individual_ID) %>%
  select(-Age) %>% left_join(new_age)

id_to_include <- read.table('../../genom_polaka/SAMPLES_TO_INCLUDE_210716.txt',
                            col.names = 'IID')

covars <- ped %>% select(Family_ID,Individual_ID,Sex,Age) %>%
  filter(Individual_ID %in% id_to_include$IID) %>%
  mutate(Age_centered = Age - mean(Age, na.rm=T), Family_ID = 0) %>%
  relocate(Family_ID, .before = Individual_ID) %>%
  rename(FID = Family_ID, IID = Individual_ID)

covars %>% select(-Age) %>%
  write.table('input/plink_data/covars.txt',col.names = T,row.names = F,
            sep='\t',quote=F)

# fam <- read.table('input/plink_data/multisample_20210716.dv.bcfnorm.filt.unrelated.vcf.gz.fam')
# 
# pedfam <- covars %>% select(IID,Sex) %>% rename(V2 = IID,V5 = Sex)
# fam <- fam %>% select(-V5) %>% left_join(pedfam) %>% relocate(V5, .before = V6)
# write.table(fam, 'input/plink_data/multisample_20210716.dv.bcfnorm.filt.unrelated.vcf.gz.fam',
#             col.names = F,row.names = F,quote = F,sep='\t')


