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
  nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}.vcf.gz | grep "VT=SNP" | gzip -c > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP.vcf.gz &
  nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}.vcf.gz | grep "VT=INDEL" | gzip -c > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL.vcf.gz &
done
