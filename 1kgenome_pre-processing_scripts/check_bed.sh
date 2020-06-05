#!/bin/bash

while getopts dn:p:l: option
do
   case "$option" in
      d) DODEBUG=true;;      # option -d to print out commands
      p) PREFIX="$OPTARG";;
      l) CHR="$OPTARG";;
   esac
done

#AFR
if [ $(zcat ${PREFIX}/${CHR}/${CHR}_AFR_SNP.bed.gz | awk '{FS="\t";OFS="\t";print $7}' | grep "\." | wc -l) != "0" ]
then
   echo "need to check ${PREFIX}/${CHR}/${CHR}_AFR_SNP.bed.gz" >> check_status.txt
fi

if [ $(zcat ${PREFIX}/${CHR}/${CHR}_AFR_INDEL.bed.gz | awk '{FS="\t";OFS="\t";print $7}' | grep "\." | wc -l) != "0" ]
then
   echo "need to check ${PREFIX}/${CHR}/${CHR}_AFR_INDEL.bed.gz" >> check_status.txt
fi

if [ $(zcat ${PREFIX}/${CHR}/${CHR}_AFR_SV.bed.gz | awk '{FS="\t";OFS="\t";print $7}' | grep "\." | wc -l) != "0" ]
then
   echo "${PREFIX}/${CHR}/${CHR}_AFR_SV.bed.gz" >> check_status.txt
fi

#AMR
if [ $(zcat ${PREFIX}/${CHR}/${CHR}_AMR_SNP.bed.gz |  awk '{FS="\t";OFS="\t";print $7}' | grep "\." | wc -l) != "0" ]
then
   echo "${PREFIX}/${CHR}/${CHR}_AMR_SNP.bed.gz" >> check_status.txt
fi

if [ $(zcat ${PREFIX}/${CHR}/${CHR}_AMR_INDEL.bed.gz | awk '{FS="\t";OFS="\t";print $7}' | grep "\." | wc -l) != "0" ]
then
   echo "${PREFIX}/${CHR}/${CHR}_AMR_INDEL.bed.gz" >> check_status.txt
fi

if [ $(zcat ${PREFIX}/${CHR}/${CHR}_AMR_SV.bed.gz | awk '{FS="\t";OFS="\t";print $7}' | grep "\." | wc -l) != "0" ]
then
   echo "${PREFIX}/${CHR}/${CHR}_AMR_SV.bed.gz" >> check_status.txt
fi


#EAS
if [ $(zcat ${PREFIX}/${CHR}/${CHR}_EAS_SNP.bed.gz | awk '{FS="\t";OFS="\t";print $7}' | grep "\." | wc -l) != "0" ]
then
   echo "${PREFIX}/${CHR}/${CHR}_EAS_SNP.bed.gz" >> check_status.txt
fi

if [ $(zcat ${PREFIX}/${CHR}/${CHR}_EAS_INDEL.bed.gz | awk '{FS="\t";OFS="\t";print $7}' | grep "\." | wc -l) != "0" ]
then
   echo "${PREFIX}/${CHR}/${CHR}_EAS_INDEL.bed.gz" >> check_status.txt
fi

if [ $(zcat ${PREFIX}/${CHR}/${CHR}_EAS_SV.bed.gz | awk '{FS="\t";OFS="\t";print $7}' | grep "\." | wc -l) != "0" ]
then
   echo "${PREFIX}/${CHR}/${CHR}_EAS_SV.bed.gz" >> check_status.txt
fi


#EUR
if [ $(zcat ${PREFIX}/${CHR}/${CHR}_EUR_SNP.bed.gz | awk '{FS="\t";OFS="\t";print $7}' | grep "\." | wc -l) != "0" ]
then
   echo "${PREFIX}/${CHR}/${CHR}_EUR_SNP.bed.gz" >> check_status.txt
fi
if [ $(zcat ${PREFIX}/${CHR}/${CHR}_EUR_INDEL.bed.gz | awk '{FS="\t";OFS="\t";print $7}' | grep "\." | wc -l) != "0" ]
then
   echo "${PREFIX}/${CHR}/${CHR}_EUR_INDEL.bed.gz" >> check_status.txt
fi
if [ $(zcat ${PREFIX}/${CHR}/${CHR}_EUR_SV.bed.gz | awk '{FS="\t";OFS="\t";print $7}' | grep "\." | wc -l) != "0" ]
then
   echo "${PREFIX}/${CHR}/${CHR}_EUR_SV.bed.gz" >> check_status.txt
fi

#SAS
if [ $(zcat ${PREFIX}/${CHR}/${CHR}_SAS_SNP.bed.gz | awk '{FS="\t";OFS="\t";print $7}' | grep "\." | wc -l) != "0" ]
then
   echo "${PREFIX}/${CHR}/${CHR}_SAS_SNP.bed.gz" >> check_status.txt
fi
if [ $(zcat ${PREFIX}/${CHR}/${CHR}_SAS_INDEL.bed.gz | awk '{FS="\t";OFS="\t";print $7}' | grep "\." | wc -l) != "0" ]
then
   echo "${PREFIX}/${CHR}/${CHR}_SAS_INDEL.bed.gz" >> check_status.txt
fi
if [ $(zcat ${PREFIX}/${CHR}/${CHR}_SAS_SV.bed.gz | awk '{FS="\t";OFS="\t";print $7}' | grep "\." | wc -l) != "0" ]
then
   echo "${PREFIX}/${CHR}/${CHR}_SAS_SV.bed.gz" >> check_status.txt
fi
