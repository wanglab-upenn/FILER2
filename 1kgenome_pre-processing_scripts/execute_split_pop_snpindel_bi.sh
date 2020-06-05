#!/bin/bash

while getopts dn:p:l: option
do
   case "$option" in
      d) DODEBUG=true;;      # option -d to print out commands
      p) PREFIX="$OPTARG";;
      l) CHR="$OPTARG";;
   esac
done


for GROUP in ACB ASW BEB CDX CEU CHB CHS CLM ESN FIN GBR GIH GWD IBS ITU JPT KHV LWK MSL MXL PEL PJL PUR STU TSI YRI
do
   zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP.vcf.gz | awk '{if (length($4) !=1 || length($5)!=1 || $8~/MULTI_ALLELIC/) print  > "'${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.vcf'"  ; else  print > "'${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.vcf'" }'
   zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL.vcf.gz | awk '{if ($8~/MULTI_ALLELIC/) print  > "'${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.vcf'" ; else  print  > "'${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.vcf'" }'


   bgzip -c ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.vcf > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.vcf.gz
   bgzip -c ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.vcf > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.vcf.gz

   bgzip -c ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.vcf > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.vcf.gz
   bgzip -c ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.vcf >  ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.vcf.gz

   rm -rf ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_*.vcf


   tabix -p vcf -f ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.vcf.gz
   tabix -p vcf -f ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.vcf.gz
   tabix -p vcf -f ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.vcf.gz
   tabix -p vcf -f ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.vcf.gz
done
