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
 afr_snp=$(zcat ${PREFIX}/${CHR}/${CHR}_AFR_SNP.vcf.gz | head -n 1 | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f $i | grep "AFR_AF" | wc -l)
 amr_snp=$(zcat ${PREFIX}/${CHR}/${CHR}_AMR_SNP.vcf.gz | head -n 1 | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f $i | grep "AMR_AF" | wc -l)
 eas_snp=$(zcat ${PREFIX}/${CHR}/${CHR}_EAS_SNP.vcf.gz | head -n 1 | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f $i | grep "EAS_AF" | wc -l)
 eur_snp=$(zcat ${PREFIX}/${CHR}/${CHR}_EUR_SNP.vcf.gz | head -n 1 | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f $i | grep "EUR_AF" | wc -l)
 sas_snp=$(zcat ${PREFIX}/${CHR}/${CHR}_SAS_SNP.vcf.gz | head -n 1 | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f $i | grep "SAS_AF" | wc -l)

 if [ $afr_snp == '1' ]
 then
   echo "afr $"$i   >> ${PREFIX}/${CHR}/${CHR}_SNP.numline.txt
 elif [ $amr_snp == '1' ]
 then
   echo "amr $"$i   >> ${PREFIX}/${CHR}/${CHR}_SNP.numline.txt
 elif [ $eas_snp == '1' ]
 then
   echo "eas $"$i   >> ${PREFIX}/${CHR}/${CHR}_SNP.numline.txt
 elif [ $eur_snp == '1' ]
 then
   echo "eur $"$i   >> ${PREFIX}/${CHR}/${CHR}_SNP.numline.txt
 elif [ $sas_snp == '1' ]
 then
   echo "sas $"$i   >> ${PREFIX}/${CHR}/${CHR}_SNP.numline.txt
 fi
done

for i in 1 2 3 4 5 6 7 8 9 10 11; do
 afr_indel=$(zcat ${PREFIX}/${CHR}/${CHR}_AFR_INDEL.vcf.gz | head -n 1 | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f $i | grep "AFR_AF" | wc -l)
 amr_indel=$(zcat ${PREFIX}/${CHR}/${CHR}_AMR_INDEL.vcf.gz | head -n 1 | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f $i | grep "AMR_AF" | wc -l)
 eas_indel=$(zcat ${PREFIX}/${CHR}/${CHR}_EAS_INDEL.vcf.gz | head -n 1 | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f $i | grep "EAS_AF" | wc -l)
 eur_indel=$(zcat ${PREFIX}/${CHR}/${CHR}_EUR_INDEL.vcf.gz | head -n 1 | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f $i | grep "EUR_AF" | wc -l)
 sas_indel=$(zcat ${PREFIX}/${CHR}/${CHR}_SAS_INDEL.vcf.gz | head -n 1 | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f $i | grep "SAS_AF" | wc -l)

 if [ $afr_indel == '1' ]
 then
   echo "afr $"$i   >> ${PREFIX}/${CHR}/${CHR}_INDEL.numline.txt
 elif [ $amr_indel == '1' ]
 then
   echo "amr $"$i   >> ${PREFIX}/${CHR}/${CHR}_INDEL.numline.txt
 elif [ $eas_indel == '1' ]
 then
   echo "eas $"$i   >> ${PREFIX}/${CHR}/${CHR}_INDEL.numline.txt
 elif [ $eur_indel == '1' ]
 then
   echo "eur $"$i   >> ${PREFIX}/${CHR}/${CHR}_INDEL.numline.txt
 elif [ $sas_indel == '1' ]
 then
   echo "sas $"$i   >> ${PREFIX}/${CHR}/${CHR}_INDEL.numline.txt
 fi
done

