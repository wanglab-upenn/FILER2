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
   echo "Check ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}.vcf.gz " >> ${PREFIX}/${CHR}/pop/status.txt
   zcat ${PREFIX}/${CHR}/pop/${CHR}_${GROUP}.vcf.gz | grep -v "^#" | wc -l >>  ${PREFIX}/${CHR}/pop/pop_status.txt
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
