
BCFTOOLS=/mnt/data/bin/bcftools-1.9/bin/bcftools 
if [ ! -x "${BCFTOOLS}" ]; then
    echo "bcftools not found"
	exit 1
fi

genome=hg38
#genome=hg38
#for chrNum in {5..22}; do
#for chrNum in X Y; do
#for chrNum in {1..22}; do
for chrNum in {1..22} X Y; do
   vcf_ids=ids.biallelic_vcf.${genome}.${chrNum}
   bed_ids=ids.bed.${genome}.${chrNum}

   # extract variant IDs from original VCF
   if [ ! -s "${vcf_ids}" ]; then
     zgrep -v "^#" newVCF${genome}/${chrNum}/${chrNum}_EUR_SNP_biallelic.vcf.gz | cut -f 3 | sort -u > "${vcf_ids}"
   else
	 echo "Skipping ${vcf_ids}"
   fi


   # extract and collect variant IDs from BED
   for f in newVCF${genome}/${chrNum}/pop/${chrNum}_CEU_SNP_biallelic.bed.gz; do
      zcat "${f}" | cut -f 4
   done | sort -u > "${bed_ids}" 

   if ! cmp "${bed_ids}" "${vcf_ids}" > /dev/null 2>&1; then
	   echo "ERROR: chr$chrNum: subpopulation and population are not the same "
   fi
   ndiff=$(comm -1 -3 "${bed_ids}" "${vcf_ids}" | wc -l) # in vcf, not in bed
   echo -e "${chrNum}\t${ndiff}"
done
