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

   zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}.vcf.gz | awk '{if ($1~/^#/) print; else exit;}' > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}.header


   tabix -r ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}.header ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.vcf.gz > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.vcf.gz
   tabix -r ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}.header ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.vcf.gz > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.with_header.vcf.gz

   tabix -r ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}.header ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.vcf.gz > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.with_header.vcf.gz
   tabix -r ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}.header ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.vcf.gz > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.with_header.vcf.gz

   tabix -p vcf -f ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.vcf.gz
   tabix -p vcf -f ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.with_header.vcf.gz
   tabix -p vcf -f ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.with_header.vcf.gz
   tabix -p vcf -f ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.with_header.vcf.gz

done
