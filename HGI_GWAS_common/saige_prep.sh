input_vcf=/output_data/MS_gwas_data/cardiac/cardiac_fullset_sorted.vcf.gz
outname=${input_vcf%.vcf.gz}
outname=$(basename $outname)

mkdir -p /output_data/MS_gwas_data/HGI_SAGE/input/$outname

plink --vcf $input_vcf --allow-no-sex --const-fid 0 --vcf-half-call r --make-bed --out /output_data/MS_gwas_data/HGI_SAGE/input/${outname}/${outname} &

/root/qctool/qctool_v2.0.6-Ubuntu16.04-x86_64/qctool -g $input_vcf \
-og /output_data/MS_gwas_data/HGI_SAGE/input/${outname}/${outname}.bgen -vcf-genotype-field GT -ofiletype bgen_v1.2 -bgen-bits 8 &

wait

bgenix -index -g /output_data/MS_gwas_data/HGI_SAGE/input/${outname}/${outname}.bgen
rm /output_data/MS_gwas_data/HGI_SAGE/input/${outname}/${outname}.nosex
