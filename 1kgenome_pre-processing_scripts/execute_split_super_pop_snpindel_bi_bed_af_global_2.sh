#!/bin/bash

while getopts dn:p:l:i: option
do
   case "$option" in
      d) DODEBUG=true;;      # option -d to print out commands
      p) PREFIX="$OPTARG";;
      l) CHR="$OPTARG";;
      i) INPUT="$OPTARG";;
   esac
done

rm -rf ${PREFIX}/${CHR}/*.bed*
rm -rf ${PREFIX}/${CHR}/*_SNP_biallelic.with_header.af.global.vcf
rm -rf ${PREFIX}/${CHR}/*.af
rm -rf ${PREFIX}/${CHR}/*.ac
rm -rf ${PREFIX}/${CHR}/*.an

for GROUP in EUR AMR EAS AFR SAS
do

   zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.with_header.vcf.gz  | sed '/^#/d' | cut -f 8 | sed -r 's/^.*;AF=([^;]+;)/GLOBAL_AF=\1/' | sed -r 's/;.*$//' > ${PREFIX}/${CHR}/${CHR}_${GROUP}_global.af
   zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz | sed '/^#/d' | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,$3,$6,".",$4,$5 etc}' > ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.with_header.af.global.vcf
   zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz | sed '/^#/d' |  cut -f 8 | sed -r 's/^.*;AF=([^;]+;)/'${GROUP}'_AF=\1/' | sed -r 's/;.*$//' > ${PREFIX}/${CHR}/${CHR}_${GROUP}_global.super.af

   zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz | sed '/^#/d' |  cut -f 8 | sed -r 's/^.*AC=([^;]+;)/'${GROUP}'_AC=\1/' | sed -r 's/;.*$//' > ${PREFIX}/${CHR}/${CHR}_${GROUP}_global.super.ac
   zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz | sed '/^#/d' |  cut -f 8 | sed -r 's/^.*;AN=([^;]+;)/'${GROUP}'_AN=\1/' | sed -r 's/;.*$//' > ${PREFIX}/${CHR}/${CHR}_${GROUP}_global.super.an


   zcat ${INPUT} | awk 'BEGIN{FS="\t"; OFS="\t"}{if (length($4) !=1 || length($5)!=1 || $8~/MULTI_ALLELIC/) next; vt=""; info=$8; n=split(info,a,";"); for (i=1; i<=n; ++i) { split(a[i],b,"="); if (a[i]~/^VT=/) vt=b[2]; if (a[i]~/^AC=/) ac=b[2]; if (a[i]~/^AN=/) an=b[2]; }; if (vt=="SNP") {print "GLOBAL_AC="ac}}' >  ${PREFIX}/${CHR}/${CHR}_${GROUP}_global.ac
   zcat ${INPUT} | awk 'BEGIN{FS="\t"; OFS="\t"}{if (length($4) !=1 || length($5)!=1 || $8~/MULTI_ALLELIC/) next; vt=""; info=$8; n=split(info,a,";"); for (i=1; i<=n; ++i) { split(a[i],b,"="); if (a[i]~/^VT=/) vt=b[2]; if (a[i]~/^AC=/) ac=b[2]; if (a[i]~/^AN=/) an=b[2]; }; if (vt=="SNP") {print "GLOBAL_AN="an}}' > ${PREFIX}/${CHR}/${CHR}_${GROUP}_global.an

done

for GROUP in EUR AMR EAS AFR SAS
do
   paste -d ";" ${PREFIX}/${CHR}/${CHR}_EUR_global.super.af  ${PREFIX}/${CHR}/${CHR}_AMR_global.super.af ${PREFIX}/${CHR}/${CHR}_EAS_global.super.af ${PREFIX}/${CHR}/${CHR}_AFR_global.super.af ${PREFIX}/${CHR}/${CHR}_SAS_global.super.af > ${PREFIX}/${CHR}/${CHR}.af
   paste -d ";" ${PREFIX}/${CHR}/${CHR}_EUR_global.super.ac  ${PREFIX}/${CHR}/${CHR}_AMR_global.super.ac ${PREFIX}/${CHR}/${CHR}_EAS_global.super.ac ${PREFIX}/${CHR}/${CHR}_AFR_global.super.ac ${PREFIX}/${CHR}/${CHR}_SAS_global.super.ac > ${PREFIX}/${CHR}/${CHR}.ac
   paste -d ";" ${PREFIX}/${CHR}/${CHR}_EUR_global.super.an  ${PREFIX}/${CHR}/${CHR}_AMR_global.super.an ${PREFIX}/${CHR}/${CHR}_EAS_global.super.an ${PREFIX}/${CHR}/${CHR}_AFR_global.super.an ${PREFIX}/${CHR}/${CHR}_SAS_global.super.an > ${PREFIX}/${CHR}/${CHR}.an
   paste ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.with_header.af.global.vcf ${PREFIX}/${CHR}/${CHR}_${GROUP}_global.af ${PREFIX}/${CHR}/${CHR}_${GROUP}_global.ac ${PREFIX}/${CHR}/${CHR}_${GROUP}_global.an ${PREFIX}/${CHR}/${CHR}.af ${PREFIX}/${CHR}/${CHR}.ac ${PREFIX}/${CHR}/${CHR}.an  | bgzip -c > ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.bed.gz
   tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_biallelic.bed.gz

done



