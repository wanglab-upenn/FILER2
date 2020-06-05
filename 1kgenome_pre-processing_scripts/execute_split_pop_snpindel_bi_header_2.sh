#!/bin/bash

while getopts dn:p:l: option
do
   case "$option" in
      d) DODEBUG=true;;      # option -d to print out commands
      p) PREFIX="$OPTARG";;
      l) CHR="$OPTARG";;
   esac
done


for GROUP in ASW
do

   rm -rf ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.vcf.gz
   rm -rf ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.with_header.vcf.gz
   rm -rf ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.with_header.vcf.gz
   rm -rf ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.with_header.vcf.gz

   rm -rf ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.vcf.gz.tbi
   rm -rf ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.with_header.vcf.gz.tbi
   rm -rf ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.with_header.vcf.gz.tbi
   rm -rf ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.with_header.vcf.gz.tbi




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
