#!/bin/bash

while getopts dn:p:l: option
do
   case "$option" in
      d) DODEBUG=true;;      # option -d to print out commands
      p) PREFIX="$OPTARG";;
      l) CHR="$OPTARG";;
   esac
done


for GROUP in EUR AMR EAS AFR SAS
do
  nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view ${PREFIX}/${CHR}/${CHR}_${GROUP}.vcf.gz | grep "VT=SNP" | gzip -c > ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP.vcf.gz &
  nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view ${PREFIX}/${CHR}/${CHR}_${GROUP}.vcf.gz | grep "VT=INDEL" | gzip -c > ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL.vcf.gz &
done
