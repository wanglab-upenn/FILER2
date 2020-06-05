
BCFTOOLS=/mnt/data/bin/bcftools-1.9/bin/bcftools 
if [ ! -x "${BCFTOOLS}" ]; then
    echo "bcftools not found"
	exit 1
fi

genome=hg19
#genome=hg38
#for chrNum in {5..22}; do
#for chrNum in X Y; do
#for chrNum in {1..22}; do
for vcf in raw_hg19/ALL.chrX.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.vcf.gz raw_hg19/ALL.chrY.phase3_integrated_v2a.20130502.genotypes.vcf.gz; do
   chrNum=$( echo "${vcf}" | awk '{gsub(/^.+\/ALL\.chr/,""); gsub(/\..+$/,""); print $0}' )
   raw_ids=ids.raw.${genome}.${chrNum}
   super_ids=ids.combined.super.${genome}.${chrNum}
   pop_ids=ids.combined.pop.${genome}.${chrNum}

   # extract variant IDs from original, raw VCF
   zgrep -v "^#" "${vcf}" | cut -f 3 | sort -u > "${raw_ids}"

   # extract and collect variant IDs from superpopulation VCFs
   for f in newVCF${genome}/${chrNum}/${chrNum}_*.no_monomorphic.vcf.gz; do
     ${BCFTOOLS} view -H "${f}" | cut -f 3
   done | sort -u > "${super_ids}" 

   # extract and collect variant IDs from subpopulation VCFs
   for f in newVCF${genome}/${chrNum}/pop/${chrNum}_*.no_monomorphic.vcf.gz; do
  	  ${BCFTOOLS} view -H "${f}" | cut -f 3
   done | sort -u > "${pop_ids}"

   #if ! cmp ids.combined.super.${genome}.${chrNum} ids.combined.pop.${genome}.${chrNum} > /dev/null 2>&1; then
   if ! cmp "${super_ids}" "${pop_ids}" > /dev/null 2>&1; then
	   echo "ERROR: chr$chrNum: subpopulation and population are not the same "
   fi
   ndiff=$(comm -1 -3 "${super_ids}" "${raw_ids}" | wc -l) # in raw, not in super
   ndiffpop=$(comm -1 -3 "${pop_ids}" "${raw_ids}" | wc -l) # in raw, not in pop
   echo -e "${chrNum}\t${ndiff}\t${ndiffpop}"
done
