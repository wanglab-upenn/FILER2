#sorting bed files:using C locale (simple byte sort)
#bgzip – Block compression/decompression utility


LC_ALL=C sort -k1,1 -k2,2n -k3,3n input.bed | bgzip -c > input.bed.gz
