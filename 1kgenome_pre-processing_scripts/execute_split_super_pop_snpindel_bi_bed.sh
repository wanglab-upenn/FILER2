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
  status1=$(zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.vcf.gz | sed '/^#/d'| wc -l )
  if [ $status1 == 0 ]
  then
      touch ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.bed
      bgzip ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.bed > ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.bed.gz
  else
      zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- | gawk 'match($5, /AFR_AF=[0-9]+\.[0-9]+|AFR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.bed.gz
      tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.bed.gz
  fi

  status2=$(zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_biallelic.vcf.gz | sed '/^#/d'| wc -l )
  if [ $status2 == 0 ]
  then
      touch ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_biallelic.bed
      bgzip ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_biallelic.bed > ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_biallelic.bed.gz
  else
      zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_biallelic.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  gawk 'match($5, /AFR_AF=[0-9]+\.[0-9]+|AFR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_biallelic.bed.gz
      tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_biallelic.bed.gz
  fi

  status3=$(zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_multiallelic.vcf.gz | sed '/^#/d'| wc -l )
  if [ $status3 == 0 ]
  then
      touch ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_multiallelic.bed
      bgzip ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_multiallelic.bed > ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_multiallelic.bed.gz
  else
      zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_multiallelic.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- | gawk 'match($5, /AFR_AF=[0-9]+\.[0-9]+|AFR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_multiallelic.bed.gz
      tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_multiallelic.bed.gz
  fi

  status4=$(zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_multiallelic.vcf.gz | sed '/^#/d'| wc -l )
  if [ $status4 == 0 ]
  then
      touch ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_multiallelic.bed
      bgzip ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_multiallelic.bed > ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_multiallelic.bed.gz
  else
      zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_multiallelic.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  gawk 'match($5, /AFR_AF=[0-9]+\.[0-9]+|AFR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_multiallelic.bed.gz
      tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_multiallelic.bed.gz
  fi
done
