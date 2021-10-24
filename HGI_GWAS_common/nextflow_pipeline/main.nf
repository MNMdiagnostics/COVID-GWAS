datasets = Channel
                .fromPath(params.input)
                .map { file -> tuple(file.baseName, file) }

process vcf_to_plink {
	input:
	set datasetID, file(datasetFile) from datasets
	output:
	set datasetID,
	file("${datasetID}.bed"),
	file("${datasetID}.bim"),
	file("${datasetID}.fam") into plink_format
	script:
	"""
	plink2 --vcf ${datasetFile} \\
  --vcf-half-call r \\
  --make-bed \\
  --out ${datasetID} \\
  --snps-only
	"""
}

process add_familyID_and_sex {
	input:
	set datasetID,
	file("${datasetID}.bed"),
	file("${datasetID}.bim"),
	file("${datasetID}.fam")	from plink_format
	output:
	set datasetID,
	file("${datasetID}.bed"),
	file("${datasetID}.bim"),
	file("${datasetID}.fam") into new_fam
	script:
	"""
	#!/usr/bin/env Rscript
	suppressMessages(library(tidyverse))

	ped <- read.table('/root/COVID-GWAS/input/ped.tsv',sep='\t',header=T) %>%
	arrange(Individual_ID)

	fam <- read.table("${datasetID}.fam",
	                  col.names = c('FID','IID','PID','MID','Sex','Pheno'),
	                  header=F,
	                  sep='\t') %>%
										arrange(IID)

	fam\$FID <- ped\$Family_ID
	fam\$PID <- ped\$Paternal_ID
	fam\$MID <- ped\$Maternal_ID
	fam\$Sex <- ped\$Sex

	fam %>%
	  mutate(PID = ifelse(PID == '',0,PID),
	         MID = ifelse(MID == '',0,MID)) %>%
					 write.table("${datasetID}.fam",
			 	              quote = F,
			 	              sep='\t',
			 	              col.names = F,
			 	              row.names = F)

	"""
}

// process chrX_PAR {
// 	input:
// 	set datasetID,
// 	file("${datasetID}.bed"),
// 	file("${datasetID}.bim"),
// 	file("${datasetID}.fam")	from new_fam
// 	output:
// 	set datasetID,
// 	file("${datasetID}.par.bed"),
// 	file("${datasetID}.par.bim"),
// 	file("${datasetID}.par.fam") into chrX_PAR
// 	script:
// 	"""
//
//   plink --bfile ${datasetID} --split-x hg38 --make-bed --out ${datasetID}.par
// 	"""
// }

	//plink2 --bfile ${datasetID} --split-par hg38 --make-bed --out ${datasetID}.par

process callrate_and_missing {
	input:
	set datasetID,
  file("${datasetID}.bed"),
	file("${datasetID}.bim"),
	file("${datasetID}.fam") from new_fam
	output:
	set datasetID,
	file("${datasetID}.par.qc.bed"),
	file("${datasetID}.par.qc.bim"),
	file("${datasetID}.par.qc.fam") into geno_mind
	script:
	"""
	plink --bfile ${datasetID} --geno 0.02 --make-bed --out ${datasetID}.par.qc
	"""
}

geno_mind.into{
	hwe;
	maf_filter
}

