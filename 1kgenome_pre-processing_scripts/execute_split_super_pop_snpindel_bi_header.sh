#!/bin/bash

while getopts dn:p:l: option
do
   case "$option" in
      d) DODEBUG=true;;      # option -d to print out commands
      p) PREFIX="$OPTARG";;
      l) CHR="$OPTARG";;
   esac
done

rm -rf ${PREFIX}/${CHR}/*.header
rm -rf ${PREFIX}/${CHR}/*biallelic.with_header.vcf.gz
rm -rf ${PREFIX}/${CHR}/*multiallelic.with_header.vcf.gz

for GROUP in EUR AMR EAS AFR SAS
do

   zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}.vcf.gz | awk '{if ($1~/^#/) print; else exit;}' > ${PREFIX}/${CHR}/${CHR}_${GROUP}.header


   tabix -r ${PREFIX}/${CHR}/${CHR}_${GROUP}.header ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.vcf.gz > ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.with_header.vcf.gz
   tabix -r ${PREFIX}/${CHR}/${CHR}_${GROUP}.header ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_biallelic.vcf.gz > ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_biallelic.with_header.vcf.gz

   tabix -r ${PREFIX}/${CHR}/${CHR}_${GROUP}.header ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_multiallelic.vcf.gz > ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_multiallelic.with_header.vcf.gz
   tabix -r ${PREFIX}/${CHR}/${CHR}_${GROUP}.header ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_multiallelic.vcf.gz > ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_multiallelic.with_header.vcf.gz

   tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.with_header.vcf.gz
   tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_multiallelic.with_header.vcf.gz
   tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_biallelic.with_header.vcf.gz
   tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_multiallelic.with_header.vcf.gz

done
