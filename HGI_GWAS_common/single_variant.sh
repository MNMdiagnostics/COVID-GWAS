input_plink=/output_data/MS_gwas_data/HGI_SAGE/input/cardiac_fullset_sorted/cardiac_fullset_sorted
input_vcf=${input_plink}.vcf.gz
pheno=sage_severe_full.txt
output_file=$(basename ${input_plink})
mkdir -p /output_data/MS_gwas_data/HGI_SAGE/output/$output_file

enable_LOCO=FALSE

Rscript scripts/step1_fitNULLGLMM.R     \
        --plinkFile=$input_plink \
        --phenoFile=$pheno \
        --phenoCol=A2 \
        --covarColList=Age,Age_sq,Sex,Age_sex \
        --sampleIDColinphenoFile=IID \
        --traitType=binary        \
        --outputPrefix=/output_data/MS_gwas_data/HGI_SAGE/output/${output_file}/${output_file} \
        --nThreads=20	\
	--LOCO=$enable_LOCO	\
	--minMAFforGRM=0.01 \
  --IsOverwriteVarianceRatioFile=TRUE

Rscript scripts/step2_SPAtests.R \
        --bgenFile=${input_plink}.bgen \
        --bgenFileIndex=${input_plink}.bgen.bgi \
        --minMAF=0.0001 \
        --minMAC=1 \
        --sampleFile=sampleid.txt \
        --GMMATmodelFile=/output_data/MS_gwas_data/HGI_SAGE/output/${output_file}/${output_file}.rda \
        --varianceRatioFile=/output_data/MS_gwas_data/HGI_SAGE/output/${output_file}/${output_file}.varianceRatio.txt \
        --SAIGEOutputFile=/output_data/MS_gwas_data/HGI_SAGE/output/${output_file}/${output_file}.SAIGE.bgen.txt \
        --numLinesOutput=2 \
	  --IsOutputNinCaseCtrl=TRUE \
              --IsOutputHetHomCountsinCaseCtrl=TRUE \
        	  --IsOutputAFinCaseCtrl=TRUE \
            --LOCO=$enable_LOCO
