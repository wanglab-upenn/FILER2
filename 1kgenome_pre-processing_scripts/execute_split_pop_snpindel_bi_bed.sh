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
   zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- | gawk 'match($5, /AFR_AF=[0-9]+\.[0-9]+|AFR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.bed.gz
   zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  gawk 'match($5, /AFR_AF=[0-9]+\.[0-9]+|AFR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.bed.gz


   tabix -p bed -f ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.bed.gz
   tabix -p bed -f ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.bed.gz


   zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- | gawk 'match($5, /AFR_AF=[0-9]+\.[0-9]+|AFR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.bed.gz
   zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  gawk 'match($5, /AFR_AF=[0-9]+\.[0-9]+|AFR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.bed.gz

   tabix -p bed -f ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.bed.gz
   tabix -p bed -f ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.bed.gz

done
