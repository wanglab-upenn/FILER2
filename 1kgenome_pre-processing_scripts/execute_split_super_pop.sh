#!/bin/bash

while getopts dn:p:l: option
do
   case "$option" in
      d) DODEBUG=true;;      # option -d to print out commands
      p) PREFIX="$OPTARG";;
      l) CHR="$OPTARG";;
   esac
done

#rm -rf ${PREFIX}/${CHR}/*.gz ${PREFIX}/${CHR}/*.gz.tbi ${PREFIX}/${CHR}/*.header

for GROUP in AFR AMR EAS EUR SAS
do

   rm -rf ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.vcf.gz
   rm -rf ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.vcf.gz.tbi
   rm -rf ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_biallelic.vcf.gz
   rm -rf ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_biallelic.vcf.gz.tbi
   rm -rf ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_multiallelic.vcf.gz
   rm -rf ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_multiallelic.vcf.gz.tbi
   rm -rf ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_multiallelic.vcf.gz
   rm -rf ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_multiallelic.vcf.gz.tbi
   #echo "/mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view --force-samples --samples-file ${PREFIX}/${CHR}/${CHR}_${GROUP}.txt --output-file ${PREFIX}/${CHR}/${CHR}_${GROUP}.vcf.gz  --output-type z ${VCF} "
   #/mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view --force-samples --samples-file ${PREFIX}/${CHR}/${CHR}_${GROUP}.txt --output-file ${PREFIX}/${CHR}/${CHR}_${GROUP}.vcf.gz  --output-type z ${VCF}

done




