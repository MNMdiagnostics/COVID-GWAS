ensembl\_cardiac\_diseases\_panel\_20200715
================

Results on 1076 unrelated individuals and 8,129 SNPs

    ## Joining, by = "SNP"
    ## Joining, by = "SNP"

    ## `geom_smooth()` using formula 'y ~ x'

![](logistic_gwas_files/figure-gfm/loading_data-1.png)<!-- -->

![](logistic_gwas_files/figure-gfm/q_manhattan_plot-1.png)<!-- -->

![](logistic_gwas_files/figure-gfm/OR%20plot-1.png)<!-- -->

### Significant variants

| SNP                  | SYMBOL | Consequence     |   Pvalue |     OR |
|:---------------------|:-------|:----------------|---------:|-------:|
| chr2\_26242159\_G\_C | HADHA  | intron\_variant | 7.50e-06 | 0.5781 |
| chr2\_26258591\_G\_A | HADHB  | intron\_variant | 1.19e-05 | 0.5869 |

### Variants in high LD with significant variants

    ## Joining, by = "SNP"

| SNP                     | Gene            | SYMBOL | IMPACT   | Consequence         |
|:------------------------|:----------------|:-------|:---------|:--------------------|
| chr2\_26232259\_G\_A    | ENSG00000084754 | HADHA  | LOW      | synonymous\_variant |
| chr2\_26254257\_G\_GACT | ENSG00000138029 | HADHB  | MODERATE | inframe\_insertion  |
