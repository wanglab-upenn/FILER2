#!/bin/bash

while getopts dn:i:p:l: option
do
   case "$option" in
      d) DODEBUG=true;;      # option -d to print out commands
      i) VCF="$OPTARG";;
      p) PREFIX="$OPTARG";;
      l) CHR="$OPTARG";;
   esac
done

#rm -rf ${PREFIX}/${CHR}/pop/*
#rm -rf ${PREFIX}/${CHR}/pop/*.gz ${PREFIX}/${CHR}/pop/newstatus.txt ${PREFIX}/${CHR}/pop/status.txt
#rm -rf ${PREFIX}/${CHR}/pop/pop*
#rm -rf ${PREFIX}/${CHR}/pop/*.gz.tbi
#rm -rf ${PREFIX}/${CHR}/pop/*.header



for GROUP in ACB ASW
do
   grep ${GROUP} /mnt/data/hannah/1kg_phase3/raw_hg19/integrated_call_samples_v3.20130502.ALL.panel | awk '{print $1}' > ${PREFIX}/${CHR}/pop/${GROUP}.txt
done

#find ${PREFIX}/${CHR}/pop -empty  -delete

for GROUP in ACB ASW
do

   echo "/mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view --force-samples --samples-file ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}.txt --output-file ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}.vcf.gz  --output-type z ${VCF} "
   /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view --force-samples --samples-file ${PREFIX}/${CHR}/pop/${GROUP}.txt --output-file ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}.vcf.gz  --output-type z ${VCF}

done




