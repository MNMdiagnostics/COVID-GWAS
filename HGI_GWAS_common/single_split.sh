#!/bin/bash

input=/mnt/vault1/mnmorigin_pipeline_out/multisample_20210716.dv.bcfnorm.filt.vcf.gz
output=/output_data/MS_gwas_data/HGI_SAGE/input/preimputation
chr=$1

tabix $input $chr -h | bgzip -c > ${output}/${chr}.vcf.gz
bcftools view -S ^imputation_excluded.txt ${output}/${chr}.vcf.gz -Ob | \
bcftools sort -Oz -o ${output}/${chr}.sorted.vcf.gz
rm ${output}/${chr}.vcf.gz
