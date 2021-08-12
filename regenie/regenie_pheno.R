library(tidyverse)
`%notin%` <- Negate(`%in%`)


regenie_fam1 <- read.table('../../output_data/OUTPUT/210719/regenieInputs/multisample_20210716.regenie.LD.prune.maf0.01.geno0.1.Eur.normID.GTflt.AB.noChrM.vqsr.flt.fam',header = F) 
regenie_fam01 <- read.table('../../output_data/OUTPUT/210719/regenieInputs/multisample_20210716.regenie.LD.prune.maf0.01.geno0.1.Eur.normID.GTflt.AB.noChrM.vqsr.flt.maf0.1perc.fam',header = F) 

id_to_include <- read.table('../../genom_polaka/SAMPLES_TO_INCLUDE_210716.txt',
                            col.names = 'IID')
ped <- read.table('input/ped.csv',header=T,sep=',') %>% 
  filter(Individual_ID %in% id_to_include$IID) %>%
  arrange(Individual_ID)

ped$Sex <- ifelse(ped$Sex == 1, 'M','F')

males_id <- ped %>% filter(Sex =='M') %>% select(Individual_ID)
females_id <- ped %>% filter(Sex =='F') %>% select(Individual_ID)

sex_id_list <- list(females_id$Individual_ID,males_id$Individual_ID)


HGI_list <- c('A2','B2','C2')
sex_list <- unique(ped$Sex)

pheno_resist <- ped %>% 
  filter(Covid_severity != 'CTRL') %>%
  mutate(Family_ID = Individual_ID, 
         Covid_resistance = ifelse(Covid_severity == 'COV_RESISTANT',1,0)) %>%
  select(Family_ID,Individual_ID,Covid_resistance)  %>% 
  arrange(Individual_ID) %>% 
  rename(V1 = Family_ID, V2 = Individual_ID)

pheno_resist <- regenie_fam1 %>% select(V1,V2) %>% left_join(pheno_resist)

pheno_resist %>% write.table('../../output_data/OUTPUT/210719/regenieInputs/pheno_resist.txt',
                             col.names = T,row.names = F,quote = F,sep='\t')

for (h in 1:length(HGI_list)) {
  for (sex in 1:length(sex_list)) {
  pheno <- ped %>% 
    mutate(Family_ID = Individual_ID, 
           severity = ifelse(grepl(HGI_list[h],HGI.phenotype),1,0)) %>%
    select(Family_ID,Individual_ID,severity)  %>% 
    arrange(Individual_ID) %>% 
    rename(V1 = Family_ID, V2 = Individual_ID, A2 = severity)
  
  pheno_final <- regenie_fam1 %>% select(V1,V2) %>% left_join(pheno) 
  colnames(pheno_final) <- c('FID','IID',HGI_list[h])
  
  write.table(pheno_final,paste('../../output_data/OUTPUT/210719/regenieInputs/total_pheno',
  HGI_list[h],'.txt',sep=''),
              col.names = T,row.names = F,quote = F,sep='\t')
  
    sex_pheno <- pheno_final
    sex_pheno2 <- sex_pheno %>% filter(IID %in% sex_id_list[[sex]])
    sex_pheno2[,3] <- NA
    sex_pheno <- sex_pheno %>% filter(IID %notin% sex_id_list[[sex]]) %>% 
      bind_rows(sex_pheno2)
    colnames(sex_pheno) <- c('FID','IID',paste(sex_list[sex],HGI_list[h], sep=''))
    write.table(sex_pheno,paste('../../output_data/OUTPUT/210719/regenieInputs/','pheno',
                                sex_list[sex],HGI_list[h],'.txt',sep=''),
                col.names = T,row.names = F,quote = F,sep='\t')
  }
  
}




