// datasets = Channel
//                 .fromPath(params.input)
//                 .map { file -> tuple(file.baseName, file) }

Channel
	.fromPath("${params.input}")
	.splitCsv(header:["datasetID","vcf"], sep:',')
	.map { row -> [row.datasetID, file(row.vcf, checkIfExists: true)] }
	.set { ch_input}

process vcf_to_plink {
    tag "$datasetID"
	input:
	set datasetID, file(datasetFile) from ch_input
	output:
	tuple val(datasetID),
	file("${datasetID}.bed"),
	file("${datasetID}.bim"),
	file("${datasetID}.fam") into plink_format
	script:
	"""
    plink2 --vcf ${datasetFile} \\
    --vcf-half-call r \\
    --make-bed \\
    --out ${datasetID} \\
    --snps-only \\
    --keep ${baseDir}/data/${datasetID}.txt 
	"""
}



process fam_modify {
  tag "$datasetID"
	input:
	set datasetID, file(datasetFile) from plink_format
	output:
	tuple val(datasetID),
	file("${datasetID}.bed"),
	file("${datasetID}.bim"),
	file("${datasetID}.fam"),
    file('hgi_saige_pheno.txt') into fam
	script:
	"""
    #!/usr/bin/env Rscript
	suppressMessages(library(tidyverse))

    ped <- read.table('data/ped.tsv',sep='\t',header=T) %>% 
    arrange(Individual_ID) 
    fam <- read.table(${datasetID}.fam"),
    col.names = c('FID','IID','PID','MID','Sex','Pheno'),
    header=F,
    sep='\t') %>% arrange(IID)

    fam\$Sex <- ped\$Sex
    fam\$FID <- ped\$Family_ID
    fam\$PID <- ped\$Paternal_ID
    fam\$MID <- ped\$Maternal_ID

    fam <- fam %>%
    mutate(PID = ifelse(PID == '',0,PID),
            MID = ifelse(MID == '',0,MID))

    fam\$Pheno <- pheno\$A2

    fam <- fam %>% mutate(Pheno = ifelse(Pheno == 0,1,2)) %>% na.omit()

    fam%>%
    write.table(file("${datasetID}.fam"),
                quote = F,
                sep='\t',
                col.names = F,
                row.names = F)

    pheno <- ped %>%
    select(Family_ID,Individual_ID,HGI.phenotype) %>%
    mutate(A2 = ifelse(grepl('A2',HGI.phenotype)==T,2,1)
    rename(FID = Family_ID,IID = Individual_ID) %>% arrange(IID)

    pheno %>% write.table('hgi_saige_pheno.txt',
                        col.names = T,
                        row.names=F,
                        quote = F,
                        sep='\t')

	"""
}

process callrate_and_missing {
	input:
	set datasetID,
    file("${datasetID}.bed"),
	file("${datasetID}.bim"),
	file("${datasetID}.fam"),
    file('hgi_saige_pheno.txt') from fam
	output:
	tuple val(datasetID),
	file("${datasetID}.par.qc.bed"),
	file("${datasetID}.par.qc.bim"),
	file("${datasetID}.par.qc.fam"),
    file('hgi_saige_pheno.txt') into geno_mind
	script:
	"""
	plink2 --bfile ${datasetID} \\
    --geno 0.02 \\
    --make-bed \\
    --out ${datasetID}.par.qc \\
    --pheno hgi_saige_pheno.txt
	"""
}

geno_mind.into{
	hwe;
	maf_filter
}

process hwe_filter {
	input:
	set datasetID,
  file("${datasetID}.par.qc.bed"),
	file("${datasetID}.par.qc.bim"),
	file("${datasetID}.par.qc.fam"),
    file('hgi_saige_pheno.txt')  from hwe
	output:
	tuple val(datasetID),
    file("${datasetID}.clean.bed"),
    file("${datasetID}.clean.bim"),
	file("${datasetID}.clean.fam"),
    file('hgi_saige_pheno.txt') into clean_dataset
	script:
	"""
	plink2 --bfile ${datasetID}.par.qc \\
    --maf 0.01 \\
    --hwe 1e-6 \\
    --make-bed \\
    --out ${datasetID}.clean \\
    --pheno hgi_saige_pheno.txt
	"""
}

clean_dataset.into{
	to_pca;
	to_bgen;
  step1
}

process PCA {
	input:
  set datasetID,
    file("${datasetID}.clean.bed"),
    file("${datasetID}.clean.bim"),
	file("${datasetID}.clean.fam"),
    file('hgi_saige_pheno.txt') from to_pca
	output:
    tuple val(datasetID),
    file("${datasetID}.clean.bed"),
    file("${datasetID}.clean.bim"),
    file("${datasetID}.clean.fam"),
    file("${datasetID}.eigenvec"),
    file('hgi_saige_pheno.txt') into pca
	script:
	"""
    plink2 --bfile ${datasetID}.clean --allow-no-sex \\
    --make-bed \\
    --indep-pairwise 50 5 0.05 \\
    --out ${datasetID} \\
    --pheno hgi_saige_pheno.txt

    plink2 --bfile ${datasetID}.clean \\
    --extract ${datasetID}.prune.in \\
    --out ${datasetID} \\
    --pca 20 \\
    --pheno hgi_saige_pheno.txt
	"""
}


process covars {
	input:
	set datasetID,
	file("${datasetID}.clean.bed"),
	file("${datasetID}.clean.bim"),
	file("${datasetID}.clean.fam"),
	file("${datasetID}.eigenvec"),
    file("data/ped.tsv.txt"),
    file('hgi_saige_pheno.txt') from pca
	output:
	tuple val(datasetID),
	file("${datasetID}.clean.bed"),
	file("${datasetID}.clean.bim"),
	file("${datasetID}.clean.fam"),
	file('covars.txt'),
    file('hgi_saige_pheno.txt') into covars_plink
	script:
	"""
    #!/usr/bin/env Rscript
	suppressMessages(library(tidyverse))

    ped <- read.table('data/ped.tsv',sep='\t',header=T) %>% 
    select(Individual_ID,Age) %>%
    rename(IID = Individual_ID)

    fam <- read.table(file("${datasetID}.clean.fam"), sep='\t',header=T)

    pca <- read.table(file("${datasetID}.eigenvec"),sep='\t', header=T) %>% select(-FID)

    covars <- fam %>% 
    select(FID,IID,Sex) %>%
    left_join(ped) %>% 
    left_join(pca)

    covars %>% write.table('covars.txt',
                        col.names = T,
                        row.names=F,
                        quote = F,
                        sep='\t')
  	
	"""
}

process logistic_regression {
    publishDir "${params.output}/A2"
	input:
	set datasetID,
	file("${datasetID}.clean.bed"),
	file("${datasetID}.clean.bim"),
	file("${datasetID}.clean.fam"),
	file('covars.txt'),
    file('hgi_saige_pheno.txt') from covars_plink
	output:
	tuple val(datasetID),
    file('*')
	script:
	"""
    plink2 --bfile file(${datasetID}.clean) \\
    --logistic hide-covar \\
    --ci 0.95 \\
    --adjust qq-plot \\
    --covar covars.txt \\
    --out POLGENOM.Sypniewski.ANA2.1.ALL.EUR.n_cases.n_controls.PLINK2.20211028  \\
    --pheno hgi_saige_pheno.txt
	"""
}

workflow.onComplete {
    println "Pipeline completed at: $workflow.complete"
    println "Execution status: ${ workflow.success ? 'OK' : 'failed' }"
}

workflow.onError {
    println "Oops... Pipeline execution stopped with the following message: ${workflow.errorMessage}"
}
