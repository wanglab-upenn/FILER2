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
   zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz  | sed '/^#/d' | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- | gawk 'match($5, /AFR_AF=[0-9]+\.[0-9]+|AFR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip -c  > ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.bed.gz
   zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_biallelic.with_header.af.vcf.gz  | sed '/^#/d'| awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  gawk 'match($5, /AFR_AF=[0-9]+\.[0-9]+|AFR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip -c  > ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_biallelic.bed.gz


   tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.bed.gz
   tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_biallelic.bed.gz


   zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_multiallelic.with_header.af.vcf.gz  | sed '/^#/d'| awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- | gawk 'match($5, /AFR_AF=[0-9]+\.[0-9]+|AFR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip -c  > ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_multiallelic.bed.gz
   zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_multiallelic.with_header.af.vcf.gz  | sed '/^#/d'| awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  gawk 'match($5, /AFR_AF=[0-9]+\.[0-9]+|AFR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip -c  > ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_multiallelic.bed.gz

   tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_multiallelic.bed.gz
   tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_multiallelic.bed.gz

done
