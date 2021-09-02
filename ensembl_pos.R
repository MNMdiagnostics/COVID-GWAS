#Get gene names annotation
library(biomaRt)
library(readxl)
library(tidyverse)
biolist <- as.data.frame(listMarts())
ensembl=useMart("ensembl")
esemblist <- as.data.frame(listDatasets(ensembl))
ensembl = useDataset("hsapiens_gene_ensembl",mart=ensembl)
filters = listFilters(ensembl)
attributes = listAttributes(ensembl)

t2g<-getBM(attributes=c('ensembl_gene_id','external_gene_name',"ensembl_gene_id_version",'chromosome_name','start_position','end_position'), mart = ensembl)

my_ids <- read.table('immunity_genes/cand_covid_genes.txt',header=T)
colnames(my_ids) <- 'external_gene_name'

my_ids.version <- my_ids %>% left_join(t2g)
#my_ids.version <- t2g %>% filter(ensembl_gene_id == 'ENSG00000261150')
tabix <- my_ids.version %>% arrange(chromosome_name,start_position) %>% 
  dplyr::select(chromosome_name:end_position) %>%
  filter(grepl('^CHR',chromosome_name)==F & chromosome_name != 'MT') %>%
  mutate(chromosome_name = paste('chr',chromosome_name,sep='')) %>%
  mutate(chromosome_name = factor(chromosome_name, 
                                  levels = paste('chr', c(1:22, 'X'), sep = '') 
                                    )) %>%
  arrange(chromosome_name) %>%
  na.omit()

tabix$start_position <- tabix$start_position 
tabix$end_position <- tabix$end_position 

tabix %>% write.table('immunity_genes/cand_covid_genes.tabix',col.names = F,
                      row.names = F,quote = F,sep='\t')  
