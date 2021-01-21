#gff3_format: seqid source type start end score strand phase attributes 
#bed files are 0-based hence ($4-1) on start position
INGFFGZ=${1:-input.gff.gz}
zcat "${INGFFGZ}" | awk -F$'\t' -v OFS='\t' '{print $1, ($4-1), $5, $2, $3, $7, $6, $8, $9 }'

