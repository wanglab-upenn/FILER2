#!/bin/bash
set -e
set -o pipefail


bashVer=${BASH_VERSINFO[0]}
script=$(basename $0)
scriptDir=$(dirname $0)
scriptSummary="return track records overlapping a given interval" 

source "${scriptDir}/help.sh"

# define all parameters: name;;;required|optional;;;description;;;example_value;;;default_value
params=( "trackID;;;r;;;FILER track identifier;;;NGEN000610;;;''" "region;;;r;;;genomic coordinates;;;chr:100000-1300000;;;''" "configFile;;;r;;;FILER configuration file;;;gadb.ini;;;''" "includeMetadata;;;o;;;binary variable, set to 1 to return track metadata;;;0 or 1;;;0" "outputFormat;;;o;;;output format;;;bed or json;;;bed" )

read -r -d '' HELPEXAMPLES << "EXAMPLES" || true
Examples:
bash get_data_region.sh --trackID NGEN000601 --region chr1:50000-1500000 --includeMetadata 0 --outputFormat bed --configFile filer.ini
EXAMPLES

# parse command-line arguments
[ $# -lt 6 ] && Help "***ERROR: not enough arguments. Please see usage." && exit 1 
paramValues=()
SetParams "$@" # parse command-line args and set all parameters (as default or command-line values)

# read configuration and set metadata and tools locations
source "${configFile}"
SCHEMAS="${FILERTRACKSCHEMAS}" 
METADATA="${FILERMETADATA}" 
TABIX="${TABIX}" 
MLR="${MLR}"
JQ="${JQ}"

# get track metadata based on track id; json format
trackMetadataLine=$( awk 'BEGIN{FS="\t"; targetTrackID="'"${trackID}"'";}{ if (FNR==1) {print; next}; trackID=$1; if (trackID==targetTrackID) print }' "${METADATA}" | "${MLR}" --icsv --fs tab --ojson cat )

# extract track file URL and (local) absolute path 
trackURL=$( echo "${trackMetadataLine}" | "${MLR}" --ijson --fs tab --otsv cut -f "Processed File Download URL" | tail -n+2 )
trackFile=$( echo "${trackMetadataLine}" | "${JQ}" -r '.filepath + "/" + ."File name"' )

# look-up track schema based on track file format
trackFormat=$( echo "${trackMetadataLine}" | "${MLR}" --ijson --fs tab --otsv cut -f "File format" | tail -n+2 )
trackSchema=$( awk 'BEGIN{FS="\t"; targetFormat="'"${trackFormat}"'"}{trackFormat=$1; if (trackFormat==targetFormat) {schema=$3; gsub(";","\t",schema); gsub("chrStart","start",schema); gsub("chrEnd","end",schema); print schema}}' "${SCHEMAS}" )

TRACK="${trackFile}"
if [ ! -s "${TRACK}" ]; then
  # track not found?
	echo "ERROR: requested track ${trackID} not found"
	exit 1
fi

cmd="${TABIX} ${TRACK} ${region}"
outputFormat=$( echo "${outputFormat}" | awk '{print tolower($0)}' )
#if [ "${outputFormat,,}" = "json" ]; then
if [ "${outputFormat}" = "json" ]; then

	if [ "${includeMetadata}" = "1" ]; then
		# output metadata+features
		#echo "["
		echo "{"
		echo "\"type\" : \"bed\","
		echo "\"Identifier\" : \"${trackID}\","
		echo "\"url\" : \"${trackURL}\","
		echo "\"name\" : \"${trackID}\"," # will be use as track name by WashU browser
		echo "\"metadata\" : ${trackMetadataLine},"
		echo "\"features\" : ["
		#(echo "$trackSchema" && "${TABIX}" "${TRACK}" "${region}") | "${MLR}" --icsv --fs tab --rs lf --ojsonx --jlistwrap cat
		#(echo "$trackSchema" && "${TABIX}" "${TRACK}" ${region}) | "${MLR}" --icsv --fs tab --rs lf --ojsonx cat | sed -z 's/}\n{/},\n{/g'
		( echo "$trackSchema" && "${TABIX}" "${TRACK}" ${region} ) | "${MLR}" --icsv --fs tab --rs lf --ojsonx cat | awk 'BEGIN{RS=""}{ gsub(/}\n{/, "},\n{", $0); print}'
		echo "]"
		echo "}"
		#echo "]"
	else
		# output only features array
		echo "["
		#(echo "$trackSchema" && "${TABIX}" "${TRACK}" ${region}) | "${MLR}" --icsv --fs tab --rs lf --ojsonx cat | sed -z 's/}\n{/},\n{/g'
		(echo "$trackSchema" && "${TABIX}" "${TRACK}" ${region}) | "${MLR}" --icsv --fs tab --rs lf --ojsonx cat | awk 'BEGIN{RS=""}{ gsub(/}\n{/, "},\n{", $0); print}'
		echo "]"
	fi

else
  # output BED format
  echo "#${trackSchema}"
  "$TABIX" "${TRACK}" $region
fi
