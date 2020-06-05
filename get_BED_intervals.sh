#to calculate number of intervals and base pair covered

zcat input.bed.gz | awk '{len=$3-$2; totalLen+=len;}END{ numInt=NR; print numInt, totalLen, totalLen/numInt }'
