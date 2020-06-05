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

n=`zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}.vcf.gz | wc -l`
x=$((n-1))
gzip -dc ${PREFIX}/${CHR}/${CHR}_${GROUP}.vcf.gz |   sed "$x,\$d" - | gzip -c > ${PREFIX}/${CHR}/${CHR}_${GROUP}.vcf.gz.tmp
mv ${PREFIX}/${CHR}/${CHR}_${GROUP}.vcf.gz ${PREFIX}/${CHR}/${CHR}_${GROUP}.vcf.gz.0
mv ${PREFIX}/${CHR}/${CHR}_${GROUP}.vcf.gz.tmp ${PREFIX}/${CHR}/${CHR}_${GROUP}.vcf.gz




