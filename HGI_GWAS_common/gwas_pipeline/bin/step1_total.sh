  #!/usr/bin/env bash
  step1_fitNULLGLMM.R    \
    --plinkFile=$1 \
    --phenoFile=pheno.txt \
    --phenoCol=A2  \
    --covarColList=Age,Age_sq,Sex,Age_sex,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,PC11,PC12,PC13,PC14,PC15,PC16,PC17,PC18,PC19,PC20 \
    --sampleIDColinphenoFile=IID \
    --traitType=binary  \
    --outputPrefix=$2 \
    --nThreads=20	\
  	--LOCO=FALSE  \
  	--minMAFforGRM=0.01 \
    --IsOverwriteVarianceRatioFile=TRUE