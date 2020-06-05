#!/bin/bash

while getopts dn:i:p:l: option
do
   case "$option" in
      d) DODEBUG=true;;      # option -d to print out commands
      i) VCF="$OPTARG";;
      p) PREFIX="$OPTARG";;
      l) CHR="$OPTARG";;
   esac
done

echo "/mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view --force-samples --samples-file ${PREFIX}/${CHR}/${CHR}_EUR.txt --output-file ${PREFIX}/${CHR}/${CHR}_EUR.vcf.gz --output-type  z ${VCF} "
nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view --force-samples --samples-file ${PREFIX}/${CHR}/${CHR}_EUR.txt --output-file ${PREFIX}/${CHR}/${CHR}_EUR.vcf.gz  --output-type z ${VCF} &

echo "/mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view --force-samples --samples-file ${PREFIX}/${CHR}/${CHR}_AMR.txt --output-file ${PREFIX}/${CHR}/${CHR}_AMR.vcf.gz  --output-type z ${VCF}"
nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view --force-samples --samples-file ${PREFIX}/${CHR}/${CHR}_AMR.txt --output-file ${PREFIX}/${CHR}/${CHR}_AMR.vcf.gz  --output-type z ${VCF} &

echo "/mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view --force-samples --samples-file ${PREFIX}/${CHR}/${CHR}_EAS.txt --output-file ${PREFIX}/${CHR}/${CHR}_EAS.vcf.gz  --output-type z ${VCF}"
nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view --force-samples --samples-file ${PREFIX}/${CHR}/${CHR}_EAS.txt --output-file ${PREFIX}/${CHR}/${CHR}_EAS.vcf.gz  --output-type z ${VCF} &

echo "/mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view --force-samples --samples-file ${PREFIX}/${CHR}/${CHR}_AFR.txt --output-file ${PREFIX}/${CHR}/${CHR}_AFR.vcf.gz  --output-type z ${VCF}"
nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view --force-samples --samples-file ${PREFIX}/${CHR}/${CHR}_AFR.txt --output-file ${PREFIX}/${CHR}/${CHR}_AFR.vcf.gz  --output-type z ${VCF} &

echo "/mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view --force-samples --samples-file ${PREFIX}/${CHR}/${CHR}_AFR.txt --output-file ${PREFIX}/${CHR}/${CHR}_AFR.vcf.gz  --output-type z ${VCF}"
nohup /mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view --force-samples --samples-file ${PREFIX}/${CHR}/${CHR}_SAS.txt --output-file ${PREFIX}/${CHR}/${CHR}_SAS.vcf.gz  --output-type z ${VCF} &


