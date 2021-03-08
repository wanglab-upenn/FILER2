
#TRACK=${1:-"/mnt/data2/GADB/Annotationtracks/ENCODE/data/ChIP-seq/narrowpeak/hg38/1/ENCFF014TLB.bed.gz"}
#/project/wang4/GADB/Annotationtracks/ENCODE/data/ChIP-seq/narrowpeak/hg38/1/ENCFF014TLB.bed.gz
TRACKID=${1:-"NGEN000610"}
REGION=${2:-"chr1:100000-1300000"}

SCHEMAS=/mnt/data2/GADB/supplementary/FILER_BED_schema.tsv
METADATA=/mnt/data2/GADB/metadata/GADB_metadata_V1_final_9252020.with_data_classification_v4.with_fixed_data_source_names.tsv


TABIX=/usr/local/bin/tabix
MLR=/mnt/data/bin/miller-5.10.0/bin/mlr

#echo "TRACKID=${TRACKID}"
trackMetadataLine=$( awk 'BEGIN{FS="\t"; targetTrackID="'"${TRACKID}"'";}{ if (FNR==1) {print; next}; trackID=$1; if (trackID==targetTrackID) print }' "${METADATA}" | "${MLR}" --icsv --fs tab --ojson cat )
#echo "${trackMetadataLine}"
trackFormat=$( echo "${trackMetadataLine}" | "${MLR}" --ijson --fs tab --otsv cut -f "File format" | tail -n+2 )
trackURL=$( echo "${trackMetadataLine}" | "${MLR}" --ijson --fs tab --otsv cut -f "Processed File Download URL" | tail -n+2 )
#echo "format=${trackFormat}"
#echo "url=${trackURL}"
trackSchema=$( awk 'BEGIN{FS="\t"; targetFormat="'"${trackFormat}"'"}{trackFormat=$1; if (trackFormat==targetFormat) {schema=$3; gsub(";","\t",schema); print schema}}' "${SCHEMAS}" )
trackFile=$( echo "${trackMetadataLine}" | jq -r '.filepath + "/" + ."File name"' )
TRACK="${trackFile}"
#echo "schema=${trackSchema}"
cmd="${TABIX} ${TRACK} ${REGION}"
#echo "${cmd}"
#"${TABIX}" "${TRACK}" "${REGION}" | "${MLR}" --icsv --fs tab --rs lf --ojson --jlistwrap cat
#"${TABIX}" "${TRACK}" "${REGION}" | "${MLR}" --fs tab --rs lf --ojson --jlistwrap cat
#echo -n "["
echo "["
echo "{"
echo "\"type\" : \"bed\","
echo "\"Identifier\" : \"${TRACKID}\","
echo "\"url\" : \"${trackURL}\","
echo "\"metadata\" : ${trackMetadataLine},"
echo "\"features\" : ["
#(echo "$trackSchema" && "${TABIX}" "${TRACK}" "${REGION}") | "${MLR}" --icsv --fs tab --rs lf --ojsonx --jlistwrap cat
(echo "$trackSchema" && "${TABIX}" "${TRACK}" ${REGION}) | "${MLR}" --icsv --fs tab --rs lf --ojsonx cat | sed -z 's/}\n{/},\n{/g'
echo "]"
echo "}"
echo "]"
