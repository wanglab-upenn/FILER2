#!/bin/bash

while getopts dn:p:l: option
do
   case "$option" in
      d) DODEBUG=true;;      # option -d to print out commands
      p) PREFIX="$OPTARG";;
      l) CHR="$OPTARG";;
   esac
done

rm -rf ${PREFIX}/${CHR}/pop/*.bed*
rm -rf ${PREFIX}/${CHR}/pop/*.ac
rm -rf ${PREFIX}/${CHR}/pop/*.an
rm -rf ${PREFIX}/${CHR}/pop/*.af

for GROUP in ACB ASW BEB CDX CEU CHB CHS CLM ESN FIN GBR GIH GWD IBS ITU JPT KHV LWK MSL MXL PEL PJL PUR STU TSI YRI
do
   zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz | sed '/^#/d' | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,$3,$6,".",$4,$5 etc}' > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.af.global.vcf

  if [ ${GROUP} == 'ACB' ] || [ ${GROUP} == 'ASW' ] || [ ${GROUP} ==  'ESN' ] || [ ${GROUP} == 'GWD' ]  || [ ${GROUP} == 'LWK' ] || [ ${GROUP} == 'MSL' ] || [  ${GROUP} == 'YRI' ]
   then
    #AFR
       zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz | sed '/^#/d' |  cut -f 8 | sed -r 's/^.*;AF=([^;]+;)/AFR_'${GROUP}'_AF=\1/' | sed -r 's/;.*$//' > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_global.pop.af
       zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz | sed '/^#/d' |  cut -f 8 | sed -r 's/^.*AC=([^;]+;)/AFR_'${GROUP}'_AC=\1/' | sed -r 's/;.*$//' > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_global.pop.ac
       zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz | sed '/^#/d' |  cut -f 8 | sed -r 's/^.*;AN=([^;]+;)/AFR_'${GROUP}'_AN=\1/' | sed -r 's/;.*$//' > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_global.pop.an
  elif [ ${GROUP} == 'BEB' ] || [ ${GROUP} == 'GIH' ] || [ ${GROUP} == 'ITU' ] || [ ${GROUP} == 'PJL' ] || [ ${GROUP} == 'STU' ]
   then
    #SAS
       zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz | sed '/^#/d' |  cut -f 8 | sed -r 's/^.*;AF=([^;]+;)/SAS_'${GROUP}'_AF=\1/' | sed -r 's/;.*$//' > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_global.pop.af
       zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz | sed '/^#/d' |  cut -f 8 | sed -r 's/^.*AC=([^;]+;)/SAS_'${GROUP}'_AC=\1/' | sed -r 's/;.*$//' > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_global.pop.ac
       zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz | sed '/^#/d' |  cut -f 8 | sed -r 's/^.*;AN=([^;]+;)/SAS_'${GROUP}'_AN=\1/' | sed -r 's/;.*$//' > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_global.pop.an
  elif [ ${GROUP} == 'CDX' ] || [ ${GROUP} == 'CHB' ]  || [ ${GROUP} == 'CHS' ] || [ ${GROUP} == 'JPT' ] || [ ${GROUP} == 'KHV' ]
   then
    #EAS
       zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz | sed '/^#/d' |  cut -f 8 | sed -r 's/^.*;AF=([^;]+;)/EAS_'${GROUP}'_AF=\1/' | sed -r 's/;.*$//' > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_global.pop.af
       zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz | sed '/^#/d' |  cut -f 8 | sed -r 's/^.*AC=([^;]+;)/EAS_'${GROUP}'_AC=\1/' | sed -r 's/;.*$//' > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_global.pop.ac
       zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz | sed '/^#/d' |  cut -f 8 | sed -r 's/^.*;AN=([^;]+;)/EAS_'${GROUP}'_AN=\1/' | sed -r 's/;.*$//' > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_global.pop.an
  elif [ ${GROUP} == 'CEU' ] || [ ${GROUP} == 'FIN' ] || [ ${GROUP} == 'GBR' ] || [ ${GROUP} == 'IBS' ] || [ ${GROUP} == 'TSI' ]
   then
    #EUR
       zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz | sed '/^#/d' |  cut -f 8 | sed -r 's/^.*;AF=([^;]+;)/EUR_'${GROUP}'_AF=\1/' | sed -r 's/;.*$//' > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_global.pop.af
       zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz | sed '/^#/d' |  cut -f 8 | sed -r 's/^.*AC=([^;]+;)/EUR_'${GROUP}'_AC=\1/' | sed -r 's/;.*$//' > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_global.pop.ac
       zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz | sed '/^#/d' |  cut -f 8 | sed -r 's/^.*;AN=([^;]+;)/EUR_'${GROUP}'_AN=\1/' | sed -r 's/;.*$//' > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_global.pop.an
  else
   #AMR
      zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz | sed '/^#/d' |  cut -f 8 | sed -r 's/^.*;AF=([^;]+;)/AMR_'${GROUP}'_AF=\1/' | sed -r 's/;.*$//' > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_global.pop.af
      zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz | sed '/^#/d' |  cut -f 8 | sed -r 's/^.*AC=([^;]+;)/AMR_'${GROUP}'_AC=\1/' | sed -r 's/;.*$//' > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_global.pop.ac
      zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.af.vcf.gz | sed '/^#/d' |  cut -f 8 | sed -r 's/^.*;AN=([^;]+;)/AMR_'${GROUP}'_AN=\1/' | sed -r 's/;.*$//' > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_global.pop.an
  fi
done

   paste -d ";" ${PREFIX}/${CHR}/pop/${CHR}_ACB_global.pop.af  ${PREFIX}/${CHR}/pop/${CHR}_ASW_global.pop.af ${PREFIX}/${CHR}/pop/${CHR}_BEB_global.pop.af ${PREFIX}/${CHR}/pop/${CHR}_CDX_global.pop.af ${PREFIX}/${CHR}/pop/${CHR}_CEU_global.pop.af ${PREFIX}/${CHR}/pop/${CHR}_CHB_global.pop.af ${PREFIX}/${CHR}/pop/${CHR}_CHS_global.pop.af ${PREFIX}/${CHR}/pop/${CHR}_CLM_global.pop.af ${PREFIX}/${CHR}/pop/${CHR}_ESN_global.pop.af ${PREFIX}/${CHR}/pop/${CHR}_FIN_global.pop.af ${PREFIX}/${CHR}/pop/${CHR}_GBR_global.pop.af ${PREFIX}/${CHR}/pop/${CHR}_GIH_global.pop.af ${PREFIX}/${CHR}/pop/${CHR}_GWD_global.pop.af ${PREFIX}/${CHR}/pop/${CHR}_IBS_global.pop.af ${PREFIX}/${CHR}/pop/${CHR}_ITU_global.pop.af ${PREFIX}/${CHR}/pop/${CHR}_JPT_global.pop.af ${PREFIX}/${CHR}/pop/${CHR}_KHV_global.pop.af ${PREFIX}/${CHR}/pop/${CHR}_LWK_global.pop.af ${PREFIX}/${CHR}/pop/${CHR}_MSL_global.pop.af ${PREFIX}/${CHR}/pop/${CHR}_MXL_global.pop.af ${PREFIX}/${CHR}/pop/${CHR}_PEL_global.pop.af ${PREFIX}/${CHR}/pop/${CHR}_PJL_global.pop.af ${PREFIX}/${CHR}/pop/${CHR}_PUR_global.pop.af ${PREFIX}/${CHR}/pop/${CHR}_STU_global.pop.af ${PREFIX}/${CHR}/pop/${CHR}_TSI_global.pop.af ${PREFIX}/${CHR}/pop/${CHR}_YRI_global.pop.af > ${PREFIX}/${CHR}/pop/${CHR}.af
   paste -d ";" ${PREFIX}/${CHR}/pop/${CHR}_ACB_global.pop.ac  ${PREFIX}/${CHR}/pop/${CHR}_ASW_global.pop.ac ${PREFIX}/${CHR}/pop/${CHR}_BEB_global.pop.ac ${PREFIX}/${CHR}/pop/${CHR}_CDX_global.pop.ac ${PREFIX}/${CHR}/pop/${CHR}_CEU_global.pop.ac ${PREFIX}/${CHR}/pop/${CHR}_CHB_global.pop.ac ${PREFIX}/${CHR}/pop/${CHR}_CHS_global.pop.ac ${PREFIX}/${CHR}/pop/${CHR}_CLM_global.pop.ac ${PREFIX}/${CHR}/pop/${CHR}_ESN_global.pop.ac ${PREFIX}/${CHR}/pop/${CHR}_FIN_global.pop.ac ${PREFIX}/${CHR}/pop/${CHR}_GBR_global.pop.ac ${PREFIX}/${CHR}/pop/${CHR}_GIH_global.pop.ac ${PREFIX}/${CHR}/pop/${CHR}_GWD_global.pop.ac ${PREFIX}/${CHR}/pop/${CHR}_IBS_global.pop.ac ${PREFIX}/${CHR}/pop/${CHR}_ITU_global.pop.ac ${PREFIX}/${CHR}/pop/${CHR}_JPT_global.pop.ac ${PREFIX}/${CHR}/pop/${CHR}_KHV_global.pop.ac ${PREFIX}/${CHR}/pop/${CHR}_LWK_global.pop.ac ${PREFIX}/${CHR}/pop/${CHR}_MSL_global.pop.ac ${PREFIX}/${CHR}/pop/${CHR}_MXL_global.pop.ac ${PREFIX}/${CHR}/pop/${CHR}_PEL_global.pop.ac ${PREFIX}/${CHR}/pop/${CHR}_PJL_global.pop.ac ${PREFIX}/${CHR}/pop/${CHR}_PUR_global.pop.ac ${PREFIX}/${CHR}/pop/${CHR}_STU_global.pop.ac ${PREFIX}/${CHR}/pop/${CHR}_TSI_global.pop.ac ${PREFIX}/${CHR}/pop/${CHR}_YRI_global.pop.ac > ${PREFIX}/${CHR}/pop/${CHR}.ac
   paste -d ";" ${PREFIX}/${CHR}/pop/${CHR}_ACB_global.pop.an  ${PREFIX}/${CHR}/pop/${CHR}_ASW_global.pop.an ${PREFIX}/${CHR}/pop/${CHR}_BEB_global.pop.an ${PREFIX}/${CHR}/pop/${CHR}_CDX_global.pop.an ${PREFIX}/${CHR}/pop/${CHR}_CEU_global.pop.an ${PREFIX}/${CHR}/pop/${CHR}_CHB_global.pop.an ${PREFIX}/${CHR}/pop/${CHR}_CHS_global.pop.an ${PREFIX}/${CHR}/pop/${CHR}_CLM_global.pop.an ${PREFIX}/${CHR}/pop/${CHR}_ESN_global.pop.an ${PREFIX}/${CHR}/pop/${CHR}_FIN_global.pop.an ${PREFIX}/${CHR}/pop/${CHR}_GBR_global.pop.an ${PREFIX}/${CHR}/pop/${CHR}_GIH_global.pop.an ${PREFIX}/${CHR}/pop/${CHR}_GWD_global.pop.an ${PREFIX}/${CHR}/pop/${CHR}_IBS_global.pop.an ${PREFIX}/${CHR}/pop/${CHR}_ITU_global.pop.an ${PREFIX}/${CHR}/pop/${CHR}_JPT_global.pop.an ${PREFIX}/${CHR}/pop/${CHR}_KHV_global.pop.an ${PREFIX}/${CHR}/pop/${CHR}_LWK_global.pop.an ${PREFIX}/${CHR}/pop/${CHR}_MSL_global.pop.an ${PREFIX}/${CHR}/pop/${CHR}_MXL_global.pop.an ${PREFIX}/${CHR}/pop/${CHR}_PEL_global.pop.an ${PREFIX}/${CHR}/pop/${CHR}_PJL_global.pop.an ${PREFIX}/${CHR}/pop/${CHR}_PUR_global.pop.an ${PREFIX}/${CHR}/pop/${CHR}_STU_global.pop.an ${PREFIX}/${CHR}/pop/${CHR}_TSI_global.pop.an ${PREFIX}/${CHR}/pop/${CHR}_YRI_global.pop.an > ${PREFIX}/${CHR}/pop/${CHR}.an

for GROUP in CEU
do
   paste ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.with_header.af.global.vcf ${PREFIX}/${CHR}/${CHR}_EUR_global.af ${PREFIX}/${CHR}/${CHR}_EUR_global.ac ${PREFIX}/${CHR}/${CHR}_EUR_global.an ${PREFIX}/${CHR}/${CHR}.af ${PREFIX}/${CHR}/${CHR}.ac ${PREFIX}/${CHR}/${CHR}.an ${PREFIX}/${CHR}/pop/${CHR}.af ${PREFIX}/${CHR}/pop/${CHR}.ac ${PREFIX}/${CHR}/pop/${CHR}.an  | bgzip -c > ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.bed.gz
   tabix -p bed -f ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.bed.gz
done









