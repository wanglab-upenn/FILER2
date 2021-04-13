# Example: bash get_overlapping_tracks_by_coord.sh "chr1:1103243-1103332" giggle_index_list.hg19.all.txt test_output 1 1
#!/bin/bash
set -e

function Help()
{
	echo "Script: $script"
	echo "Summary: return track records overlapping given interval" 
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

	cat <<EXAMPLES

Examples:

bash get_overlapping_tracks_by_coord.sh --region "chr1:1103243-1103243" --giggleIndexList giggle_index_list.hg19.all.txt --outputDir query_out --genomeBuild hg19 --configFile gadb.ini

bash get_overlapping_tracks_by_coord.sh --region "chr1:1103243-1103243" --giggleIndexList giggle_index_list.hg19.all.txt --outputDir query_out --genomeBuild hg19 --configFile gadb.ini --filterString ".\"Data Source\" == \"DASHR2\"" --forceOverwrite 1

EXAMPLES

	exit 1
}

script=$(basename $0)
declare -A params=( [region]="r;;;genomic region;;;chr1:1103243-1103332;;;''" [giggleIndexList]="r;;;list of giggle index directories to search;;;giggle_index_list.txt;;;''" [outputDir]="r;;;output directory;;;query_out;;;''" [njobs]="o;;;number of jobs (giggle queries) to run in parallel;;;16;;;16" [filterString]="o;;;jq track filter string;;;.\"Data Source\"==\"DASHR2\";;;." [genomeBuild]="r;;;genome build;;;hg19|hg38;;;''" [configFile]="r;;;FILER config file;;;filer.ini;;;''" [forceOverwrite]="o;;;set to 1 to overwrite output directory if it exists;;;0|1;;;0" )

