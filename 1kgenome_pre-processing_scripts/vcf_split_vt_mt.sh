#!/bin/bash

while getopts dn:g:l:p: option
do
   case "$option" in
      d) DODEBUG=true;;      # option -d to print out commands
      g) GROUP="$OPTARG";;
      l) CHR="$OPTARG";;
      p) PREFIX="$OPTARG";;
   esac
done
zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP.vcf.gz | awk '{if (length($4) !=1 || length($5)!=1 || $8~/MULTI_ALLELIC/) print  > "'${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_multiallelic.vcf'"  ; else  print > "'${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.vcf'" }'
zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL.vcf.gz | awk '{if ($8~/MULTI_ALLELIC/) print  > "'${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_multiallelic.vcf'" ; else  print  > "'${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_biallelic.vcf'" }'
#nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view ${PREFIX}/${CHR}/${CHR}_${GROUP}.vcf.gz | grep "VT=SV" | gzip -c > ${PREFIX}/${CHR}/${CHR}_${GROUP}_SV.vcf.gz &
#nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view ${PREFIX}/${CHR}/${CHR}_${GROUP}.vcf.gz | grep "VT=CNV" | gzip -c > ${PREFIX}/${CHR}/${CHR}_${GROUP}_CNV.vcf.gz &
bgzip -c ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_multiallelic.vcf > ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_multiallelic.vcf.gz
bgzip -c ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.vcf > ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.vcf.gz

bgzip -c ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_multiallelic.vcf > ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_multiallelic.vcf.gz
bgzip -c ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_biallelic.vcf >  ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_biallelic.vcf.gz

rm -rf ${PREFIX}/${CHR}/${CHR}_${GROUP}_*.vcf


tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_multiallelic.vcf.gz
tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.vcf.gz
tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_multiallelic.vcf.gz
tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_biallelic.vcf.gz
