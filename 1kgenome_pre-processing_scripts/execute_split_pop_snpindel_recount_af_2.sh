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

for GROUP in ACB ASW
do
  rm -rf ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz
  rm -rf ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.with_header.af.vcf.gz
  rm -rf ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.with_header.af.vcf.gz
  rm -rf ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.with_header.af.vcf.gz

  #status1=$(find ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.vcf.gz -empty | wc -l)
  #if [ $status1 == 1 ]
  #then
  #   rm -rf ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.vcf.gz
  #   cp ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}.header ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.vcf
  #   gzip -c ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.vcf > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.vcf.gz
  #else
     nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools +fill-tags ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.vcf.gz -- -t AF | gzip -c > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz  &
  #fi

  #status2=$(find ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.with_header.vcf.gz -empty | wc -l)
  #if [ $status2 == 1 ]
  #then
  #   rm -rf ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.with_header.vcf.gz
  #   cp ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}.header ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.with_header.vcf
 #    gzip -c ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.with_header.vcf > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.with_header.vcf.gz
 # else
     nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools +fill-tags ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.with_header.vcf.gz -- -t AF | gzip -c > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.with_header.af.vcf.gz  &
  #fi

  #status3=$(find ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.with_header.vcf.gz -empty | wc -l)
  #if [ $status3 == 1 ]
  #then
  #   rm -rf ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.with_header.vcf.gz
  #   cp ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}.header ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.with_header.vcf
  #   gzip -c ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.with_header.vcf >  ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.with_header.vcf.gz
  #else
     nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools +fill-tags ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.with_header.vcf.gz -- -t AF | gzip -c > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.with_header.af.vcf.gz  &
  #fi

  #status4=$(find ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.with_header.vcf.gz -empty | wc -l)
  #if [ $status4 == 1 ]
  #then
  #   rm -rf {PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.with_header.vcf.gz
  #   cp ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}.header ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.with_header.vcf
  #   gzip -c ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.with_header.vcf > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.with_header.vcf.gz
  #else
     nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools +fill-tags ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.with_header.vcf.gz -- -t AF | gzip -c > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.with_header.af.vcf.gz  &
  #fi

  #nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools +fill-tags ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.vcf.gz -- -t AF | gzip -c > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz  &
  #nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools +fill-tags ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.with_header.vcf.gz -- -t AF | gzip -c > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.with_header.af.vcf.gz  &
  #nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools +fill-tags ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.with_header.vcf.gz   -- -t AF | gzip -c > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.with_header.af.vcf.gz &
  #nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools +fill-tags ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.with_header.vcf.gz   -- -t AF | gzip -c > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.with_header.af.vcf.gz &

done
