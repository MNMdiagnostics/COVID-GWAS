OAS\_panel
================

## 1. Cohort information

![](oas_files/figure-gfm/sample%20info-1.png)<!-- -->

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

![](oas_files/figure-gfm/af%20plot-1.png)<!-- -->

![](oas_files/figure-gfm/OR%20plot-1.png)<!-- -->

| rsid                    | SYMBOL | IMPACT   |    qvalue | case\_frequency | ctrl\_frequency |     OR |
|:------------------------|:-------|:---------|----------:|----------------:|----------------:|-------:|
| rs71086129              | OAS3   | MODIFIER | 0.3138914 |        0.356600 |       0.4255000 | 0.7483 |
| rs1266329093            | OAS3   | MODIFIER | 0.3138914 |        0.356600 |       0.4255000 | 0.7483 |
| rs1356181970            | OAS3   | MODIFIER | 0.3138914 |        0.356600 |       0.4255000 | 0.7483 |
| rs1293763               | OAS2   | MODIFIER | 0.3138914 |        0.278900 |       0.2258000 | 1.3270 |
| rs1293773               | OAS2   | MODIFIER | 0.3138914 |        0.277800 |       0.2278000 | 1.3040 |
| rs138709435             | OAS3   | MODIFIER | 0.3138914 |        0.195800 |       0.1533000 | 1.3440 |
| rs1239627972            | OAS3   | MODIFIER | 0.3138914 |        0.195800 |       0.1533000 | 1.3440 |
| rs192015439             | OAS2   | MODIFIER | 0.3138914 |        0.013160 |       0.0026560 | 5.0070 |
| rs142235676             | OAS2   | MODIFIER | 0.3138914 |        0.010530 |       0.0019920 | 5.3300 |
| rs1175670148            | OAS3   | MODIFIER | 0.3138914 |        0.005263 |       0.0000000 |     NA |
| rs1471309097            | OAS3   | MODIFIER | 0.3138914 |        0.005263 |       0.0000000 |     NA |
| rs117666908             | OAS2   | MODIFIER | 0.3138914 |        0.005263 |       0.0006640 | 7.9630 |
| rs1422561021            | OAS2   | MODIFIER | 0.3138914 |        0.005263 |       0.0006640 | 7.9630 |
| rs547811560             | OAS2   | MODIFIER | 0.3138914 |        0.005263 |       0.0006684 | 7.9100 |
| rs954233109             | OAS2   | MODIFIER | 0.3138914 |        0.002717 |       0.0000000 |     NA |
| rs1279074905            | OAS2   | MODIFIER | 0.3138914 |        0.002646 |       0.0000000 |     NA |
| rs1006109435            | OAS3   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs200770928             | OAS3   | MODERATE | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs369916708             | OAS3   | LOW      | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs199852899             | OAS3   | MODERATE | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs369399935             | OAS3   | MODERATE | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs531171461             | OAS3   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs766946950             | OAS3   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs564112894             | OAS3   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs372420324             | OAS3   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs561845660             | OAS3   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs183209325             | OAS3   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs972834980             | OAS3   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs55688670              | OAS3   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs45607836              | OAS3   | MODERATE | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs1473483299            | OAS3   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs544937161             | OAS3   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs751282870,COSM5947907 | OAS3   | MODERATE | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs140936085             | OAS3   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs143756674             | OAS3   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs1340230424            | OAS3   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs45537233              | OAS3   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs1340565807            | OAS3   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs978314828             | OAS2   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs186279134             | OAS2   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs1263147886            | OAS2   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs907176469             | OAS2   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs1050006806            | OAS2   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs997130219             | OAS2   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs554009345             | OAS2   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs1035737227            | OAS2   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs557146377             | OAS2   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs974267060             | OAS2   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs756056888             | OAS2   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs916820130             | OAS2   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs1409357085            | OAS2   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs894207510             | OAS2   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs184657732             | OAS2   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs1260313436            | OAS2   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs1375483517            | OAS2   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs574491548             | OAS2   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs964196061             | OAS2   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs1161795201            | OAS2   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs1456344855            | OAS2   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |
| rs1229391997            | OAS2   | MODIFIER | 0.3138914 |        0.002632 |       0.0000000 |     NA |

Variants with q-value &lt; 0.32