for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17; do
 afr_sv=$(zcat ${PREFIX}/${CHR}/${CHR}_AFR_SV.vcf.gz | head -n 1 | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f $i | grep "AFR_AF" | wc -l)
 amr_sv=$(zcat ${PREFIX}/${CHR}/${CHR}_AMR_SV.vcf.gz | head -n 1 | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f $i | grep "AMR_AF" | wc -l)
 eas_sv=$(zcat ${PREFIX}/${CHR}/${CHR}_EAS_SV.vcf.gz | head -n 1 | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f $i | grep "EAS_AF" | wc -l)
 eur_sv=$(zcat ${PREFIX}/${CHR}/${CHR}_EUR_SV.vcf.gz | head -n 1 | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f $i | grep "EUR_AF" | wc -l)
 sas_sv=$(zcat ${PREFIX}/${CHR}/${CHR}_SAS_SV.vcf.gz | head -n 1 | awk  '{FS="\t";OFS="\t";print $8}' | cut -d ';' -f $i | grep "SAS_AF" | wc -l)

 if [ $afr_sv == '1' ]
 then
   echo "afr $"$i   >> ${PREFIX}/${CHR}/${CHR}_SV.numline.txt
 elif [ $amr_sv == '1' ]
 then
   echo "amr $"$i   >> ${PREFIX}/${CHR}/${CHR}_SV.numline.txt
 elif [ $eas_sv == '1' ]
 then
   echo "eas $"$i   >> ${PREFIX}/${CHR}/${CHR}_SV.numline.txt
 elif [ $eur_sv == '1' ]
 then
   echo "eur $"$i   >> ${PREFIX}/${CHR}/${CHR}_SV.numline.txt
 elif [ $sas_sv == '1' ]
 then
   echo "sas $"$i   >> ${PREFIX}/${CHR}/${CHR}_SV.numline.txt
 fi
done


