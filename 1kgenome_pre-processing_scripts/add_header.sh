#!/bin/bash
while getopts dn:l:p: option
do
   case "$option" in
      d) DODEBUG=true;;      # option -d to print out commands
      l) CHR="$OPTARG";;
      p) PREFIX="$OPTARG";;
   esac
done

#zcat ${PREFIX}/${CHR}/${CHR}_AFR.vcf.gz | awk '{if ($1~/^#/) print; else exit;}' > ${PREFIX}/${CHR}/${CHR}_AFR.header
#zcat ${PREFIX}/${CHR}/${CHR}_AMR.vcf.gz | awk '{if ($1~/^#/) print; else exit;}' > ${PREFIX}/${CHR}/${CHR}_AMR.header
#zcat ${PREFIX}/${CHR}/${CHR}_EAS.vcf.gz | awk '{if ($1~/^#/) print; else exit;}' > ${PREFIX}/${CHR}/${CHR}_EAS.header
#zcat ${PREFIX}/${CHR}/${CHR}_EUR.vcf.gz | awk '{if ($1~/^#/) print; else exit;}' > ${PREFIX}/${CHR}/${CHR}_EUR.header
#zcat ${PREFIX}/${CHR}/${CHR}_SAS.vcf.gz | awk '{if ($1~/^#/) print; else exit;}' > ${PREFIX}/${CHR}/${CHR}_SAS.header


tabix -r ${PREFIX}/${CHR}/${CHR}_AFR.header ${PREFIX}/${CHR}/${CHR}_AFR_SNP_multiallelic.vcf.gz > ${PREFIX}/${CHR}/${CHR}_AFR_SNP_multiallelic.with_header.vcf.gz
tabix -r ${PREFIX}/${CHR}/${CHR}_AMR.header ${PREFIX}/${CHR}/${CHR}_AMR_SNP_multiallelic.vcf.gz > ${PREFIX}/${CHR}/${CHR}_AMR_SNP_multiallelic.with_header.vcf.gz
tabix -r ${PREFIX}/${CHR}/${CHR}_EAS.header ${PREFIX}/${CHR}/${CHR}_EAS_SNP_multiallelic.vcf.gz > ${PREFIX}/${CHR}/${CHR}_EAS_SNP_multiallelic.with_header.vcf.gz
tabix -r ${PREFIX}/${CHR}/${CHR}_EUR.header ${PREFIX}/${CHR}/${CHR}_EUR_SNP_multiallelic.vcf.gz > ${PREFIX}/${CHR}/${CHR}_EUR_SNP_multiallelic.with_header.vcf.gz
tabix -r ${PREFIX}/${CHR}/${CHR}_SAS.header ${PREFIX}/${CHR}/${CHR}_SAS_SNP_multiallelic.vcf.gz > ${PREFIX}/${CHR}/${CHR}_SAS_SNP_multiallelic.with_header.vcf.gz


tabix -r ${PREFIX}/${CHR}/${CHR}_AFR.header ${PREFIX}/${CHR}/${CHR}_AFR_INDEL_multiallelic.vcf.gz > ${PREFIX}/${CHR}/${CHR}_AFR_INDEL_multiallelic.with_header.vcf.gz
tabix -r ${PREFIX}/${CHR}/${CHR}_AMR.header ${PREFIX}/${CHR}/${CHR}_AMR_INDEL_multiallelic.vcf.gz > ${PREFIX}/${CHR}/${CHR}_AMR_INDEL_multiallelic.with_header.vcf.gz
tabix -r ${PREFIX}/${CHR}/${CHR}_EAS.header ${PREFIX}/${CHR}/${CHR}_EAS_INDEL_multiallelic.vcf.gz > ${PREFIX}/${CHR}/${CHR}_EAS_INDEL_multiallelic.with_header.vcf.gz
tabix -r ${PREFIX}/${CHR}/${CHR}_EUR.header ${PREFIX}/${CHR}/${CHR}_EUR_INDEL_multiallelic.vcf.gz > ${PREFIX}/${CHR}/${CHR}_EUR_INDEL_multiallelic.with_header.vcf.gz
tabix -r ${PREFIX}/${CHR}/${CHR}_SAS.header ${PREFIX}/${CHR}/${CHR}_SAS_INDEL_multiallelic.vcf.gz > ${PREFIX}/${CHR}/${CHR}_SAS_INDEL_multiallelic.with_header.vcf.gz