[ $# -lt 10 ] && Help 

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
	if [ "${isReq}" = "r" ] && [ "${clVal}" = "" ]; then
		echo "***ERROR: required parameter $p is not specified"
		exit 1
	fi
	value=${clVal:-"${defVal}"}
	declare $p="$value"
done

# output files
giggleOutFileList="${outputDir}/giggle_output_file_list.txt"
giggleOverlapSummary="${outputDir}/giggle_overlap_summary.txt"
overlappingTracks="${outputDir}/overlapping_tracks.txt"
indexStats="${outputDir}/giggle_index_stats.txt"
runSummary="${outputDir}/run_summary.txt"

source "${configFile}"
FILERMETA="${FILERMETADATA}"
JQ="${JQ}"
MLR="${MLR}"
GIGGLE="${GIGGLE}"
#JQ=$(command -v jq)
#GIGGLE=$(command -v giggle)
if [ ! -x ${GIGGLE} ]; then
  echo "***ERROR: giggle not found."
  exit 1
fi


if [ -d "${outputDir}" ] && [ "${forceOverwrite}" -ne 1  ]; then
  echo "Output directory already exists" 
	echo "Set forceOverwrite=1 to overwrite"
	exit 1
elif [ -d "${outputDir}" ] && [ "${forceOverwrite}" -eq 1 ]; then
	echo "Overwriting existing output directory: $outputDir"
	rm -rf "${outputDir}"/*
fi

mkdir -p "${outputDir}"

numPart=${njobs}
searched=0
searchedTracks=0
found=0
startTotalTime=$(date +%s.%N)
# prepare lists of giggle indexes for searching
split -n l/${numPart} -d ${giggleIndexList} "$outputDir/${giggleIndexList}.part"

>"${giggleOutFileList}"
>"${giggleOverlapSummary}"
>"${indexStats}"
>"${overlappingTracks}"
>"${runSummary}"

# launch giggle query jobs
for f in $outputDir/${giggleIndexList}.part*; do
	while read -r indexDIR _; do
		giggleOutDIR="${outputDir}/overlaps/${indexDIR##*Annotationtracks/}"
		mkdir -p "${giggleOutDIR}"
		giggleOut="${giggleOutDIR}/giggle_out.txt"

		# run giggle search
		"${GIGGLE}" search -i "${indexDIR}" -r "${region}" -c  > "${giggleOut}" &
		
		read -r indexIntervals indexBps indexFiles <<< $( "${GIGGLE}" search -i "${indexDIR}" -l | awk '{if (NR==1) next; intCnt+=$2; bpCnt+=int(intCnt*$3)}END{fileCnt=NR-1; print intCnt, bpCnt, fileCnt}' )
		#echo -e "$indexDIR\t${indexFiles}\t$indexIntervals\t$indexBps\t${numOverlaps}" >> "${indexStats}"	
		echo -e "${indexDIR}\t${indexFiles}\t${indexIntervals}\t${indexBps}" >> "${indexStats}"	

		#echo -e "${giggleOut}\t${indexDIR}" >> "${giggleOutFileList}"
		echo -e "${giggleOut}\t${indexDIR}\t${indexFiles}\t${indexIntervals}\t${indexBps}" >> "${giggleOutFileList}"
		searched=$(( searched + indexIntervals ))
		searchedTracks=$(( searchedTracks + indexFiles ))
	done < "${f}" 
done

# wait for query jobs to finish
wait


#paste "${giggleOutFileList}" "${indexStats}" | \
paste "${giggleOutFileList}" | \
	while IFS=$'\t' read -r gf indexDir rest; do
		numOverlaps=$( awk '{ n=$NF; gsub(/^overlaps:/,"",n); t+=n; }END{print t}' "${gf}" )

		LC_ALL=C awk 'BEGIN{FS="\t";OFS="\t"}{ fname=$1; gsub(/^#/,"",fname); n=$3; gsub(/^overlaps:/,"",n); if (n>0) overlapCnts[fname]+=n;}END{for (f in overlapCnts) print f, overlapCnts[f]}' "${gf}" >> "${overlappingTracks}"

		echo -e "${gf}\t${numOverlaps}\t${rest}" >> "${giggleOverlapSummary}"
	done 

found=$( awk 'BEGIN{FS="\t"}{t+=$2}END{print t}' "${giggleOverlapSummary}" )
endTime=$(date +%s.%N)
foundOverlappingTracks=$( wc -l "${overlappingTracks}" | awk '{print $1}' )

totalTime=$( echo "${endTime} - ${startTotalTime}" | bc -l )
speed=$(echo "${searched}/${totalTime}" | bc -l)
env LC_ALL=en_US.UTF-8 printf "\nSearched %'d intervals (%'d tracks) in %'f seconds (%'f intervals/sec)\n" ${searched} ${searchedTracks} ${totalTime} ${speed} >> "${runSummary}" 
env LC_ALL=en_US.UTF-8 printf "\nFound %'d overlaps." $found >> "${runSummary}"
env LC_ALL=en_US.UTF-8 printf "\nFound %'d overlapping tracks.\n" ${foundOverlappingTracks} >> "${runSummary}"


overlappingTracksMetadata="${outputDir}/overlapping_tracks.metadata.tsv"
>"${overlappingTracksMetadata}"
awk 'BEGIN{FS="\t";OFS="\t"; overlappingTracksMetadata="'${overlappingTracksMetadata}'";}
     {
			 if (ARGIND==1)
			 {
				 # overlapping track list
				 fpath=$1;
				 overlappingTracks[fpath]=1;
			 }
		   else if (ARGIND==2)
			 {
				 # FILER metadata
				 if (FNR==1) {print > overlappingTracksMetadata; next} # print header
				 fdir=$19; fname=$3;
				 fpath=(fdir "/" fname)
				 if (overlappingTracks[fpath]==1)
					 print $0 > overlappingTracksMetadata
			 } 
		 }' "${overlappingTracks}" "${FILERMETA}"

## make final track metadata JSON with all overlapping tracks subject to filtering criteria (filterString) if any
outJSON="${overlappingTracksMetadata%.tsv}.${genomeBuild}.json"
outJSONfiltered="${outJSON%.json}.filtered.json"
outTSVfiltered="${outJSONfiltered%.json}.tsv"
"${MLR}" --icsv --fs tab --rs lf --ojson --jlistwrap cat "${overlappingTracksMetadata}" > "${outJSON}"
"${JQ}" '[.[] | select( '"${filterString}"' )]' "${outJSON}" > "${outJSONfiltered}"
"${MLR}" --ijson --otsv cat "${outJSONfiltered}" > "${outTSVfiltered}"
echo "Overlapping tracks metadata (tsv): ${outTSVfiltered}" >> "${runSummary}"
echo "Overlapping tracks metadata (JSON): ${outJSONfiltered}" >> "${runSummary}"
