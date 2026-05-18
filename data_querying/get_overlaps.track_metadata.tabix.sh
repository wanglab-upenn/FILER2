## OVERLAP all the tracks listed in the input metadata with the given genomic region (using tabix)
## output format: <input file path/url> <@@@-separated metadata string> <@@@-separated hit string1[,,,@@@-separated hit string2]>
INMETA=${1:-"tracks_meta.tsv"}
INREGION=${2:-"chr1:195000-200000"}
NJOBS=${3:-16}
FILERSCHEMAS=${4:-"/mnt/website-data/GADB/schemas/FILER-BED_Schema-V3-02052026.tsv"}

TABIX=/mnt/data/bin/miniconda3tf/bin/tabix

if [ $# -lt 2 ]; then
  echo "USAGE: $0 <track_meta.tsv> <chr:chrStart-chrEnd> [<num_jobs>] [<filer_schemas_tsv>]"
  echo "tracks_meta.txt should contain a metadata line (in FILER format) for each of the tracks that will be overlapped with the region of interest"
  echo -e "output format (TSV):\n<input file path/url>\t<@@@-separated metadata string>\t<@@@-separated hit string1[,,,@@@-separated hit string2]>"
  exit 1
fi

## global header
header="file_path\tfile_metadata\tfile_schema\toverlaps\tnum_overlaps"

## run tabix across all tracks
(echo -e "#${header}" && LC_ALL=C mawk 'BEGIN{FS="\t";OFS="@@@"}{ if (FILENAME==ARGV[1]) { fformat=$1; fschema=$3; fileSchemas[fformat]=fschema;} else { if (FNR==1) next; $1=$1; fformat=$17; url=$23; fpath=url; gsub(/https:\/\/tf.lisanwanglab.org\//,"/project/wang4/",fpath); gsub(/\047/,"",$0); $19=fpath; fschema=fileSchemas[fformat]; if (fschema=="") fschema="NOT_FOUND"; print (fpath "\t" url "\t" fschema "\t" $0)}; }' "${FILERSCHEMAS}" "${INMETA}" \
 | parallel --colsep $'\t' -k -j ${NJOBS} ''"${TABIX}"' "{1}" '"${INREGION}"' | LC_ALL=C mawk -v furl={2} -v fschema={3} -v mdLine={4} '"'"'BEGIN{OFS="@@@"; f="{1}"; gsub(/\047/,"", mdLine); printf "%s\t%s\t%s\t", furl, mdLine, fschema}{$1=$1; printf "%s%s", FNR==1?"":",,,", $0}END{printf "\t%d\n", FNR}'"'"'') \
 | pigz -c 
 #| parallel -k -j ${NJOBS} "${TABIX} {} ${INREGION} | LC_ALL=C awk 'BEGIN{ORS=\",,,\"; OFS=\"@@@\"; printf \"%s\\t\", \"{}\"}{\$1=\$1; print \$0}END{printf \"%s\", \"\\n\"}'" | LC_ALL=C sed 's/,,,$//g'
 #| parallel -j ${NJOBS} "${TABIX} {} ${INREGION} | LC_ALL=C mawk 'BEGIN{FS=\"\\t\"; OFS=\"@@@\"}{\$1=\$1; f=\"{}\"; gsub(/^\/project\/wang4\//,\"https://tf.lisanwanglab.org/\", f); print (f \"\\t\" \$0)}'" | LC_ALL=C sort -t $'\t' -k1,1 
 #| parallel -j ${NJOBS} "${TABIX} {} ${INREGION} | LC_ALL=C mawk 'BEGIN{FS=OFS=\"\\t\"}{print \$0, \"{}\"}'" | LC_ALL=C sort -k1,1 -k2,2n -k3,3nn
