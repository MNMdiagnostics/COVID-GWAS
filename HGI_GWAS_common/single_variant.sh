input_plink=/output_data/MS_gwas_data/HGI_SAGE/input/cardiac_fullset_sorted/cardiac_fullset_sorted
input_vcf=${input_plink}.vcf.gz
pheno=hgi_saige_pheno.txt
output_file=$(basename ${input_plink})
mkdir -p /output_data/MS_gwas_data/HGI_SAGE/output/$output_file

cov_list=$(echo Age,Age_sq,Sex,Age_sex)
pheno_col=A2

enable_LOCO=FALSE
#
# Rscript scripts/step1_fitNULLGLMM.R     \
#         --plinkFile=$input_plink \
#         --phenoFile=$pheno \
#         --phenoCol=$pheno_col \
#         --covarColList=$cov_list \
#         --sampleIDColinphenoFile=IID \
#         --traitType=binary        \
#         --outputPrefix=/output_data/MS_gwas_data/HGI_SAGE/output/${output_file}/${output_file} \
#         --nThreads=20	\
# 	--LOCO=$enable_LOCO	\
# 	--minMAFforGRM=0.01 \
#   --IsOverwriteVarianceRatioFile=TRUE
#
# Rscript scripts/step2_SPAtests.R \
#         --bgenFile=${input_plink}.bgen \
#         --bgenFileIndex=${input_plink}.bgen.bgi \
#         --minMAF=0.0001 \
#         --minMAC=1 \
#         --sampleFile=sampleid.txt \
#         --chr=chr1 \
#         --GMMATmodelFile=/output_data/MS_gwas_data/HGI_SAGE/output/${output_file}/${output_file}.rda \
#         --varianceRatioFile=/output_data/MS_gwas_data/HGI_SAGE/output/${output_file}/${output_file}.varianceRatio.txt \
#         --SAIGEOutputFile=/output_data/MS_gwas_data/HGI_SAGE/output/${output_file}/${output_file}.SAIGE.bgen.txt \
#         --numLinesOutput=2 \
# 	      --IsOutputNinCaseCtrl=TRUE \
#         --IsOutputHetHomCountsinCaseCtrl=TRUE \
#     	  --IsOutputAFinCaseCtrl=TRUE \
#         --LOCO=$enable_LOCO
#
# Rscript scripts/createSparseGRM.R \
#         --plinkFile=$input_plink \
#       	--nThreads=4  \
#       	--outputPrefix=/output_data/MS_gwas_data/HGI_SAGE/output/${output_file}/${output_file} 	\
#       	--numRandomMarkerforSparseKin=2000	\
#       	--relatednessCutoff=0.125

Rscript scripts/step1_fitNULLGLMM.R \
        --plinkFile=$input_plink \
        --phenoFile=$pheno \
        --phenoCol=$pheno_col \
        --covarColList=$cov_list \
        --sampleIDColinphenoFile=IID \
        --traitType=binary       \
        --invNormalize=TRUE     \
        --outputPrefix=/output_data/MS_gwas_data/HGI_SAGE/output/${output_file}/${output_file} \
        --outputPrefix_varRatio=/output_data/MS_gwas_data/HGI_SAGE/output/${output_file}/${output_file}.varianceRatio.txt \
        --sparseGRMFile=/output_data/MS_gwas_data/HGI_SAGE/output/${output_file}/${output_file}_relatednessCutoff_0.125_2000_randomMarkersUsed.sparseGRM.mtx \
        --sparseGRMSampleIDFile=/output_data/MS_gwas_data/HGI_SAGE/output/${output_file}/${output_file}_relatednessCutoff_0.125_2000_randomMarkersUsed.sparseGRM.mtx.sampleIDs.txt \
        --nThreads=4 \
      	--LOCO=FALSE    \
      	--skipModelFitting=TRUE \
      	--IsSparseKin=TRUE      \
      	--isCateVarianceRatio=TRUE \
        --IsOverwriteVarianceRatioFile=TRUE


Rscript step2_SPAtests.R \
        --bgenFile=${input_plink}.bgen \
        --bgenFileIndex=${input_plink}.bgen.bgi \
        --chrom=chr1 \
        --minMAF=0 \
        --minMAC=0.5 \
        --maxMAFforGroupTest=0.01       \
        --sampleFile=./input/samplelist.txt \
        --GMMATmodelFile=./output/example_binary.rda \
        --varianceRatioFile=./output/example_binary_cate_v2.varianceRatio.txt \
        --SAIGEOutputFile=./output/example_binary.SAIGE.gene.txt \
       	--numLinesOutput=1 \
        --groupFile=./input/groupFile_geneBasedtest.txt    \
        --sparseSigmaFile=./output/example_binary_cate_v2.varianceRatio.txt_relatednessCutoff_0.125.sparseSigma.mtx       \
       	--IsOutputAFinCaseCtrl=TRUE     \
        --IsSingleVarinGroupTest=TRUE   \
        --IsOutputPvalueNAinGroupTestforBinary=TRUE     \
        --IsAccountforCasecontrolImbalanceinGroupTest=TRUE
