 #!/usr/bin/env Rscript

suppressMessages(library(dplyr))
args = commandArgs(trailingOnly=TRUE)

pca <- read.table(args[1],header=F,sep=' ',
col.names = c('FID','IID',paste('PC',1:20,sep='')))
ped <- read.table(args[2],sep='\t',header=T)
fam <- read.table(args[3],
                  col.names = c('FID','IID','PID','MID','Sex','Pheno'),
                  header=F,
                  sep=' ')

pheno <- ped %>%
  select(Individual_ID,HGI.phenotype,Sex,Age) %>%
  mutate(A2 = ifelse(grepl('A2',HGI.phenotype)==T,1,0),
          B2 = ifelse(grepl('B2',HGI.phenotype)==T,1,0),
          C2 = ifelse(grepl('C2',HGI.phenotype)==T,1,0),
          Age_sq = Age^2,
          Age_sex = Age*Sex) %>%
  select(-HGI.phenotype) %>%
  rename(IID = Individual_ID) %>%
  arrange(IID) %>%
  left_join(pca) %>%
  filter(IID %in% fam$IID)

pheno %>% write.table("pheno.txt",
                      col.names = T,
                      row.names=F,
                      quote = F,
                      sep='\t')

sample_file <- read.table(args[4],header=F) %>% 
filter(V1 %in% fam$IID)

sample_file %>% write.table('sample_file.txt',
col.names=F,
row.names=F,
quote=F,
sep='\t')