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

process callrate_and_missing {
	input:
	set datasetID,
  file("${datasetID}.bed"),
	file("${datasetID}.bim"),
	file("${datasetID}.fam") from plink_format
	output:
	tuple val(datasetID),
	file("${datasetID}.par.qc.bed"),
	file("${datasetID}.par.qc.bim"),
	file("${datasetID}.par.qc.fam") into geno_mind
	script:
	"""
	plink --bfile ${datasetID} --geno 0.02 --make-bed --out ${datasetID}.par.qc --allow-no-sex
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
	file("${datasetID}.par.qc.fam")  from hwe
	output:
	tuple val(datasetID),
  file("${datasetID}.clean.bed"),
  file("${datasetID}.clean.bim"),
	file("${datasetID}.clean.fam") into clean_dataset
	script:
	"""
	plink --bfile ${datasetID}.par.qc --hwe 1e-6 --make-bed --out ${datasetID}.clean --allow-no-sex
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
  tuple val(datasetID),
  file("${datasetID}.clean.bed"),
  file("${datasetID}.clean.bim"),
  file("${datasetID}.clean.fam"),
  file("${datasetID}.eigenvec") into pca
	script:
	"""
  plink --bfile ${datasetID}.clean --allow-no-sex \\
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
	tuple val(datasetID),
	file("${datasetID}.bgen"),
	file("${datasetID}.bgen.bgi") into bgen
	script:
	"""
  plink2 --bfile ${datasetID}.clean --allow-no-sex \\
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
	tuple val(datasetID),
	file("${datasetID}.clean.bed"),
	file("${datasetID}.clean.bim"),
	file("${datasetID}.clean.fam"),
	file("pheno.txt"),
	file("sample_file.txt")	into saige_plink_input
	script:
	"""
  	Rscript ${baseDir}/bin/saige_phenocovar.R \\
	  ${datasetID}.eigenvec \\
	  ${baseDir}/data/ped.tsv \\
	  ${datasetID}.clean.fam \\
	  ${baseDir}/data/${datasetID}.txt
	"""
}

process step1_fitNULLGLMM {
  conda 'saige.yml'
	input:
	set datasetID,
	file("${datasetID}.clean.bed"),
	file("${datasetID}.clean.bim"),
	file("${datasetID}.clean.fam"),
	file("pheno.txt"),
	file("sample_file.txt")	from saige_plink_input
	output:
	tuple val(datasetID),
	file("${datasetID}_A2.rda"),
	file("${datasetID}_A2.varianceRatio.txt"),
	file("${datasetID}_A2_30markers.SAIGE.results.txt"),
	file("sample_file.txt")	into step1_output
	script:
	"""
  step1_fitNULLGLMM.R    \\
    --plinkFile=${datasetID}.clean  \\
    --phenoFile=pheno.txt \\
    --phenoCol=A2 \\
    --covarColList=Age,Age_sq,Sex,Age_sex,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,PC11,PC12,PC13,PC14,PC15,PC16,PC17,PC18,PC19,PC20 \\
    --sampleIDColinphenoFile=IID \\
    --traitType=binary  \\
    --outputPrefix=${datasetID}_A2 \\
    --nThreads=20	\\
  	--LOCO=FALSE  \\
  	--minMAFforGRM=0.01 \\
    --IsOverwriteVarianceRatioFile=TRUE
	"""
}



bgen.join(step1_output).set{step2_input}

process step2_SPAtests {
  conda 'saige.yml'
  publishDir "${params.output}/${datasetID}"
	input:  
	set datasetID,
	file("${datasetID}.bgen"),
	file("${datasetID}.bgen.bgi"),
	file("${datasetID}.rda"),
	file("${datasetID}.varianceRatio.txt"),
	file("${datasetID}_30markers.SAIGE.results.txt"),
	file("sample_file.txt")	from step2_input
	output:
	tuple val(datasetID),
	file("${datasetID}_A2.SAIGE.bgen.txt"),
	file("${datasetID}_A2.varianceRatio.txt"),
	file("${datasetID}_A2_30markers.SAIGE.results.txt") into output
	script:
	"""
  step2_SPAtests.R    \\
  --bgenFile=${datasetID}.bgen  \\
  --bgenFileIndex=${datasetID}.bgen.bgi \\
  --minMAF=0.0001 \\
  --minMAC=1 \\
  --sampleFile=sample_file.txt \\
  --GMMATmodelFile=${datasetID}.rda \\
  --varianceRatioFile=${datasetID}.varianceRatio.txt \\
  --SAIGEOutputFile=${datasetID}.SAIGE.bgen.txt \\
  --numLinesOutput=2 \\
  --IsOutputNinCaseCtrl=TRUE \\
  --IsOutputAFinCaseCtrl=TRUE \\
  --IsOutputHetHomCountsinCaseCtrl=TRUE \\
  --LOCO=FALSE \\
  --sampleFile_male=${baseDir}/data/males_id.txt \\
  --X_PARregion=10001-2781479,155701383-156030895 \\
  --is_rewrite_XnonPAR_forMales=TRUE
	"""
}


workflow.onComplete {
    println "Pipeline completed at: $workflow.complete"
    println "Execution status: ${ workflow.success ? 'OK' : 'failed' }"
}

workflow.onError {
    println "Oops... Pipeline execution stopped with the following message: ${workflow.errorMessage}"
}
