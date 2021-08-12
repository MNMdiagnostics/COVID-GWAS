library(tidyverse)
ped <- read.table('input/ped.csv',header=T,sep=',')

id_to_include <- read.table('../../genom_polaka/SAMPLES_TO_INCLUDE_210716.txt',
                            col.names = 'IID')

pca <- read.table('../../output_data/OUTPUT/210719/PCA/commonPCA.txt.eigenvec',header=T)

covars <- ped %>% select(Family_ID,Individual_ID,Sex,Age) %>%
  #filter(Individual_ID %in% id_to_include$IID) %>%
  mutate(Age_sex = Age * Sex, Age_sq = Age^2, Age_sq_sex = (Age^2)*Sex, 
         Family_ID = Individual_ID) %>%
  relocate(Family_ID, .before = Individual_ID) %>%
  rename(FID = Family_ID, IID = Individual_ID) %>% inner_join(pca) %>%
  na.omit()



covars %>% 
  write.table('covars.txt',col.names = T,row.names = F,
            sep='\t',quote=F)

# fam <- read.table('input/plink_data/multisample_20210716.dv.bcfnorm.filt.unrelated.vcf.gz.fam')
# 
# pedfam <- covars %>% select(IID,Sex) %>% rename(V2 = IID,V5 = Sex)
# fam <- fam %>% select(-V5) %>% left_join(pedfam) %>% relocate(V5, .before = V6)
# write.table(fam, 'input/plink_data/multisample_20210716.dv.bcfnorm.filt.unrelated.vcf.gz.fam',
#             col.names = F,row.names = F,quote = F,sep='\t')


