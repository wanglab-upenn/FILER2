#filter GTEx all association to pval<0.05
#zcat Adipose_Subcutaneous_Analysis.v6p.all_snpgene_pairs.sorted.bed.gz | awk '{pval=$8; if (pval<0.05) print}' | bgzip -c > Adipose_Subcutaneous_Analysis.v6p.all_snpgene_pairs.sorted.min_0p05.bed.gz

set -eu
gtexDir=/GADB/Downloads/GTEx/v6p/GTEx_Analysis_v6p_all-associations
pval_thres=0.05
OUTDIR="${gtexDir}/filtered"
mkdir -p "${OUTDIR}"
for f in ${gtexDir}/*all_snpgene_pairs.txt.gz; do
  outf="${OUTDIR}/`basename ${f}`"
  outf="${outf/sorted.bed.gz/sorted.filtered.bed.gz}"
  echo ${f}
  echo ${outf}
  zcat "${f}" | awk 'BEGIN{FS="\t"; OFS="\t"; pval_thres='${pval_thres}'+0.0;}{pval=$4; if (pval < pval_thres) print}' | bgzip -c > ${outf}

done

