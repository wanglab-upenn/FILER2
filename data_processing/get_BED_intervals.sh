#to calculate number of intervals and base pair covered
INBEDGZ=${1:-input.bed.gz}
zcat "${INBEDGZ}" | awk '{if ($1~/^#/) {++num_comment_lines; next}; len=$3-$2; totalLen+=len;}END{ numInt=NR-num_comment_lines; print numInt, totalLen, totalLen/numInt }'
