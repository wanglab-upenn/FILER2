#!/bin/bash

while getopts dn:p:l: option
do
   case "$option" in
      d) DODEBUG=true;;      # option -d to print out commands
      p) PREFIX="$OPTARG";;
      l) CHR="$OPTARG";;
   esac
done


for GROUP in ACB ASW
do


   #zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.bed.gz | cut -f 1-12 | LC_ALL=C sort -k1,1 -k2,2n -k3,3n | bgzip -c  > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.no_genotypes.sorted.bed.gz
   #zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.bed.gz | cut -f 1-12 | LC_ALL=C sort -k1,1 -k2,2n -k3,3n | bgzip -c  > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.no_genotypes.sorted.bed.gz


   #tabix -p bed -f ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.no_genotypes.sorted.bed.gz
   #tabix -p bed -f ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.no_genotypes.sorted.bed.gz

   #zgrep -v -F "AC=0;" ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz | bgzip -c > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.no_monomorphic.vcf.gz
   #zgrep -v -F "AC=0;" ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.with_header.af.vcf.gz | bgzip -c > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.no_monomorphic.vcf.gz

   #tabix -p vcf -f ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.no_monomorphic.vcf.gz
   #tabix -p vcf -f ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.no_monomorphic.vcf.gz

   #zgrep -v -F "AC=0;" ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.with_header.af.vcf.gz | bgzip -c > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.no_monomorphic.vcf.gz
   #zgrep -v -F "AC=0;" ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.with_header.af.vcf.gz | bgzip -c > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.no_monomorphic.vcf.gz

   #tabix -p vcf -f ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.no_monomorphic.vcf.gz
   #tabix -p vcf -f ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.no_monomorphic.vcf.gz

   #zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_multiallelic.bed.gz | cut -f 1-12 | LC_ALL=C sort -k1,1 -k2,2n -k3,3n | bgzip -c  > ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_multiallelic.no_genotypes.sorted.bed.gz
   #zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_multiallelic.bed.gz | cut -f 1-12 | LC_ALL=C sort -k1,1 -k2,2n -k3,3n | bgzip -c  > ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_multiallelic.no_genotypes.sorted.bed.gz

   #tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP_multiallelic.no_genotypes.sorted.bed.gz
   #tabix -p bed -f ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL_multiallelic.no_genotypes.sorted.bed.gz


   if [ ${GROUP} == 'ACB' ] || [ ${GROUP} == 'ASW' ] || [ ${GROUP} ==  'ESN' ] || [ ${GROUP} == 'GWD' ]  || [ ${GROUP} == 'LWK' ] || [ ${GROUP} == 'MSL' ] || [  ${GROUP} == 'YRI' ]
   then
      mv ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.no_monomorphic.vcf.gz ${PREFIX}/${CHR}/pop/${CHR}_AFR_${GROUP}_SNP_biallelic.no_monomorphic.vcf.gz
      mv ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.no_monomorphic.vcf.gz ${PREFIX}/${CHR}/pop/${CHR}_AFR_${GROUP}_INDEL_biallelic.no_monomorphic.vcf.gz
      mv ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.no_monomorphic.vcf.gz ${PREFIX}/${CHR}/pop/${CHR}_AFR_${GROUP}_SNP_multiallelic.no_monomorphic.vcf.gz
      mv ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.no_monomorphic.vcf.gz ${PREFIX}/${CHR}/pop/${CHR}_AFR_${GROUP}_INDEL_multiallelic.no_monomorphic.vcf.gz
   elif [ ${GROUP} == 'BEB' ] || [ ${GROUP} == 'GIH' ] || [ ${GROUP} == 'ITU' ] || [ ${GROUP} == 'PJL' ] || [ ${GROUP} == 'STU' ]
   then
      mv ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.no_monomorphic.vcf.gz ${PREFIX}/${CHR}/pop/${CHR}_SAS_${GROUP}_SNP_biallelic.no_monomorphic.vcf.gz
      mv ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.no_monomorphic.vcf.gz ${PREFIX}/${CHR}/pop/${CHR}_SAS_${GROUP}_INDEL_biallelic.no_monomorphic.vcf.gz
      mv ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.no_monomorphic.vcf.gz ${PREFIX}/${CHR}/pop/${CHR}_SAS_${GROUP}_SNP_multiallelic.no_monomorphic.vcf.gz
      mv ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.no_monomorphic.vcf.gz ${PREFIX}/${CHR}/pop/${CHR}_SAS_${GROUP}_INDEL_multiallelic.no_monomorphic.vcf.gz
   elif [ ${GROUP} == 'CDX' ] || [ ${GROUP} == 'CHB' ]  || [ ${GROUP} == 'CHS' ] || [ ${GROUP} == 'JPT' ] || [ ${GROUP} == 'KHV' ]
   then
      mv ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.no_monomorphic.vcf.gz ${PREFIX}/${CHR}/pop/${CHR}_EAS_${GROUP}_SNP_biallelic.no_monomorphic.vcf.gz
      mv ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.no_monomorphic.vcf.gz ${PREFIX}/${CHR}/pop/${CHR}_EAS_${GROUP}_INDEL_biallelic.no_monomorphic.vcf.gz
      mv ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.no_monomorphic.vcf.gz ${PREFIX}/${CHR}/pop/${CHR}_EAS_${GROUP}_SNP_multiallelic.no_monomorphic.vcf.gz
      mv ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.no_monomorphic.vcf.gz ${PREFIX}/${CHR}/pop/${CHR}_EAS_${GROUP}_INDEL_multiallelic.no_monomorphic.vcf.gz
   elif [ ${GROUP} == 'CEU' ] || [ ${GROUP} == 'FIN' ] || [ ${GROUP} == 'GBR' ] || [ ${GROUP} == 'IBS' ] || [ ${GROUP} == 'TSI' ]
   then
      mv ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.no_monomorphic.vcf.gz ${PREFIX}/${CHR}/pop/${CHR}_EUR_${GROUP}_SNP_biallelic.no_monomorphic.vcf.gz
      mv ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.no_monomorphic.vcf.gz ${PREFIX}/${CHR}/pop/${CHR}_EUR_${GROUP}_INDEL_biallelic.no_monomorphic.vcf.gz
      mv ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.no_monomorphic.vcf.gz ${PREFIX}/${CHR}/pop/${CHR}_EUR_${GROUP}_SNP_multiallelic.no_monomorphic.vcf.gz
      mv ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.no_monomorphic.vcf.gz ${PREFIX}/${CHR}/pop/${CHR}_EUR_${GROUP}_INDEL_multiallelic.no_monomorphic.vcf.gz
   else
      mv ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.no_monomorphic.vcf.gz ${PREFIX}/${CHR}/pop/${CHR}_AMR_${GROUP}_SNP_biallelic.no_monomorphic.vcf.gz
      mv ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.no_monomorphic.vcf.gz ${PREFIX}/${CHR}/pop/${CHR}_AMR_${GROUP}_INDEL_biallelic.no_monomorphic.vcf.gz
      mv ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.no_monomorphic.vcf.gz ${PREFIX}/${CHR}/pop/${CHR}_AMR_${GROUP}_SNP_multiallelic.no_monomorphic.vcf.gz
      mv ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.no_monomorphic.vcf.gz ${PREFIX}/${CHR}/pop/${CHR}_AMR_${GROUP}_INDEL_multiallelic.no_monomorphic.vcf.gz
   fi
done
