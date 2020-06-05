#!/bin/bash

while getopts dn:g:l:p: option
do
   case "$option" in
      d) DODEBUG=true;;      # option -d to print out commands
      l) CHR="$OPTARG";;
      p) PREFIX="$OPTARG";;
   esac
done

/mnt/data/hannah/1kg_phase3/vcf_split_vt_mt.sh -l ${CHR} -g AFR -p ${PREFIX}
/mnt/data/hannah/1kg_phase3/vcf_split_vt_mt.sh -l ${CHR} -g AMR -p ${PREFIX}
/mnt/data/hannah/1kg_phase3/vcf_split_vt_mt.sh -l ${CHR} -g EAS -p ${PREFIX}
/mnt/data/hannah/1kg_phase3/vcf_split_vt_mt.sh -l ${CHR} -g EUR -p ${PREFIX}
/mnt/data/hannah/1kg_phase3/vcf_split_vt_mt.sh -l ${CHR} -g SAS -p ${PREFIX}
