#tabix – Generic indexer for TAB-delimited genome position files
set -eu
INBED=${1:-input.bed.gz} # input BED.gz must be sorted
TABIX=$(command -v tabix)
if [ ! -x "${TABIX}" ]; then
	echo "ERROR: tabix not found. Please make sure tabix is installed and in the path."
	exit 1
fi

"${TABIX}" -p bed "${INBED}"

#for i in $(ls *bed.gz); do tabix -p bed $i; done
