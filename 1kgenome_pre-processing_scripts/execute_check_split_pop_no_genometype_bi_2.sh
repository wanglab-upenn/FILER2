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

   SNP_BI=$(zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.no_genotypes.sorted.bed.gz | wc -l )
   INDEL_BI=$(zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.no_genotypes.sorted.bed.gz | wc -l )
   SNP_MI=$(zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.no_genotypes.sorted.bed.gz | wc -l )
   INDEL_MI=$(zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.no_genotypes.sorted.bed.gz | wc -l )

   SNP_BI_MO=$(zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.no_monomorphic.vcf.gz | wc -l )
   INDEL_BI_MO=$(zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.no_monomorphic.vcf.gz | wc -l )
   echo ${GROUP} $SNP_BI $INDEL_BI $SNP_MI $INDEL_MI $SNP_BI_MO $INDEL_BI_MO >> ${PREFIX}/${CHR}/pop/mo_status.txt

   #SNP_multi_num=$(zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_multiallelic.vcf.gz | wc -l )
   #SNP_bi_num=$(zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP_biallelic.vcf.gz | wc -l )
   #SNPNUM=$(zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_SNP.vcf.gz | wc -l )
   #SNP_ADD=`expr $SNP_multi_num + $SNP_bi_num `
   #if [ $SNPNUM != $SNP_ADD ]
   #then
   #   echo '${CHR}_${GROUP}_SNP need to check'   >>  ${PREFIX}/${CHR}/pop/pop_bi_status.txt
   #fi



   #INDEL_multi_num=$(zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_multiallelic.vcf.gz | wc -l )
   #INDEL_bi_num=$(zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL_biallelic.vcf.gz | wc -l )
   #INDELNUM=$(zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}_INDEL.vcf.gz | wc -l )
   #INDEL_ADD=`expr $INDEL_multi_num + $INDEL_bi_num `
   #if [ $INDELNUM != $INDEL_ADD ]
   #then
   #   echo '${CHR}_${GROUP}_INDEL need to check'   >>  ${PREFIX}/${CHR}/pop/pop_bi_status.txt
   #fi
   #echo $GROUP " [ " $SNPNUM $SNP_bi_num $SNP_multi_num $INDELNUM $INDEL_bi_num $INDEL_multi_num " ] " >> ${PREFIX}/${CHR}/pop/${CHR}.pop.status.txt
done

#echo "/home/hannah/vcftools-0.1.16/usr/local/bin/vcf-subset  -c ${PREFIX}/${CHR}/${CHR}_EUR.txt ${VCF}  | bgzip -c  > ${PREFIX}/${CHR}/${CHR}_EUR.vcf.gz "
#nohup  /home/hannah/vcftools-0.1.16/usr/local/bin/vcf-subset  -c ${PREFIX}/${CHR}/${CHR}_EUR.txt ${VCF} | bgzip -c  > ${PREFIX}/${CHR}/${CHR}_EUR.vcf.gz &

#echo "/home/hannah/vcftools-0.1.16/usr/local/bin/vcf-subset  -c ${PREFIX}/${CHR}/${CHR}_AMR.txt ${VCF}  | bgzip -c  > ${PREFIX}/${CHR}/${CHR}_AMR.vcf.gz "
#nohup  /home/hannah/vcftools-0.1.16/usr/local/bin/vcf-subset  -c ${PREFIX}/${CHR}/${CHR}_AMR.txt ${VCF} | bgzip -c  > ${PREFIX}/${CHR}/${CHR}_AMR.vcf.gz &

#echo "/home/hannah/vcftools-0.1.16/usr/local/bin/vcf-subset  -c ${PREFIX}/${CHR}/${CHR}_EAS.txt ${VCF}  | bgzip -c  > ${PREFIX}/${CHR}/${CHR}_EAS.vcf.gz "
#nohup  /home/hannah/vcftools-0.1.16/usr/local/bin/vcf-subset  -c ${PREFIX}/${CHR}/${CHR}_EAS.txt ${VCF} | bgzip -c  > ${PREFIX}/${CHR}/${CHR}_EAS.vcf.gz &

#echo "/home/hannah/vcftools-0.1.16/usr/local/bin/vcf-subset  -c ${PREFIX}/${CHR}/${CHR}_AFR.txt ${VCF}  | bgzip -c  > ${PREFIX}/${CHR}/${CHR}_AFR.vcf.gz "
#nohup  /home/hannah/vcftools-0.1.16/usr/local/bin/vcf-subset  -c ${PREFIX}/${CHR}/${CHR}_AFR.txt ${VCF} | bgzip -c  > ${PREFIX}/${CHR}/${CHR}_AFR.vcf.gz &

#echo "/home/hannah/vcftools-0.1.16/usr/local/bin/vcf-subset  -c ${PREFIX}/${CHR}/${CHR}_SAS.txt ${VCF}  | bgzip -c  > ${PREFIX}/${CHR}/${CHR}_SAS.vcf.gz "
#nohup  /home/hannah/vcftools-0.1.16/usr/local/bin/vcf-subset  -c ${PREFIX}/${CHR}/${CHR}_SAS.txt ${VCF} | bgzip -c  > ${PREFIX}/${CHR}/${CHR}_SAS.vcf.gz &
