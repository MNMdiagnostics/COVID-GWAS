input=$1
temp_input=${input%%.*}
output_temp=$2
pheno=$3
pheno_name=${pheno%%.*}

#plink --vcf $input --maf 0.01 \
#--geno 0.1 --allow-no-sex --vcf-half-call r \
#--make-bed --out ${temp_input}_maf0.01 --const-fid 0 \
#--keep to_include \
#--threads 50

plink --bfile ${temp_input}_maf0.01 --make-bed --allow-no-sex \
--indep-pairwise 50 5 0.05 \
--keep to_include \
--out ${temp_input}

plink --bfile ${temp_input}_maf0.01 --make-bed --allow-no-sex \
--extract ${temp_input}.prune.in --out ${temp_input}_pruned

mkdir -p output/${output_temp}/
  
plink --bfile ${temp_input}_pruned --logistic hide-covar --ci 0.95 --adjust qq-plot --covar plink_covar.txt \
--out output/${output_temp}/${output_temp}_${pheno_name}  --pheno $pheno \
--allow-no-sex \
--keep to_include


