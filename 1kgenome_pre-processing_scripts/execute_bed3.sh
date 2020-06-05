#!/bin/bash

while getopts dn:p:l: option
do
   case "$option" in
      d) DODEBUG=true;;      # option -d to print out commands
      p) PREFIX="$OPTARG";;
      l) CHR="$OPTARG";;
   esac
done

#awk -v n=9 '{ for(i=n+1;i<=NF;i++) printf("%s%s",$i,i==NF?RS:OFS);}'
#| grep -v "^#" | awk  '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,"0",".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | awk ' { $14=""; $15=""; $16=""; $17=""; $18=""; $19=""; $20=""; $21=""; $22=""; print $0 }'
#awk  '{FS="\t";OFS="\t";print $21}' | head -n 3 | cut -d ';' -f 4 | cut -d '=' -f 2
# grep -v "^#" | awk  '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,"0",".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' |  head -n 3 | awk ' { $14=""; $15=""; $16=""; $17=""; $18=""; $19=""; $20=""; $21=""; $22=""; print $0 }' |  sed 's/\x0//g'

#zcat ${PREFIX}/${CHR}/${CHR}_AFR_SNP.vcf.gz | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f 4 > ${PREFIX}/${CHR}/${CHR}_AFR_SNP_score.txt
#zcat ${PREFIX}/${CHR}/${CHR}_AMR_SNP.vcf.gz | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f 5 > ${PREFIX}/${CHR}/${CHR}_AMR_SNP_score.txt
#zcat ${PREFIX}/${CHR}/${CHR}_EAS_SNP.vcf.gz | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f 8 > ${PREFIX}/${CHR}/${CHR}_EAS_SNP_score.txt
#zcat ${PREFIX}/${CHR}/${CHR}_EUR_SNP.vcf.gz | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f 9 > ${PREFIX}/${CHR}/${CHR}_EUR_SNP_score.txt
#zcat ${PREFIX}/${CHR}/${CHR}_SAS_SNP.vcf.gz | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f 11 > ${PREFIX}/${CHR}/${CHR}_SAS_SNP_score.txt

#zcat ${PREFIX}/${CHR}/${CHR}_AFR_INDEL.vcf.gz | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f 4 > ${PREFIX}/${CHR}/${CHR}_AFR_INDEL_score.txt
#zcat ${PREFIX}/${CHR}/${CHR}_AMR_INDEL.vcf.gz | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f 5 > ${PREFIX}/${CHR}/${CHR}_AMR_INDEL_score.txt
#zcat ${PREFIX}/${CHR}/${CHR}_EAS_INDEL.vcf.gz | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f 8 > ${PREFIX}/${CHR}/${CHR}_EAS_INDEL_score.txt
#zcat ${PREFIX}/${CHR}/${CHR}_EUR_INDEL.vcf.gz | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f 9 > ${PREFIX}/${CHR}/${CHR}_EUR_INDEL_score.txt
#zcat ${PREFIX}/${CHR}/${CHR}_SAS_INDEL.vcf.gz | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f 11 > ${PREFIX}/${CHR}/${CHR}_SAS_INDEL_score.txt

#zcat ${PREFIX}/${CHR}/${CHR}_AFR_SV.vcf.gz | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f 4 > ${PREFIX}/${CHR}/${CHR}_AFR_SV_score.txt
#zcat ${PREFIX}/${CHR}/${CHR}_AMR_SV.vcf.gz | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f 5 > ${PREFIX}/${CHR}/${CHR}_AMR_SV_score.txt
#zcat ${PREFIX}/${CHR}/${CHR}_EAS_SV.vcf.gz | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f 8 > ${PREFIX}/${CHR}/${CHR}_EAS_SV_score.txt
#zcat ${PREFIX}/${CHR}/${CHR}_EUR_SV.vcf.gz | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f 9 > ${PREFIX}/${CHR}/${CHR}_EUR_SV_score.txt
#zcat ${PREFIX}/${CHR}/${CHR}_SAS_SV.vcf.gz | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f 11 > ${PREFIX}/${CHR}/${CHR}_SAS_SV_score.txt

