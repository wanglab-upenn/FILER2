#!/bin/bash

while getopts dn:p:l: option
do
   case "$option" in
      d) DODEBUG=true;;      # option -d to print out commands
      p) PREFIX="$OPTARG";;
      l) CHR="$OPTARG";;
   esac
done

echo "/mnt/data/hannah/1kg_phase3/plink/plink --vcf ${PREFIX}/${CHR}/${CHR}_EUR.vcf.gz -make-bed --out ${PREFIX}/${CHR}/${CHR}_EUR.bed"
nohup  /mnt/data/hannah/1kg_phase3/plink/plink --vcf ${PREFIX}/${CHR}/${CHR}_EUR.vcf.gz -make-bed --out ${PREFIX}/${CHR}/${CHR}_EUR.bed &

echo "/mnt/data/hannah/1kg_phase3/plink/plink --vcf ${PREFIX}/${CHR}/${CHR}_AMR.vcf.gz -make-bed --out ${PREFIX}/${CHR}/${CHR}_AMR.bed"
nohup  /mnt/data/hannah/1kg_phase3/plink/plink --vcf ${PREFIX}/${CHR}/${CHR}_AMR.vcf.gz -make-bed --out ${PREFIX}/${CHR}/${CHR}_AMR.bed &

echo "/mnt/data/hannah/1kg_phase3/plink/plink --vcf ${PREFIX}/${CHR}/${CHR}_EAS.vcf.gz -make-bed --out ${PREFIX}/${CHR}/${CHR}_EAS.bed"
nohup  /mnt/data/hannah/1kg_phase3/plink/plink --vcf ${PREFIX}/${CHR}/${CHR}_EAS.vcf.gz -make-bed --out ${PREFIX}/${CHR}/${CHR}_EAS.bed &

echo "/mnt/data/hannah/1kg_phase3/plink/plink --vcf ${PREFIX}/${CHR}/${CHR}_AFR.vcf.gz -make-bed --out ${PREFIX}/${CHR}/${CHR}_AFR.bed"
nohup  /mnt/data/hannah/1kg_phase3/plink/plink --vcf ${PREFIX}/${CHR}/${CHR}_AFR.vcf.gz -make-bed --out ${PREFIX}/${CHR}/${CHR}_AFR.bed &

echo "/mnt/data/hannah/1kg_phase3/plink/plink --vcf ${PREFIX}/${CHR}/${CHR}_SAS.vcf.gz -make-bed --out ${PREFIX}/${CHR}/${CHR}_SAS.bed"
nohup  /mnt/data/hannah/1kg_phase3/plink/plink --vcf ${PREFIX}/${CHR}/${CHR}_SAS.vcf.gz -make-bed --out ${PREFIX}/${CHR}/${CHR}_SAS.bed &