// process prep_pheno_hwe {
// 	input:
// 	set datasetID,
// 	file("${datasetID}.par.qc.bed"),
// 	file("${datasetID}.par.qc.bim"),
// 	file("${datasetID}.par.qc.fam") from hwe_pheno
// 	output:
//   set datasetID,
//   file("${datasetID}.par.qc.bed"),
//   file("${datasetID}.par.qc.bim"),
//   file("${datasetID}.par.qc.fam"),
//   file("pheno.txt")  into hwe_phenotype
// 	script:
// 	"""
// 	#!/usr/bin/env Rscript
// 	suppressMessages(library(tidyverse))
//
// 	ped <- read.table('/root/COVID-GWAS/input/ped.tsv',sep='\t',header=T) %>%
// 	arrange(Individual_ID)
// 	fam <- read.table("${datasetID}.par.qc.fam",
// 										col.names = c('FID','IID','PID','MID','Sex','Pheno'),
// 										header=T,
// 										sep='\t') %>%
// 										arrange(IID)
//
// 	pheno <- ped %>%
// 	  select(Family_ID,Individual_ID,HGI.phenotype) %>%
// 	  mutate(A2 = ifelse(grepl('A2',HGI.phenotype)==T,2,1),
// 	         B2 = ifelse(grepl('B2',HGI.phenotype)==T,2,1),
// 	         C2 = ifelse(grepl('C2',HGI.phenotype)==T,2,1)) %>%
// 	  select(-HGI.phenotype) %>%
// 	  rename(IID = Individual_ID,
// 			FID = Family_ID) %>%
// 		arrange(IID) %>%
// 		filter(IID %in% fam\$IID)
//
// 	pheno %>% write.table("pheno.txt",
// 	                      col.names = T,
// 	                      row.names=F,
// 	                      quote = F,
// 	                      sep='\t')
// 	"""
// }


// process maf_filter {
// 	input:
// 	set datasetID,
//   file("${datasetID}.par.qc.bed"),
//   file("${datasetID}.par.qc.bim"),
//   file("${datasetID}.par.qc.fam")  from maf_filter
// 	output:
// 	set datasetID,
// 	file("${datasetID}.maf.bed"),
// 	file("${datasetID}.maf.bim"),
// 	file("${datasetID}.maf.fam") into common_variants
// 	script:
// 	"""
// 	plink2 --bfile ${datasetID}.par.qc --maf 0.01 --out ${datasetID}.maf --make-bed
// 	"""
// }