tabix -r ${PREFIX}/${CHR}/${CHR}_AFR.header ${PREFIX}/${CHR}/${CHR}_AFR_SNP_biallelic.vcf.gz > ${PREFIX}/${CHR}/${CHR}_AFR_SNP_biallelic.with_header.vcf.gz
tabix -r ${PREFIX}/${CHR}/${CHR}_AMR.header ${PREFIX}/${CHR}/${CHR}_AMR_SNP_biallelic.vcf.gz > ${PREFIX}/${CHR}/${CHR}_AMR_SNP_biallelic.with_header.vcf.gz
tabix -r ${PREFIX}/${CHR}/${CHR}_EAS.header ${PREFIX}/${CHR}/${CHR}_EAS_SNP_biallelic.vcf.gz > ${PREFIX}/${CHR}/${CHR}_EAS_SNP_biallelic.with_header.vcf.gz
tabix -r ${PREFIX}/${CHR}/${CHR}_EUR.header ${PREFIX}/${CHR}/${CHR}_EUR_SNP_biallelic.vcf.gz > ${PREFIX}/${CHR}/${CHR}_EUR_SNP_biallelic.with_header.vcf.gz
tabix -r ${PREFIX}/${CHR}/${CHR}_SAS.header ${PREFIX}/${CHR}/${CHR}_SAS_SNP_biallelic.vcf.gz > ${PREFIX}/${CHR}/${CHR}_SAS_SNP_biallelic.with_header.vcf.gz


tabix -r ${PREFIX}/${CHR}/${CHR}_AFR.header ${PREFIX}/${CHR}/${CHR}_AFR_INDEL_biallelic.vcf.gz > ${PREFIX}/${CHR}/${CHR}_AFR_INDEL_biallelic.with_header.vcf.gz
tabix -r ${PREFIX}/${CHR}/${CHR}_AMR.header ${PREFIX}/${CHR}/${CHR}_AMR_INDEL_biallelic.vcf.gz > ${PREFIX}/${CHR}/${CHR}_AMR_INDEL_biallelic.with_header.vcf.gz
tabix -r ${PREFIX}/${CHR}/${CHR}_EAS.header ${PREFIX}/${CHR}/${CHR}_EAS_INDEL_biallelic.vcf.gz > ${PREFIX}/${CHR}/${CHR}_EAS_INDEL_biallelic.with_header.vcf.gz
tabix -r ${PREFIX}/${CHR}/${CHR}_EUR.header ${PREFIX}/${CHR}/${CHR}_EUR_INDEL_biallelic.vcf.gz > ${PREFIX}/${CHR}/${CHR}_EUR_INDEL_biallelic.with_header.vcf.gz
tabix -r ${PREFIX}/${CHR}/${CHR}_SAS.header ${PREFIX}/${CHR}/${CHR}_SAS_INDEL_biallelic.vcf.gz > ${PREFIX}/${CHR}/${CHR}_SAS_INDEL_biallelic.with_header.vcf.gz



tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_AFR_SNP_biallelic.with_header.vcf.gz
tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_AMR_SNP_biallelic.with_header.vcf.gz
tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_EAS_SNP_biallelic.with_header.vcf.gz
tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_EUR_SNP_biallelic.with_header.vcf.gz
tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_SAS_SNP_biallelic.with_header.vcf.gz


tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_AFR_SNP_multiallelic.with_header.vcf.gz
tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_AMR_SNP_multiallelic.with_header.vcf.gz
tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_EAS_SNP_multiallelic.with_header.vcf.gz
tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_EUR_SNP_multiallelic.with_header.vcf.gz
tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_SAS_SNP_multiallelic.with_header.vcf.gz


tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_AFR_INDEL_biallelic.with_header.vcf.gz
tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_AMR_INDEL_biallelic.with_header.vcf.gz
tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_EAS_INDEL_biallelic.with_header.vcf.gz
tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_EUR_INDEL_biallelic.with_header.vcf.gz
tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_SAS_INDEL_biallelic.with_header.vcf.gz


tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_AFR_INDEL_multiallelic.with_header.vcf.gz
tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_AMR_INDEL_multiallelic.with_header.vcf.gz
tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_EAS_INDEL_multiallelic.with_header.vcf.gz
tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_EUR_INDEL_multiallelic.with_header.vcf.gz
tabix -p vcf -f ${PREFIX}/${CHR}/${CHR}_SAS_INDEL_multiallelic.with_header.vcf.gz
