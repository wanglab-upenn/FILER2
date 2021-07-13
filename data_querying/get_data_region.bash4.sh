#!/bin/bash
set -e
set -o pipefail


bashVer=${BASH_VERSINFO[0]}
if [ "${bashVer}" -lt 4 ]; then
	  echo "ERROR: Bash version 4+ is required to run this script (bash version ${bashVer} is detected)."
		exit 1
fi

function Help()
{
	echo "Script: $script"
	echo "Summary: return track records overlapping given interval" 
	echo ""
	echo -n "USAGE: $script"
	for p in "${!params[@]}"; do
		echo -n " --$p <$p>"
	done
	echo "";

	for p in "${!params[@]}"; do
		v="${params[$p]}"
		IFS=$'\t' read -r req descr exampleVal defVal clVal < <(echo "${v}" | sed 's/;;;/\t/g') 
		reqDisp="Required" && [ "${req}" = "o" ] && reqDisp="Optional"
		echo "[$reqDisp] <$p> = ${descr}. Example: ${exampleVal}. Default: $defVal"
	done | sort -k1,1r
	echo ""
	echo "Examples:"
  echo "bash get_data_region.sh --trackID NGEN000611 --region \"chr1:50000-1500000\" --includeMetadata 0 --outputFormat bed --configFile gadb.ini"
	exit 1
}

script=$(basename $0)
# required|optional;;;description;;;example_value;;;default_value;;;command_line_value
declare -A params=( [trackID]="r;;;FILER track identifier;;;NGEN000610;;;''" [region]="r;;;genomic coordinates;;;chr:100000-1300000;;;''" [includeMetadata]="o;;;binary variable, set to 1 to return track metadata;;;0 or 1;;;0" [outputFormat]="o;;;output format;;;bed or json;;;bed" [configFile]="r;;;FILER configuration file;;;gadb.ini;;;''" )

[ $# -lt 6 ] && Help

# read command line arguments
while [ $# -gt 0 ]; do
	if [[ $1 == "--help" ]]; then
		Help
	fi
  if [[ $1 == "--"* ]]; then
    param="${1#--}"
		value="${2}"
		if [ ${params[$param]+_} ]; then
		  params[$param]="${params[$param]};;;${value}"
		else
			echo "***ERROR: Unknown option $param is specified."
			exit 1
		fi
  fi
  shift 2
done

for p in "${!params[@]}"; do
	v=${params[$p]}
	IFS=$'\t' read -r isReq descr exampleVal defVal clVal < <(echo "${v}" | sed 's/;;;/\t/g')
	#echo -e "$isReq\t$descr\t$exampleVal\t$defVal\t$clVal"
	if [ "${isReq}" = "r" ] && [ "${clVal}" = "" ]; then
		echo "***ERROR: required parameter $p is not specified"
		exit 1
	fi
	value=${clVal:-"${defVal}"}
	declare $p="$value"
done

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
if [ "${outputFormat,,}" = "json" ]; then

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
		(echo "$trackSchema" && "${TABIX}" "${TRACK}" ${region}) | "${MLR}" --icsv --fs tab --rs lf --ojsonx cat | sed -z 's/}\n{/},\n{/g'
		echo "]"
		echo "}"
		#echo "]"
	else
		# output only features array
		echo "["
		(echo "$trackSchema" && "${TABIX}" "${TRACK}" ${region}) | "${MLR}" --icsv --fs tab --rs lf --ojsonx cat | sed -z 's/}\n{/},\n{/g'
		echo "]"
	fi

else
  # output BED format
  echo "#${trackSchema}"
  "$TABIX" "${TRACK}" $region
fi
