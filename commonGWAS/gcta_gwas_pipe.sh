#!/bin/bash
input=$1
prefix=$(basename $1)
# 
# ### Step 1: segment based LD score
# echo 'Step 1: segment based LD score'
# /root/GCTA/gcta64 --bfile $input --ld-score-region 200  --out ../input/GCTA/$prefix --thread-num 100
# 
# 
# ### Step 2 : stratify the SNPs by LD scores of individual SNPs in R
# echo "Step 2 : stratify the SNPs by LD scores of individual SNPs in R"
# Rscript stratifyLD.R ../input/GCTA/$prefix.score.ld
# 
# ### Step 3: making GRMs using SNPs stratified into different groups
# echo "Step 3: making GRMs using SNPs stratified into different groups"
# /root/GCTA/gcta64 --bfile $input --extract ../input/GCTA/snp_group1.txt --make-grm  \
# --out ../input/GCTA/$prefix.group1 --thread-num 100
# echo ../input/GCTA/$prefix.group1 > ../input/GCTA/multi_GRMs.txt
# 
# /root/GCTA/gcta64 --bfile $input --extract ../input/GCTA/snp_group2.txt --make-grm \
# --out ../input/GCTA/$prefix.group2 --thread-num 100
# echo ../input/GCTA/$prefix.group2 >> ../input/GCTA/multi_GRMs.txt
# 
# /root/GCTA/gcta64 --bfile $input --extract ../input/GCTA/snp_group3.txt --make-grm \
# --out ../input/GCTA/$prefix.group3 --thread-num 100
# echo ../input/GCTA/$prefix.group3 >> ../input/GCTA/multi_GRMs.txt
# 
# /root/GCTA/gcta64 --bfile $input --extract ../input/GCTA/snp_group4.txt --make-grm \
# --out ../input/GCTA/$prefix.group4 --thread-num 100
# echo ../input/GCTA/$prefix.group4 >> ../input/GCTA/multi_GRMs.txt
# 
# ### Step 4: REML analysis with multiple GRMs
# echo 'Step 4: REML analysis with multiple GRMs for SEVERE and RESIST phenotypes'
# 
# /root/GCTA/gcta64 --reml --mgrm ../input/GCTA/multi_GRMs.txt --mpheno 1 --pheno ../input/GCTA/pheno_gcta.txt \
# --covar ../input/GCTA/sex.covar --qcovar ../input/GCTA/age.qcovar --out ../input/GCTA/$prefix.severe --thread-num 100 \
# --reml-no-constrain 
# 
# /root/GCTA/gcta64 --reml --mgrm ../input/GCTA/multi_GRMs.txt --mpheno 2 --pheno ../input/GCTA/pheno_gcta.txt \
# --covar ../input/GCTA/sex.covar --qcovar ../input/GCTA/age.qcovar --out ../input/GCTA/$prefix.resist --thread-num 100 \


/root/GCTA/gcta64 --mlma --bfile $input --mgrm ../input/GCTA/multi_GRMs.txt \
--mpheno 1 --pheno ../input/GCTA/pheno_gcta.txt --out ../input/GCTA/$prefix.severe \
--thread-num 100 --reml-no-constrain 

/root/GCTA/gcta64 --mlma --bfile $input --mgrm ../input/GCTA/multi_GRMs.txt \
--mpheno 2 --pheno ../input/GCTA/pheno_gcta.txt --out ../input/GCTA/$prefix.resist \
--thread-num 100 --reml-no-constrain 



