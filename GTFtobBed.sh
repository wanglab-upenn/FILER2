#gtf_format: seqname source feature start end score strand frame attribute
#bed files are 0-based hence ($4-1) on start position

INGTF=${1:-input.gtf.gz}
zcat "${INGTF}"  | awk -F$'\t' -v OFS='\t' '{if (NR==1) {print; next}; print $1, ($4-1), $5, $2, $3, $7, $6, $8, $9 }'