#zcat ${PREFIX}/${CHR}/${CHR}_AFR_CNV.vcf.gz | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f 4 > ${PREFIX}/${CHR}/${CHR}_AFR_CNV_score.txt
#zcat ${PREFIX}/${CHR}/${CHR}_AMR_CNV.vcf.gz | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f 5 > ${PREFIX}/${CHR}/${CHR}_AMR_CNV_score.txt
#zcat ${PREFIX}/${CHR}/${CHR}_EAS_CNV.vcf.gz | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f 8 > ${PREFIX}/${CHR}/${CHR}_EAS_CNV_score.txt
#zcat ${PREFIX}/${CHR}/${CHR}_EUR_CNV.vcf.gz | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f 9 > ${PREFIX}/${CHR}/${CHR}_EUR_CNV_score.txt
#zcat ${PREFIX}/${CHR}/${CHR}_SAS_CNV.vcf.gz | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f 11 > ${PREFIX}/${CHR}/${CHR}_SAS_CNV_score.txt



#zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP.vcf.gz | awk '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' |  cut -f1-13, 23- > ${PREFIX}/${CHR}/${CHR}_${GROUP}_SNP.bed
#zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL.vcf.gz | awk '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' |  cut -f1-13, 23- > ${PREFIX}/${CHR}/${CHR}_${GROUP}_INDEL.bed
#zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_SV.vcf.gz | awk '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' |  cut -f1-13, 23- > ${PREFIX}/${CHR}/${CHR}_${GROUP}_SV.bed
#zcat ${PREFIX}/${CHR}/${CHR}_${GROUP}_CNV.vcf.gz | awk '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' |  cut -f1-13, 23- > ${PREFIX}/${CHR}/${CHR}_${GROUP}_CNV.bed


#awk 'BEGIN {FS=OFS=";" } {s=$4; sub("AFR_AF=", "", s); FS="\t";OFS="\t";  print $1,s,$RS }' 22_AFR_SNP.bed | cut -f1-4,6,12-19,29-

#AFR
zcat ${PREFIX}/${CHR}/${CHR}_AFR_SNP.vcf.gz | awk 'BEGIN {FS=OFS=";" } {s=$4; sub("AFR_AF=", "", s); FS="\t";OFS="\t"; print $1,s,$RS }'  | awk  '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$9,".",$3,$4,$5,$6,$7,$17,$18,$RS, etc}' | cut -f1-13,32- > ${PREFIX}/${CHR}/${CHR}_AFR_SNP.bed
#zcat ${PREFIX}/${CHR}/${CHR}_AFR_INDEL.vcf.gz | awk 'BEGIN {FS=OFS=";" } {s=$4; sub("AFR_AF=", "", s); FS="\t";OFS="\t";  print $1,s,$RS }'  |  awk  '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$9,".",$3,$4,$5,$6,$7,$17,$18,$RS, etc}' | cut -f1-13,32- > ${PREFIX}/${CHR}/${CHR}_AFR_INDEL.bed
#zcat ${PREFIX}/${CHR}/${CHR}_AFR_SV.vcf.gz | awk 'BEGIN {FS=OFS=";" } {s=$4; sub("AFR_AF=", "", s); FS="\t";OFS="\t";  print $1,s,$RS }'  |  awk  '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$9,".",$3,$4,$5,$6,$7,$17,$18,$RS, etc}' | cut -f1-13,32- > ${PREFIX}/${CHR}/${CHR}_AFR_SV.bed
#zcat ${PREFIX}/${CHR}/${CHR}_AFR_CNV.vcf.gz | awk 'BEGIN {FS=OFS=";" } {s=$4; sub("AFR_AF=", "", s); FS="\t";OFS="\t";  print $1,s,$RS }'  |  awk  '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$9,".",$3,$4,$5,$6,$7,$17,$18,$RS, etc}' | cut -f1-13,32- > ${PREFIX}/${CHR}/${CHR}_AFR_CNV.bed


