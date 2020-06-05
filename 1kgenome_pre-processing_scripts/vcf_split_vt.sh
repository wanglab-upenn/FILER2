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
nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view ${PREFIX}/${CHR}/${CHR}_${GROUP}.vcf.gz | grep "VT=SNP" | gzip -c > ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP.vcf.gz &
nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view ${PREFIX}/${CHR}/${CHR}_${GROUP}.vcf.gz | grep "VT=INDEL" | gzip -c > ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL.vcf.gz &
nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view ${PREFIX}/${CHR}/${CHR}_${GROUP}.vcf.gz | grep "VT=SV" | gzip -c > ${PREFIX}/${CHR}/${CHR}_${GROUP}_SV.vcf.gz &
nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view ${PREFIX}/${CHR}/${CHR}_${GROUP}.vcf.gz | grep "VT=CNV" | gzip -c > ${PREFIX}/${CHR}/${CHR}_${GROUP}_CNV.vcf.gz &
