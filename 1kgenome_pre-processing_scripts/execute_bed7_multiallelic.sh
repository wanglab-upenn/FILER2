#!/bin/bash

while getopts dn:p:l: option
do
   case "$option" in
      d) DODEBUG=true;;      # option -d to print out commands
      p) PREFIX="$OPTARG";;
      l) CHR="$OPTARG";;
   esac
done

#gawk 'match($5, /AFR_AF=[0-9]+\.[0-9]+|AFR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11-




#AFR
zcat ${PREFIX}/${CHR}/${CHR}_AFR_SNP_multiallelic.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- | gawk 'match($5, /AFR_AF=[0-9]+\.[0-9]+|AFR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_AFR_SNP_multiallelic.bed.gz
zcat ${PREFIX}/${CHR}/${CHR}_AFR_INDEL_multiallelic.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  gawk 'match($5, /AFR_AF=[0-9]+\.[0-9]+|AFR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_AFR_INDEL_multiallelic.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_AFR_SV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- | gawk 'match($5, /AFR_AF=[0-9]+\.[0-9]+|AFR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_AFR_SV.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_AFR_CNV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- | gawk 'match($5, /AFR_AF=[0-9]+\.[0-9]+|AFR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_AFR_CNV.bed.gz

#AMR
zcat ${PREFIX}/${CHR}/${CHR}_AMR_SNP_multiallelic.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  gawk 'match($5, /AMR_AF=[0-9]+\.[0-9]+|AMR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_AMR_SNP_multiallelic.bed.gz
zcat ${PREFIX}/${CHR}/${CHR}_AMR_INDEL_multiallelic.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- | gawk 'match($5, /AMR_AF=[0-9]+\.[0-9]+|AMR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_AMR_INDEL_multiallelic.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_AMR_SV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  gawk 'match($5, /AMR_AF=[0-9]+\.[0-9]+|AMR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_AMR_SV.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_AMR_CNV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- | gawk 'match($5, /AMR_AF=[0-9]+\.[0-9]+|AMR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_AMR_CNV.bed.gz

#EAS
zcat ${PREFIX}/${CHR}/${CHR}_EAS_SNP_multiallelic.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- | gawk 'match($5, /EAS_AF=[0-9]+\.[0-9]+|EAS_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_EAS_SNP_multiallelic.bed.gz
zcat ${PREFIX}/${CHR}/${CHR}_EAS_INDEL_multiallelic.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  gawk 'match($5, /EAS_AF=[0-9]+\.[0-9]+|EAS_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_EAS_INDEL_multiallelic.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_EAS_SV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- | gawk 'match($5, /EAS_AF=[0-9]+\.[0-9]+|EAS_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_EAS_SV.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_EAS_CNV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  gawk 'match($5, /EAS_AF=[0-9]+\.[0-9]+|EAS_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_EAS_CNV.bed.gz

#EUR
zcat ${PREFIX}/${CHR}/${CHR}_EUR_SNP_multiallelic.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  gawk 'match($5, /EUR_AF=[0-9]+\.[0-9]+|EUR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_EUR_SNP_multiallelic.bed.gz
zcat ${PREFIX}/${CHR}/${CHR}_EUR_INDEL_multiallelic.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- | gawk 'match($5, /EUR_AF=[0-9]+\.[0-9]+|EUR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_EUR_INDEL_multiallelic.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_EUR_SV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- | gawk 'match($5, /EUR_AF=[0-9]+\.[0-9]+|EUR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_EUR_SV.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_EUR_CNV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- | gawk 'match($5, /EUR_AF=[0-9]+\.[0-9]+|EUR_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_EUR_CNV.bed.gz

#SAS
zcat ${PREFIX}/${CHR}/${CHR}_SAS_SNP_multiallelic.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- | gawk 'match($5, /SAS_AF=[0-9]+\.[0-9]+|SAS_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_SAS_SNP_multiallelic.bed.gz
zcat ${PREFIX}/${CHR}/${CHR}_SAS_INDEL_multiallelic.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  gawk 'match($5, /SAS_AF=[0-9]+\.[0-9]+|SAS_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_SAS_INDEL_multiallelic.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_SAS_SV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  gawk 'match($5, /SAS_AF=[0-9]+\.[0-9]+|SAS_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip  > ${PREFIX}/${CHR}/${CHR}_SAS_SV.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_SAS_CNV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- | gawk 'match($5, /SAS_AF=[0-9]+\.[0-9]+|SAS_AF=[0-9]+/, ary) { split(ary[0],y,"=");FS="\t";OFS="\t";print $1,$2,$3,$4,y[2],$RS }' | cut -f1-5,11- | sed -r 's/\t$//' | bgzip  > ${PREFIX}/${CHR}/${CHR}_SAS_CNV.bed.gz




tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_AFR_SNP_multiallelic.bed.gz
tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_AFR_INDEL_multiallelic.bed.gz
#tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_AFR_SV.bed.gz
#tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_AFR_CNV.bed.gz

tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_AMR_SNP_multiallelic.bed.gz
tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_AMR_INDEL_multiallelic.bed.gz
#tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_AMR_SV.bed.gz
#tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_AMR_CNV.bed.gz

tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_EAS_SNP_multiallelic.bed.gz
tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_EAS_INDEL_multiallelic.bed.gz
#tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_EAS_SV.bed.gz
#tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_EAS_CNV.bed.gz

tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_EUR_SNP_multiallelic.bed.gz
tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_EUR_INDEL_multiallelic.bed.gz
#tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_EUR_SV.bed.gz
#tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_EUR_CNV.bed.gz

tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_SAS_SNP_multiallelic.bed.gz
tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_SAS_INDEL_multiallelic.bed.gz
#tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_SAS_SV.bed.gz
#tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_SAS_CNV.bed.gz