#AMR
#zcat ${PREFIX}/${CHR}/${CHR}_AMR_SNP.vcf.gz | awk 'BEGIN {FS=OFS=";" } {s=$5; sub("AMR_AF=", "", s); FS="\t";OFS="\t";  print $1,s,$RS }'  | awk  '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$9,".",$3,$4,$5,$6,$7,$17,$18,$RS, etc}' | cut -f1-13,32- > ${PREFIX}/${CHR}/${CHR}_AMR_SNP.bed
#zcat ${PREFIX}/${CHR}/${CHR}_AMR_INDEL.vcf.gz | awk 'BEGIN {FS=OFS=";" } {s=$5; sub("AMR_AF=", "", s); FS="\t";OFS="\t";  print $1,s,$RS }'  | awk  '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$9,".",$3,$4,$5,$6,$7,$17,$18,$RS, etc}' | cut -f1-13,32- > ${PREFIX}/${CHR}/${CHR}_AMR_INDEL.bed
#zcat ${PREFIX}/${CHR}/${CHR}_AMR_SV.vcf.gz | awk 'BEGIN {FS=OFS=";" } {s=$5; sub("AMR_AF=", "", s); FS="\t";OFS="\t";  print $1,s,$RS }'  | awk  '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$9,".",$3,$4,$5,$6,$7,$17,$18,$RS, etc}' | cut -f1-13,32- > ${PREFIX}/${CHR}/${CHR}_AMR_SV.bed
#zcat ${PREFIX}/${CHR}/${CHR}_AMR_CNV.vcf.gz | awk 'BEGIN {FS=OFS=";" } {s=$5; sub("AMR_AF=", "", s); FS="\t";OFS="\t";  print $1,s,$RS }'  | awk  '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$9,".",$3,$4,$5,$6,$7,$17,$18,$RS, etc}' | cut -f1-13,32- > ${PREFIX}/${CHR}/${CHR}_AMR_CNV.bed

#EAS
#zcat ${PREFIX}/${CHR}/${CHR}_EAS_SNP.vcf.gz | awk 'BEGIN {FS=OFS=";" } {s=$8; sub("EAS_AF=", "", s); FS="\t";OFS="\t";  print $1,s,$RS }'  | awk  '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$9,".",$3,$4,$5,$6,$7,$17,$18,$RS, etc}' | cut -f1-13,32- > ${PREFIX}/${CHR}/${CHR}_EAS_SNP.bed
#zcat ${PREFIX}/${CHR}/${CHR}_EAS_INDEL.vcf.gz | awk 'BEGIN {FS=OFS=";" } {s=$8; sub("EAS_AF=", "", s); FS="\t";OFS="\t";  print $1,s,$RS }'  | awk  '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$9,".",$3,$4,$5,$6,$7,$17,$18,$RS, etc}' | cut -f1-13,32- > ${PREFIX}/${CHR}/${CHR}_EAS_INDEL.bed
#zcat ${PREFIX}/${CHR}/${CHR}_EAS_SV.vcf.gz | awk 'BEGIN {FS=OFS=";" } {s=$8; sub("EAS_AF=", "", s); FS="\t";OFS="\t";  print $1,s,$RS }'  | awk  '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$9,".",$3,$4,$5,$6,$7,$17,$18,$RS, etc}' | cut -f1-13,32- > ${PREFIX}/${CHR}/${CHR}_EAS_SV.bed
#zcat ${PREFIX}/${CHR}/${CHR}_EAS_CNV.vcf.gz | awk 'BEGIN {FS=OFS=";" } {s=$8; sub("EAS_AF=", "", s); FS="\t";OFS="\t";  print $1,s,$RS }'  | awk  '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$9,".",$3,$4,$5,$6,$7,$17,$18,$RS, etc}' | cut -f1-13,32- > ${PREFIX}/${CHR}/${CHR}_EAS_CNV.bed

