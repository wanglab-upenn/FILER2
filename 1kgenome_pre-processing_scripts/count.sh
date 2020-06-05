#!/bin/bash

while getopts dn:i:p: option
do
   case "$option" in
      d) DODEBUG=true;;      # option -d to print out commands
      i) VCF="$OPTARG";;
      p) PREFIX="$OPTARG";;
   esac
done
/mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view ${VCF} | grep "VT=SNP" | wc -l    >> ${PREFIX}/SNP_NUM.txt
/mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view ${VCF} | grep "VT=INDEL" | wc -l  >> ${PREFIX}/INDEL_NUM.txt
/mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view ${VCF} | grep "VT=SV" | wc -l  >> ${PREFIX}/SV_NUM.txt
/mnt/data/hannah/1kg_phase3/bcftools-1.9/bcftools view ${VCF} | grep "VT=CNV" | wc -l  >> ${PREFIX}/CNV_NUM.txt