afrsnp=$(grep 'afr' ${PREFIX}/${CHR}/${CHR}_SNP.numline.txt | awk  '{FS=" ";OFS=" ";print $2}')
afrindel=$(grep 'afr' ${PREFIX}/${CHR}/${CHR}_INDEL.numline.txt | awk  '{FS=" ";OFS=" ";print $2}')
afrsv=$(grep 'afr' ${PREFIX}/${CHR}/${CHR}_SV.numline.txt | awk  '{FS=" ";OFS=" ";print $2}')
#AFR
zcat ${PREFIX}/${CHR}/${CHR}_AFR_SNP.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s='$afrsnp'; sub("AFR_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_AFR_SNP.bed.gz
zcat ${PREFIX}/${CHR}/${CHR}_AFR_INDEL.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s='$afrindel'; sub("AFR_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_AFR_INDEL.bed.gz
zcat ${PREFIX}/${CHR}/${CHR}_AFR_SV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s='$afrsv'; sub("AFR_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_AFR_SV.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_AFR_CNV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s='$afrnum'; sub("AFR_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_AFR_CNV.bed.gz

amrsnp=$(grep 'amr' ${PREFIX}/${CHR}/${CHR}_SNP.numline.txt | awk  '{FS=" ";OFS=" ";print $2}')
amrindel=$(grep 'amr' ${PREFIX}/${CHR}/${CHR}_INDEL.numline.txt | awk  '{FS=" ";OFS=" ";print $2}')
amrsv=$(grep 'amr' ${PREFIX}/${CHR}/${CHR}_SV.numline.txt | awk  '{FS=" ";OFS=" ";print $2}')
#AMR
zcat ${PREFIX}/${CHR}/${CHR}_AMR_SNP.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s='$amrsnp'; sub("AMR_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_AMR_SNP.bed.gz
zcat ${PREFIX}/${CHR}/${CHR}_AMR_INDEL.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s='$amrindel'; sub("AMR_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_AMR_INDEL.bed.gz
zcat ${PREFIX}/${CHR}/${CHR}_AMR_SV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s='$amrsv'; sub("AMR_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_AMR_SV.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_AMR_CNV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s='$amrnum'; sub("AMR_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_AMR_CNV.bed.gz

eassnp=$(grep 'eas' ${PREFIX}/${CHR}/${CHR}_SNP.numline.txt | awk  '{FS=" ";OFS=" ";print $2}')
easindel=$(grep 'eas' ${PREFIX}/${CHR}/${CHR}_INDEL.numline.txt | awk  '{FS=" ";OFS=" ";print $2}')
eassv=$(grep 'eas' ${PREFIX}/${CHR}/${CHR}_SV.numline.txt | awk  '{FS=" ";OFS=" ";print $2}')
#EAS
zcat ${PREFIX}/${CHR}/${CHR}_EAS_SNP.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s='$eassnp'; sub("EAS_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_EAS_SNP.bed.gz
zcat ${PREFIX}/${CHR}/${CHR}_EAS_INDEL.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s='$easindel'; sub("EAS_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_EAS_INDEL.bed.gz
zcat ${PREFIX}/${CHR}/${CHR}_EAS_SV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s='$eassv'; sub("EAS_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_EAS_SV.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_EAS_CNV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s='$easnum'; sub("EAS_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_EAS_CNV.bed.gz

eursnp=$(grep 'eur' ${PREFIX}/${CHR}/${CHR}_SNP.numline.txt | awk  '{FS=" ";OFS=" ";print $2}')
eurindel=$(grep 'eur' ${PREFIX}/${CHR}/${CHR}_INDEL.numline.txt | awk  '{FS=" ";OFS=" ";print $2}')
eursv=$(grep 'eur' ${PREFIX}/${CHR}/${CHR}_SV.numline.txt | awk  '{FS=" ";OFS=" ";print $2}')
#EUR
zcat ${PREFIX}/${CHR}/${CHR}_EUR_SNP.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s='$eursnp'; sub("EUR_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_EUR_SNP.bed.gz
zcat ${PREFIX}/${CHR}/${CHR}_EUR_INDEL.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s='$eurindel'; sub("EUR_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_EUR_INDEL.bed.gz
zcat ${PREFIX}/${CHR}/${CHR}_EUR_SV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s='$eursv'; sub("EUR_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_EUR_SV.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_EUR_CNV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s='$eurnum'; sub("EUR_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_EUR_CNV.bed.gz

sassnp=$(grep 'sas' ${PREFIX}/${CHR}/${CHR}_SNP.numline.txt | awk  '{FS=" ";OFS=" ";print $2}')
sasindel=$(grep 'sas' ${PREFIX}/${CHR}/${CHR}_INDEL.numline.txt | awk  '{FS=" ";OFS=" ";print $2}')
sassv=$(grep 'sas' ${PREFIX}/${CHR}/${CHR}_SV.numline.txt | awk  '{FS=" ";OFS=" ";print $2}')
#SAS
zcat ${PREFIX}/${CHR}/${CHR}_SAS_SNP.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s='$sassnp'; sub("SAS_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_SAS_SNP.bed.gz
zcat ${PREFIX}/${CHR}/${CHR}_SAS_INDEL.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s='$sasindel'; sub("SAS_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip   > ${PREFIX}/${CHR}/${CHR}_SAS_INDEL.bed.gz
zcat ${PREFIX}/${CHR}/${CHR}_SAS_SV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s='$sassv'; sub("SAS_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip  > ${PREFIX}/${CHR}/${CHR}_SAS_SV.bed.gz
#zcat ${PREFIX}/${CHR}/${CHR}_SAS_CNV.vcf.gz | awk '{FS="\t";OFS="\t";print "chr"$1,$2-1,$2,"chr22:"$2-1"-"$2":"$4">"$5,$8,".",$3,$4,$5,$6,$7,$8,$9,$RS, etc}' | cut -f1-13,23- |  awk 'BEGIN {FS=OFS=";" } {s='$sasnum'; sub("SAS_AF=", "", s); print $1"\t"s"\t"$RS  }' | cut -f1-4,6,12- | sed -r 's/\t$//' | bgzip  > ${PREFIX}/${CHR}/${CHR}_SAS_CNV.bed.gz




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
