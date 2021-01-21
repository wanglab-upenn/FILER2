#sorting bed files:using C locale (simple byte sort)
#bgzip – Block compression/decompression utility
set -eu
INBED=${1:-input.bed}
BGZIP=$(command -v bgzip)
LC_ALL=C sort -k1,1 -k2,2n -k3,3n "${INBED}" | "${BGZIP}" -c > "${INBED}".gz
