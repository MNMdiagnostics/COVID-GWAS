ensembl\_cardiac\_diseases\_panel\_20200715
================

## 1. Cohort information

![](cardiac_panel_files/figure-gfm/sample%20info-1.png)<!-- -->

Control label include mild benign and resistant response to COVID-19
infection

<!-- ```{r PCA info, echo=FALSE} -->
<!-- pca <- read.table('output/cardiac.eigenvec') -->
<!-- pca_pheno <- pheno %>% select(Individual_ID,Covid_severity) %>% left_join(pca,by = c('Individual_ID'='V2')) -->
<!-- ``` -->
## 2. Results

Association study was performed by comparison of allele counts in cases
and controls with Chi-square test. Significance of variants is expressed
in form of q-values which are FDR adjusted p-values.

![](cardiac_panel_files/figure-gfm/af%20plot-1.png)<!-- -->

| rsid         | SYMBOL |    qvalue | case\_frequency | ctrl\_frequency | minor\_allele\_OR |
|:-------------|:-------|----------:|----------------:|----------------:|------------------:|
| rs12713870   | APOB   | 0.0233792 |         0.05000 |        0.009960 |            5.2320 |
| rs558651847  | NEBL   | 0.0715223 |         0.01842 |        0.000664 |           28.2400 |
| rs779637473  | DMD    | 0.0715223 |         0.01842 |        0.000664 |           28.2400 |
| rs530902318  | VCL    | 0.0774518 |         0.02895 |        0.003984 |            7.4530 |
| rs76973499   | DMD    | 0.0774518 |         0.44470 |        0.318100 |            1.7170 |
| rs200184156  | DMD    | 0.0774518 |         0.06053 |        0.017930 |            3.5290 |
| rs184864400  | KCNAB2 | 0.0788635 |         0.22270 |        0.378800 |            0.4698 |
| rs532313826  | RYR2   | 0.0788635 |         0.01579 |        0.000664 |           24.1400 |
| rs115959384  | RYR2   | 0.0788635 |         0.01579 |        0.000664 |           24.1400 |
| rs12713871   | APOB   | 0.0788635 |         0.02895 |        0.004648 |            6.3840 |
| rs56218721   | HADHA  | 0.0788635 |         0.37110 |        0.494700 |            0.6026 |
| rs35488195   | HADHB  | 0.0788635 |         0.38680 |        0.514600 |            0.5951 |
| rs139861367  | ALMS1  | 0.0788635 |         0.01579 |        0.000664 |           24.1400 |
| rs572464791  | PPA2   | 0.0788635 |         0.01913 |        0.001381 |           14.1000 |
| rs77446255   | TRDN   | 0.0788635 |         0.04211 |        0.009960 |            4.3690 |
| rs200699818  | VCL    | 0.0788635 |         0.02895 |        0.004648 |            6.3840 |
| rs547179130  | VCL    | 0.0788635 |         0.02895 |        0.004648 |            6.3840 |
| rs557763938  | VCL    | 0.0788635 |         0.02895 |        0.004648 |            6.3840 |
| rs188796749  | SMAD9  | 0.0788635 |         0.03684 |        0.007968 |            4.7620 |
| rs542395521  | DMD    | 0.0788635 |         0.33680 |        0.229100 |            1.7090 |
| rs78095294   | DMD    | 0.0788635 |         0.12890 |        0.234400 |            0.4836 |
| rs2405689    | DMD    | 0.0788635 |         0.17630 |        0.289200 |            0.5260 |
| rs1002387792 | DMD    | 0.0788635 |         0.01579 |        0.000664 |           24.1400 |
| rs1298536274 | KCNAB2 | 0.0819746 |         0.08915 |        0.204500 |            0.3807 |
| rs1298536274 | KCNAB2 | 0.0819746 |         0.08915 |        0.204500 |            0.3807 |
| rs200643126  | PRDM16 | 0.0953094 |         0.03158 |        0.005976 |            5.4240 |

Variants with q-value &lt; 0.1

![](cardiac_panel_files/figure-gfm/OR%20plot-1.png)<!-- -->
