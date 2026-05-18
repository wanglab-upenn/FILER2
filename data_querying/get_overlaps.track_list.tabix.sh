## OVERLAP all the tracks listed in the input with the given genomic region (using tabix)
## output format: <input file path/url> <@@@-separated hit string1[,,,@@@-separated hit string2]>
INLIST=${1:-"track_list.txt"}
INREGION=${2:-"chr1:195000-200000"}
NJOBS=${3:-16}
TABIX=/mnt/data/bin/miniconda3tf/bin/tabix

if [ $# -lt 2 ]; then
  echo "USAGE: $0 <track_list.txt> <chr:chrStart-chrEnd>"
  echo "track_list.txt should contain one file path per line for overlappng the region of interest"
  exit 1
fi

cat "${INLIST}" \
 | parallel -k -j ${NJOBS} "${TABIX} {} ${INREGION} | LC_ALL=C mawk 'BEGIN{OFS=\"@@@\"; printf \"%s\\t\", \"{}\"}{\$1=\$1; printf \"%s%s\", FNR==1?\"\":\",,,\", \$0}END{printf \"%s\", \"\\n\"}'"
 #| parallel -k -j ${NJOBS} "${TABIX} {} ${INREGION} | LC_ALL=C awk 'BEGIN{ORS=\",,,\"; OFS=\"@@@\"; printf \"%s\\t\", \"{}\"}{\$1=\$1; print \$0}END{printf \"%s\", \"\\n\"}'" | LC_ALL=C sed 's/,,,$//g'
 #| parallel -j ${NJOBS} "${TABIX} {} ${INREGION} | LC_ALL=C mawk 'BEGIN{FS=\"\\t\"; OFS=\"@@@\"}{\$1=\$1; f=\"{}\"; gsub(/^\/project\/wang4\//,\"https://tf.lisanwanglab.org/\", f); print (f \"\\t\" \$0)}'" | LC_ALL=C sort -t $'\t' -k1,1 
 #| parallel -j ${NJOBS} "${TABIX} {} ${INREGION} | LC_ALL=C mawk 'BEGIN{FS=OFS=\"\\t\"}{print \$0, \"{}\"}'" | LC_ALL=C sort -k1,1 -k2,2n -k3,3nn
