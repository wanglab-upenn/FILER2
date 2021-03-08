# Example: bash get_overlapping_tracks_by_coord.sh "chr1:1103243-1103332" giggle_index_list.hg19.all.txt test_output 1 1


INTERVAL=${1:-"chr1:1103243-1103332"} # query interval (1-based!!!)
GIGGLEINDEXLIST=$2 # list of giggle indexes to query
OUTDIR=${3:-"query_out"}
NJOBS=${4:-16} # number jobs (giggle queries) to run in parallel
forceOverwrite=${5:-0} # set to 1 to overwrite ouput directory if it exists
genomeBuild=$6
filterString=${7:-""}
FILERMETA=${8:-"/mnt/data2/GADB/metadata/GADB_metadata_V1_final_9252020.with_data_classification_v4.with_fixed_data_source_names.tsv"}


giggleOutFileList="${OUTDIR}/giggle_output_file_list.txt"
giggleOverlapSummary="${OUTDIR}/giggle_overlap_summary.txt"
overlappingTracks="${OUTDIR}/overlapping_tracks.txt"
indexStats="${OUTDIR}/giggle_index_stats.txt"

JQ=$(command -v jq)
GIGGLE=$(command -v giggle)
GIGGLE=/mnt/data/bin/giggle_fix_s_bed/bin/giggle
if [ ! -x ${GIGGLE} ]; then
  echo "***ERROR: giggle not found."
  exit 1
fi


if [ -d "${OUTDIR}" ] && [ "${forceOverwrite}" -ne 1  ]; then
  echo "Output directory already exists" 
	echo "Set forceOverwrite=1 to overwrite"
	exit 1
elif [ -d "${OUTDIR}" ] && [ "${forceOverwrite}" -eq 1 ]; then
	echo "Overwriting existing output directory: $OUTDIR"
	rm -rf "${OUTDIR}"/*
fi

mkdir -p "${OUTDIR}"

numPart=${NJOBS}
searched=0
searchedTracks=0
found=0
startTotalTime=$(date +%s.%N)
# prepare lists of giggle indexes for searching
split -n l/${numPart} -d ${GIGGLEINDEXLIST} "$OUTDIR/${GIGGLEINDEXLIST}.part"

>"${giggleOutFileList}"
>"${giggleOverlapSummary}"
>"${indexStats}"
>"${overlappingTracks}"

# launch giggle query jobs
for f in $OUTDIR/${GIGGLEINDEXLIST}.part*; do
	while read -r indexDIR _; do
		giggleOutDIR="${OUTDIR}/overlaps/${indexDIR##*Annotationtracks/}"
		mkdir -p "${giggleOutDIR}"
		giggleOut="${giggleOutDIR}/giggle_out.txt"
		"${GIGGLE}" search -i "${indexDIR}" -r "${INTERVAL}" -c  > "${giggleOut}" &
		read -r indexIntervals indexBps indexFiles <<< $( "${GIGGLE}" search -i "${indexDIR}" -l | awk '{if (NR==1) next; intCnt+=$2; bpCnt+=int(intCnt*$3)}END{fileCnt=NR-1; print intCnt, bpCnt, fileCnt}' )
		echo -e "$indexDIR\t${indexFiles}\t$indexIntervals\t$indexBps\t${numOverlaps}" >> "${indexStats}"	
		echo -e "${giggleOut}\t${indexDIR}" >> "${giggleOutFileList}"
		searched=$(( searched + indexIntervals ))
		searchedTracks=$(( searchedTracks + indexFiles ))
	done < "${f}" 
done

# wait for query jobs to finish
wait

paste "${giggleOutFileList}" "${indexStats}" | \
	while IFS=$'\t' read -r gf indexDir rest; do
		numOverlaps=$( awk '{ n=$NF; gsub(/^overlaps:/,"",n); t+=n; }END{print t}' "${gf}" )
		LC_ALL=C awk 'BEGIN{FS="\t";OFS="\t"}{fname=$1; gsub(/^#/,"",fname); n=$3; gsub(/^overlaps:/,"",n); if (n>0) overlapCnts[fname]+=n;}END{for (f in overlapCnts) print f, overlapCnts[f]}' "${gf}" >> "${overlappingTracks}"
		echo -e "${gf}\t${numOverlaps}\t${rest}" >> "${giggleOverlapSummary}"
	done 
found=$( awk 'BEGIN{FS="\t"}{t+=$2}END{print t}' "${giggleOverlapSummary}" )
endTime=$(date +%s.%N)
foundOverlappingTracks=$( wc -l "${overlappingTracks}" | awk '{print $1}' )

totalTime=$( echo "${endTime} - ${startTotalTime}" | bc -l )
speed=$(echo "${searched}/${totalTime}" | bc -l)
env LC_ALL=en_US.UTF-8 printf "\nSearched %'d intervals (%'d tracks) in %'f seconds (%'f intervals/sec)\n" ${searched} ${searchedTracks} ${totalTime} ${speed} 
env LC_ALL=en_US.UTF-8 printf "\nFound %'d overlaps." $found
env LC_ALL=en_US.UTF-8 printf "\nFound %'d overlapping tracks.\n" ${foundOverlappingTracks}


overlappingTracksMetadata="${OUTDIR}/overlapping_tracks.metadata.tsv"
>"${overlappingTracksMetadata}"
echo "META=${FILERMETA}"
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
				 fdir=$19; fname=$3;
				 fpath=(fdir "/" fname)
				 if (overlappingTracks[fpath]==1)
					 print $0 > overlappingTracksMetadata
			 } 
		 }' "${overlappingTracks}" "${FILERMETA}"

bash make_washu_hub.sh "${overlappingTracksMetadata}" "${overlappingTracksMetadata%.tsv}"
# filter JSON
outJSON="${overlappingTracksMetadata%.tsv}.${genomeBuild}.json"
#"${JQ}" '.[] | select( .metadata."Data source" == "ENCODE" )' "${outJSON}" > "${outJSON%.json}.filtered.json"
"${JQ}" '[.[] | select( '"${filterString}"' )]' "${outJSON}" > "${outJSON%.json}.filtered.json"