process hwe_filter {
	input:
	set datasetID,
  file("${datasetID}.par.qc.bed"),
	file("${datasetID}.par.qc.bim"),
	file("${datasetID}.par.qc.fam")  from hwe
	output:
	set datasetID,
  file("${datasetID}.clean.bed"),
  file("${datasetID}.clean.bim"),
	file("${datasetID}.clean.fam") into clean_dataset
	script:
	"""
	plink --bfile ${datasetID}.par.qc --hwe 1e-6 --make-bed --out ${datasetID}.clean
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
	file("${datasetID}.clean.fam") from to_pca
	output:
  set datasetID,
  file("${datasetID}.clean.bed"),
  file("${datasetID}.clean.bim"),
  file("${datasetID}.clean.fam"),
  file("${datasetID}.eigenvec") into pca
	script:
	"""
  plink --bfile ${datasetID}.clean \\
  --make-bed \\
  --maf 0.01 \\
  --indep-pairwise 50 5 0.05 \\
  --out ${datasetID}

  plink --bfile ${datasetID}.clean \\
  --extract ${datasetID}.prune.in \\
  --out ${datasetID} \\
  --pca 20
	"""
}

process convert_to_bgen {
	input:
	set datasetID,
  file("${datasetID}.clean.bed"),
  file("${datasetID}.clean.bim"),
	file("${datasetID}.clean.fam") from to_bgen
	output:
	set datasetID,
  file("${datasetID}.bgen"),
  file("${datasetID}.bgen.bgi") into bgen
	script:
	"""
	plink2 --bfile ${datasetID}.clean \\
  --export bgen-1.2 id-delim=' ' bits=8 \\
  --out ${datasetID}
  bgenix -index -g ${datasetID}.bgen \\
  -clobber
	"""
}

process saige_pheno {
	input:
	set datasetID,
  file("${datasetID}.clean.bed"),
  file("${datasetID}.clean.bim"),
  file("${datasetID}.clean.fam"),
  file("${datasetID}.eigenvec") from pca
	output:
  set datasetID,
  file("${datasetID}.clean.bed"),
  file("${datasetID}.clean.bim"),
  file("${datasetID}.clean.fam"),
  file("pheno.txt"),
  file("samples_id.txt"),
  file("males_id.txt")  into saige_plink_input
	script:
	"""
  #!/usr/bin/env Rscript

  suppressMessages(library(tidyverse))

  pca <- read.table("${datasetID}.eigenvec",header=F,sep=' ',
  col.names = c('FID','IID',paste('PC',1:20,sep='')))
  ped <- read.table('/root/COVID-GWAS/input/ped.tsv',sep='\t',header=T)
  fam <- read.table("${datasetID}.clean.fam",
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
    left_join(pca)

  pheno %>% write.table("pheno.txt",
                        col.names = T,
                        row.names=F,
                        quote = F,
                        sep='\t')

  pheno %>%
  select(IID) %>%
  write.table("samples_id.txt",
                        col.names = F,
                        row.names=F,
                        quote = F,
                        sep='\t')

  pheno %>%
  filter(Sex == 2) %>%
  select(IID) %>%
  write.table("males_id.txt",
                        col.names = F,
                        row.names=F,
                        quote = F,
                        sep='\t')
	"""
}

process step1_fitNULLGLMM {
	input:
  set datasetID,
  file("${datasetID}.clean.bed"),
  file("${datasetID}.clean.bim"),
	file("${datasetID}.clean.fam"),
  file("pheno.txt"),
  file("samples_id.txt"),
  file("males_id.txt")  from saige_plink_input
	output:
	set datasetID,
  file("${datasetID}.rda"),
  file("${datasetID}.varianceRatio.txt"),
  file("${datasetID}_30markers.SAIGE.results.txt"),
  file("samples_id.txt"),
  file("males_id.txt") into step1_output
	script:
	"""
  step1_fitNULLGLMM.R     \\
          --plinkFile=${datasetID}.clean  \\
          --phenoFile=pheno.txt \\
          --phenoCol=A2  \\
          --covarColList=Age,Age_sq,Sex,Age_sex,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,PC11,PC12,PC13,PC14,PC15,PC16,PC17,PC18,PC19,PC20 \\
          --sampleIDColinphenoFile=IID \\
          --traitType=binary  \\
          --outputPrefix=${datasetID} \\
          --nThreads=20	\\
  	--LOCO=FALSE  \\
  	--minMAFforGRM=0.01 \\
    --IsOverwriteVarianceRatioFile=TRUE
	"""
}

bgen.join(step1_output).set{step2_input}

process step2_SPAtests {
	input:
  set datasetID,
  file("${datasetID}.bgen"),
  file("${datasetID}.bgen.bgi"),
  file("${datasetID}.rda"),
  file("${datasetID}.varianceRatio.txt"),
  file("${datasetID}_30markers.SAIGE.results.txt"),
  file("samples_id.txt"),
  file("males_id.txt")  from step2_input
	output:
	set datasetID,
  file("${datasetID}.SAIGE.bgen.txt") into step2_output
	script:
	"""
  step2_SPAtests.R    \\
  --bgenFile=${datasetID}.bgen  \\
  --bgenFileIndex=${datasetID}.bgen.bgi \\
  --minMAF=0.0001 \\
  --minMAC=1 \\
  --sampleFile=samples_id.txt \\
  --GMMATmodelFile=${datasetID}.rda \\
  --varianceRatioFile=${datasetID}.varianceRatio.txt \\
  --SAIGEOutputFile=${datasetID}.SAIGE.bgen.txt \\
  --numLinesOutput=2 \\
  --IsOutputNinCaseCtrl=TRUE \\
  --IsOutputAFinCaseCtrl=TRUE \\
  --IsOutputHetHomCountsinCaseCtrl=TRUE \\
  --LOCO=FALSE \\
  --sampleFile_male=males_id.txt \\
  --X_PARregion=10001-2781479,155701383-156030895
	"""
}


workflow.onComplete {
    println "Pipeline completed at: $workflow.complete"
    println "Execution status: ${ workflow.success ? 'OK' : 'failed' }"
}

workflow.onError {
    println "Oops... Pipeline execution stopped with the following message: ${workflow.errorMessage}"
}
