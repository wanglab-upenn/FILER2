#!/bin/bash

while getopts dn:g:p:l: option
do
   case "$option" in
      d) DODEBUG=true;;      # option -d to print out commands
      g) GROUP="$OPTARG";;
      p) PREFIX="$OPTARG";;
      l) CHR="$OPTARG";;
   esac
done

zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}.vcf.gz |  grep -v "^#" | awk '{FS="\t";OFS="\t";print $1,$2-1,$2,$3,$4,$5, etc}' > ${PREFIX}/${CHR}/${CHR}_${GROUP}.bed






