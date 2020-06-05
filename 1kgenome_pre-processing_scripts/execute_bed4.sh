#!/bin/bash

while getopts dn:p:l: option
do
   case "$option" in
      d) DODEBUG=true;;      # option -d to print out commands
      p) PREFIX="$OPTARG";;
      l) CHR="$OPTARG";;
   esac
done

for i in 1 2 3 4 5 6 7 8 9 10 11 12; do
 afr_col=$(zcat ${PREFIX}/${CHR}/${CHR}_AFR_SNP.vcf.gz | head -n 1 | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f $i | grep "AFR_AF" | wc -l)
 amr_col=$(zcat ${PREFIX}/${CHR}/${CHR}_AMR_SNP.vcf.gz | head -n 1 | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f $i | grep "AMR_AF" | wc -l)
 eas_col=$(zcat ${PREFIX}/${CHR}/${CHR}_EAS_SNP.vcf.gz | head -n 1 | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f $i | grep "EAS_AF" | wc -l)
 eur_col=$(zcat ${PREFIX}/${CHR}/${CHR}_EUR_SNP.vcf.gz | head -n 1 | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f $i | grep "EUR_AF" | wc -l)
 sas_col=$(zcat ${PREFIX}/${CHR}/${CHR}_SAS_SNP.vcf.gz | head -n 1 | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f $i | grep "SAS_AF" | wc -l)

 if [ $afr_col == '1' ]
 then
   echo "afr $"$i   >> ${PREFIX}/${CHR}/${CHR}_VT.numline.txt
 elif [ $amr_col == '1' ]
 then
   echo "amr $"$i   >> ${PREFIX}/${CHR}/${CHR}_VT.numline.txt
 elif [ $eas_col == '1' ]
 then
   echo "eas $"$i   >> ${PREFIX}/${CHR}/${CHR}_VT.numline.txt
 elif [ $eur_col == '1' ]
 then
   echo "eur $"$i   >> ${PREFIX}/${CHR}/${CHR}_VT.numline.txt
 elif [ $sas_col == '1' ]
 then
   echo "sas $"$i   >> ${PREFIX}/${CHR}/${CHR}_VT.numline.txt
 fi
done

afrnum=$(grep 'afr' ${PREFIX}/${CHR}/${CHR}_VT.numline.txt | cut -d ' ' -f3)
#AFR
zcat ${PREFIX}/${CHR}/${CHR}_AFR_SNP.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s=$afrnum; sub("AFR_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_AFR_SNP.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_AFR_INDEL.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s=$afrnum; sub("AFR_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_AFR_INDEL.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_AFR_SV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s=$afrnum; sub("AFR_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_AFR_SV.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_AFR_CNV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s=$afrnum; sub("AFR_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_AFR_CNV.bed.gz

amrnum=$(grep 'amr' ${PREFIX}/${CHR}/${CHR}_VT.numline.txt | cut -d ' ' -f3)
#AMR
zcat ${PREFIX}/${CHR}/${CHR}_AMR_SNP.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s=$amrnum; sub("AMR_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_AMR_SNP.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_AMR_INDEL.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s=$amrnum; sub("AMR_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_AMR_INDEL.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_AMR_SV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s=$amrnum; sub("AMR_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_AMR_SV.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_AMR_CNV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s=$amrnum; sub("AMR_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_AMR_CNV.bed.gz

easnum=$(grep 'eas' ${PREFIX}/${CHR}/${CHR}_VT.numline.txt | cut -d ' ' -f3)
#EAS
zcat ${PREFIX}/${CHR}/${CHR}_EAS_SNP.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s=$easnum; sub("EAS_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_EAS_SNP.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_EAS_INDEL.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s=$easnum; sub("EAS_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_EAS_INDEL.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_EAS_SV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s=$easnum; sub("EAS_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_EAS_SV.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_EAS_CNV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s=$easnum; sub("EAS_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_EAS_CNV.bed.gz

eurnum=$(grep 'eur' ${PREFIX}/${CHR}/${CHR}_VT.numline.txt | cut -d ' ' -f3)
#EUR
zcat ${PREFIX}/${CHR}/${CHR}_EUR_SNP.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s=$eurnum; sub("EUR_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_EUR_SNP.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_EUR_INDEL.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s=$eurnum; sub("EUR_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_EUR_INDEL.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_EUR_SV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s=$eurnum; sub("EUR_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_EUR_SV.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_EUR_CNV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s=$eurnum; sub("EUR_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_EUR_CNV.bed.gz

sasnum=$(grep 'sas' ${PREFIX}/${CHR}/${CHR}_VT.numline.txt | cut -d ' ' -f3)
#SAS
zcat ${PREFIX}/${CHR}/${CHR}_SAS_SNP.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s=$sasnum; sub("SAS_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_SAS_SNP.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_SAS_INDEL.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s=$sasnum; sub("SAS_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_SAS_INDEL.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_SAS_SV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s=$sasnum; sub("SAS_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip  > ${PREFIX}/${CHR}/${CHR}_SAS_SV.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_SAS_CNV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s=$sasnum; sub("SAS_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip  > ${PREFIX}/${CHR}/${CHR}_SAS_CNV.bed.gz




#tabix -p bed  ${PREFIX}/${CHR}/${CHR}_AFR_SNP.bed.gz
#tabix -p bed  ${PREFIX}/${CHR}/${CHR}_AFR_INDEL.bed.gz
#tabix -p bed  ${PREFIX}/${CHR}/${CHR}_AFR_SV.bed.gz
#tabix -p bed  ${PREFIX}/${CHR}/${CHR}_AFR_CNV.bed.gz

#tabix -p bed  ${PREFIX}/${CHR}/${CHR}_AMR_SNP.bed.gz
#tabix -p bed  ${PREFIX}/${CHR}/${CHR}_AMR_INDEL.bed.gz
#tabix -p bed  ${PREFIX}/${CHR}/${CHR}_AMR_SV.bed.gz
#tabix -p bed  ${PREFIX}/${CHR}/${CHR}_AMR_CNV.bed.gz

#tabix -p bed  ${PREFIX}/${CHR}/${CHR}_EAS_SNP.bed.gz
#tabix -p bed  ${PREFIX}/${CHR}/${CHR}_EAS_INDEL.bed.gz
#tabix -p bed  ${PREFIX}/${CHR}/${CHR}_EAS_SV.bed.gz
#tabix -p bed  ${PREFIX}/${CHR}/${CHR}_EAS_CNV.bed.gz

#tabix -p bed  ${PREFIX}/${CHR}/${CHR}_EUR_SNP.bed.gz
#tabix -p bed  ${PREFIX}/${CHR}/${CHR}_EUR_INDEL.bed.gz
#tabix -p bed  ${PREFIX}/${CHR}/${CHR}_EUR_SV.bed.gz
#tabix -p bed  ${PREFIX}/${CHR}/${CHR}_EUR_CNV.bed.gz

#tabix -p bed  ${PREFIX}/${CHR}/${CHR}_SAS_SNP.bed.gz
#tabix -p bed  ${PREFIX}/${CHR}/${CHR}_SAS_INDEL.bed.gz
#tabix -p bed  ${PREFIX}/${CHR}/${CHR}_SAS_SV.bed.gz
#tabix -p bed  ${PREFIX}/${CHR}/${CHR}_SAS_CNV.bed.gz
