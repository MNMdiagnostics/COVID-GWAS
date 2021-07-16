library(tidyverse)
library(data.table)
library(qvalue)

gwas <- fread('../input/GCTA/multisample_20210519.severe.mlma',header = T)
q <- qvalue(gwas$p)
gwas <- gwas %>% mutate(q = q$qvalues)

gwas$Chr_col <- NA
gwas$Chr_col <- ifelse(gwas$Chr %% 2 == 0, 'even','odd')
gwas$Chr_col <- ifelse(gwas$q < 0.2, 's',gwas$Chr_col)
Chr.group <- c(even = '#27384A',odd = '#48C095',s='#BC0020')
gwas %>% 
  filter(is.na(P) == F) %>%
  ggplot(aes(x=Chr,y=-log10(p))) +
  geom_jitter(aes(col=Chr_col)) +
  scale_color_manual(values = Chr.group) +
  theme_classic() +
  theme(legend.position = 'none') +
  scale_x_continuous(labels = c(1:22),breaks = 1:22) +
  xlab('Chromosomes')