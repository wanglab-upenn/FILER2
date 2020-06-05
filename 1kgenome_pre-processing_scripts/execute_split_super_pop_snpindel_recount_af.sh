#!/bin/bash

while getopts dn:p:l: option
do
   case "$option" in
      d) DODEBUG=true;;      # option -d to print out commands
      p) PREFIX="$OPTARG";;
      l) CHR="$OPTARG";;
   esac
done

export BCFTOOLS_PLUGINS=/mnt/data/hannah/1kg_phase3/bcftools-1.9/plugins

for GROUP in EUR AMR EAS AFR SAS
do
  nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools +fill-tags ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.with_header.vcf.gz -- -t AF | gzip -c > ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz  &
  nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools +fill-tags ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_biallelic.with_header.vcf.gz -- -t AF | gzip -c > ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_biallelic.with_header.af.vcf.gz  &
  nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools +fill-tags ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_multiallelic.with_header.vcf.gz   -- -t AF | gzip -c > ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_multiallelic.with_header.af.vcf.gz &
  nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools +fill-tags ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_multiallelic.with_header.vcf.gz   -- -t AF | gzip -c > ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_multiallelic.with_header.af.vcf.gz &

done
