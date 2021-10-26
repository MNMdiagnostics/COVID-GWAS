  #!/usr/bin/env bash
  step2_SPAtests.R    \
  --bgenFile=$1.bgen  \
  --bgenFileIndex=$1.bgen.bgi \
  --minMAF=0.0001 \
  --minMAC=1 \
  --sampleFile=$2 \
  --GMMATmodelFile=$1.rda \
  --varianceRatioFile=$1.varianceRatio.txt \
  --SAIGEOutputFile=$1.SAIGE.bgen.txt \
  --numLinesOutput=2 \
  --IsOutputNinCaseCtrl=TRUE \
  --IsOutputAFinCaseCtrl=TRUE \
  --IsOutputHetHomCountsinCaseCtrl=TRUE \
  --LOCO=FALSE \
  --sampleFile_male=$3 \
  --X_PARregion=10001-2781479,155701383-156030895 \
  --is_rewrite_XnonPAR_forMales=TRUE