#EUR
#zcat ${PREFIX}/${CHR}/${CHR}_EUR_SNP.vcf.gz | awk 'BEGIN {FS=OFS=";" } {s=$9; sub("EUR_AF=", "", s); FS="\t";OFS="\t";  print $1,s,$RS }'  | awk  '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$9,".",$3,$4,$5,$6,$7,$17,$18,$RS, etc}' | cut -f1-13,32- > ${PREFIX}/${CHR}/${CHR}_EUR_SNP.bed
#zcat ${PREFIX}/${CHR}/${CHR}_EUR_INDEL.vcf.gz | awk 'BEGIN {FS=OFS=";" } {s=$9; sub("EUR_AF=", "", s); FS="\t";OFS="\t";  print $1,s,$RS }'  | awk  '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$9,".",$3,$4,$5,$6,$7,$17,$18,$RS, etc}' | cut -f1-13,32- > ${PREFIX}/${CHR}/${CHR}_EUR_INDEL.bed
#zcat ${PREFIX}/${CHR}/${CHR}_EUR_SV.vcf.gz | awk 'BEGIN {FS=OFS=";" } {s=$9; sub("EUR_AF=", "", s); FS="\t";OFS="\t";  print $1,s,$RS }'  | awk  '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$9,".",$3,$4,$5,$6,$7,$17,$18,$RS, etc}' | cut -f1-13,32- > ${PREFIX}/${CHR}/${CHR}_EUR_SV.bed
#zcat ${PREFIX}/${CHR}/${CHR}_EUR_CNV.vcf.gz | awk 'BEGIN {FS=OFS=";" } {s=$9; sub("EUR_AF=", "", s); FS="\t";OFS="\t";  print $1,s,$RS }'  | awk  '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$9,".",$3,$4,$5,$6,$7,$17,$18,$RS, etc}' | cut -f1-13,32- > ${PREFIX}/${CHR}/${CHR}_EUR_CNV.bed

#SAS
#zcat ${PREFIX}/${CHR}/${CHR}_SAS_SNP.vcf.gz | awk 'BEGIN {FS=OFS=";" } {s=$11; sub("SAS_AF=", "", s); FS="\t";OFS="\t";  print $1,s,$RS }'  | awk  '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$9,".",$3,$4,$5,$6,$7,$17,$18,$RS, etc}' | cut -f1-13,32- > ${PREFIX}/${CHR}/${CHR}_SAS_SNP.bed
#zcat ${PREFIX}/${CHR}/${CHR}_SAS_INDEL.vcf.gz | awk 'BEGIN {FS=OFS=";" } {s=$11; sub("SAS_AF=", "", s); FS="\t";OFS="\t";  print $1,s,$RS }'  | awk  '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$9,".",$3,$4,$5,$6,$7,$17,$18,$RS, etc}' | cut -f1-13,32- > ${PREFIX}/${CHR}/${CHR}_SAS_INDEL.bed
#zcat ${PREFIX}/${CHR}/${CHR}_SAS_SV.vcf.gz | awk 'BEGIN {FS=OFS=";" } {s=$11; sub("SAS_AF=", "", s); FS="\t";OFS="\t";  print $1,s,$RS }'  | awk  '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$9,".",$3,$4,$5,$6,$7,$17,$18,$RS, etc}' | cut -f1-13,32- > ${PREFIX}/${CHR}/${CHR}_SAS_SV.bed
#zcat ${PREFIX}/${CHR}/${CHR}_SAS_CNV.vcf.gz | awk 'BEGIN {FS=OFS=";" } {s=$11; sub("SAS_AF=", "", s); FS="\t";OFS="\t";  print $1,s,$RS }'  | awk  '{FS="\t";OFS="\t";print $1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$9,".",$3,$4,$5,$6,$7,$17,$18,$RS, etc}' | cut -f1-13,32- > ${PREFIX}/${CHR}/${CHR}_SAS_CNV.bed

tabix -p bed  ${PREFIX}/${CHR}/${CHR}_AFR_SNP.bed

