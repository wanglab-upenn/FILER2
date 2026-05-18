bashVer="${BASH_VERSINFO[0]}"
scriptDir=$( dirname "$0" )
script=$( basename "$0" )
scriptSummary="return track/genomic records overlapping given BED intervals" 

# source helper functions
source "${scriptDir}/help.sh"

# script parameters
# parameterName;;;requred;;;description;;;example value;;;default value
params=( "inBed;;;r;;;input BED file (NOTE: must be in sorted bgzip bed.gz format);;;input.bed.gz;;;''" "giggleIndexDirList;;;o;;;file with the list of giggle-indexed directories to search. NOTE: one giggle index directory (absolute path) per-line;;;giggle_index_dirs.txt;;;''" "configFile;;;r;;;FILER configuration file;;;filer.ini;;;''" "outputDir;;;r;;;output directory;;;filer_out;;;''" "forceOverwrite;;;o;;;set to 1 to overwrite output folder if it already exists;;;0 or 1;;;0" "genomeBuild;;;o;;;genome build. NOTE: must be provided if list of giggle index directories for search is not provided;;;hg19 or hg38;;;''" "verboseSearch;;;o;;;enable verbose search (slower; will report overlapping records (hit strings));;;0 or 1;;;0" "tempDir;;;o;;;temporary directory;;;e.g., /tmp or outputDir/tmp;;;/tmp" "stopIfNoMetadata;;;o;;;set to 1 if need to stop when overlapping track is not found in metadata (this will catch any errors associated with the setup/metadata/files mismatches);;;1" )

read -r -d '' HELPEXAMPLES << "EXAMPLES" || true
Examples:

bash filer_overlap.sh --configFile gadb.ini --giggleIndexDirList giggle_index_list.hg19.test.txt --inBed test.hg19.bed.gz --outputDir test_filer_out
EXAMPLES

read -r -d '' HELPNOTES << "NOTES" || true
NOTE: input BED must be coordinate-sorted and bgzipped. E.g., to prepare a BED file for overlap the following command can be used:
LC_ALL=C sort -k1,1 -k2,2n -k3,3n input.bed | bgzip -c > input.sorted.bed.gz
NOTES

[ $# -lt 6 ] && Help "***ERROR: not enough input arguments provided. Please see usage" && exit 1
# parse command-line arguments and set all parameters
paramValues=()
SetParams "$@"
echo "Parameter values:"
for pv in "${paramValues[@]}"; do
  p="${pv%%;;;*}"
	v="${pv##*;;;}"
	echo "$p=$v"
done

source "${configFile}"
FILERMETA="${FILERMETADATA}"
FILERROOTDIR="${FILERDIR}"
GIGGLE="${GIGGLE}"
#TEMPDIR="${TEMPDIR:-/tmp}" ## can set TEMPDIR in the config, e.g., if /tmp is too small
TEMPDIR="${tempDir}" ## can set tempDir in the command options, e.g., if /tmp is too small

if [ ! -x "${GIGGLE}" ]; then
	echo "ERROR: FILER Giggle not found. Please install and provide absolute path for FILER Giggle"
  exit 1
fi

# main part: giggle-overlap with FILER 
if [ -d "${outputDir}" ]; then
 if [ "${forceOverwrite}" = 1 ]; then
   echo "WARNING: forceOverwrite=${forceOverwrite}, will overwrite existing folder: ${outputDir}"
	 rm -rf "${outputDir}/*"
 else
	 echo "Output folder ${outputDir} already exists. Set forceOverwrite to 1 to overwrite, or choose another folder."
	 exit 1
 fi
fi
mkdir -p "${outputDir}"
giggleOverlaps="$outputDir/filer_overlaps.bed"
giggleOverlapsWithMeta="${giggleOverlaps%.*}.with_meta.bed"

# prepare bed.gz for use with giggle
inBedGz="${outputDir}/input.bed.gz"
if [ "${inBed##*.}" = "gz" ]; then
  zcat "${inBed}" | LC_ALL=C sort -k1,1 -k2,2n -k3,3n | "${BGZIP}" -c > "${inBedGz}"
else
  LC_ALL=C sort -k1,1 -k2,2n -k3,3n "${inBed}" | "${BGZIP}" -c > "${inBedGz}"
fi

# generate list of giggle index directories if necessary/not provided
if [ "${#giggleIndexDirList}" -lt 3 ]; then
	if [[ $genomeBuild =~ "hg"* ]]; then
		# list of the giggle index directories is not provided; scan FILER directory and find all */giggle_index directories
		echo "WARNING: list of giggle index directories was not specified. will scan ${FILERROOTDIR} for giggle_index directories for $genomeBuild"
		giggleIndexDirList="${outputDir}/giggle_index_dirs_for_search.${genomeBuild}.txt"
		find "${FILERROOTDIR}" -type d -iname '*giggle_index' | grep "${genomeBuild}/" > "${giggleIndexDirList}" 
	  else
			echo "ERROR: both giggleIndexDirList and genomeBuild are not provided. If giggleIndexDirList is not provided, genomeBuild must be specified."
			exit 1
	fi
fi
echo "List of directories that will be searched=$giggleIndexDirList"

jobSize=4 # number of giggle query jobs to run in parallel
#numSearchDirs=$( wc -l "${giggleIndexDirList}" | awk '{print $1}' )
numSearchDirs=$( grep -c -v "^#" "${giggleIndexDirList}" )
chunkSize=${jobSize} #$(( (numSearchDirs-1) / jobSize + 1 )) # round up
partPrefix="$outputDir/$(basename "${giggleIndexDirList}")"
partsList="${outputDir}/giggle_index_dirs.parts_list.txt"
awk 'BEGIN{chunkSize="'${chunkSize}'"+0; prefix="'"${partPrefix}"'"; partFileList="'"${partsList}"'";}
{
	partCnt = int( FNR / chunkSize );
	partSuffix=sprintf("part%02d", partCnt);
	partFile=( prefix "." partSuffix);
	if (partFiles[partFile]!=1) partFiles[partFile]=1;
	print $0 > partFile;
}
END{
  for (pf in partFiles)
		print pf > partFileList;
}' <(grep -v "^#" "${giggleIndexDirList}") ## skip commented out directories

## search FILER, one data collection/giggle index at a time
#cat "${giggleIndexDirList}" | \
while read -r sublist; do
  while read -r gi; do
		# gi contains full/absolute path to giggle_index folder
		indexdir="${gi}"
		indexdir="${indexdir##${FILERROOTDIR}/}" ## remove directory prefix
		indexdir="${indexdir%%\/giggle_index}" ## remove giggle_index suffix
		outdir="${outputDir}/overlaps/${indexdir}" ## this will reproduce FILER directory
		                               ## structure under $outputDir
		mkdir -p "${outdir}"
		outfile="${outdir}/giggle_out.txt"
		echo "${outfile}"

		## giggle search
		#  -o=report results per input record omitting non-overlapping records (this only using giggle index; not accessing actual track files; so it's faster)
		#  -b=report in BED format
		if [ "${verboseSearch}" = "1" ]; then
			( "${GIGGLE}" search -q "${inBedGz}" -i "${gi}" -o -v | \
				LC_ALL=C awk 'BEGIN{FS="\t";OFS="\t"}
				 {
				 if ($1~/^##/) # query line
				 {
					query=$0;
					query=substr(query,3); # remove leading ##
				 }
				 else
				 {
					overlap=$0;
					fname=$NF;
					gsub(/\t/,"@@@",overlap); # hit string
					print query, fname, overlap, "1";
				 }
			 }' > "${outfile}" ) &
	  else	
		 "${GIGGLE}" search -q "${inBedGz}" -i "${gi}" -o -b > "${outfile}" &
		fi
	done < "${sublist}"
	wait
done < "${partsList}"

## collect overlap/sig results, sort by significance (giggle combo score)
>"${giggleOverlaps}"
numInputFields=$( zcat "${inBedGz}" | head -n 1 | awk -F $'\t' '{print NF}' )

# construct header: input BED header (from bed itself or default) + giggle overlap header
defaultHeader=$( seq -f 'inputField%g' -s $'\t' ${numInputFields} )
firstLine=$( zcat "${inBedGz}" | head -n 1 )
# set header to default or, if present, to the header provided in bed file itself
inBedHeader="${defaultHeader}" && [[ "${firstLine}" == "#"*  ]] && inBedHeader="${firstLine#\#}"

if [ "${verboseSearch}" = "1" ]; then
  giggleHeader="trackFile\thitString\tnumOverlaps"
else
  giggleHeader="trackFile\ttrackNumIntervals\tnumOverlaps"
fi

echo -e "#${inBedHeader}\t${giggleHeader}" > "${giggleOverlaps}"

# collect overlaps acrosss all data sources/giggle indexes
find "${outputDir}" -type f -iname 'giggle_out.txt' | \
	while read -r f; do
		#tail -n+2 "${f}";
		cat "${f}"
	done | LC_ALL=C sort -k1,1 -k2,2n -k3,3n -T "${TEMPDIR}" >> "${giggleOverlaps}" 

## join overlaps with FILER track metadata
#awk 'BEGIN{FS="\t";OFS="\t"; fileCol='${numInputFields}'+1;}
#{ if (FILENAME==ARGV[1]) { if (FNR==1) {metaHeader=$0; next}; fdir=$19; fname=$3; gsub(/[\/]+/,"/",fdir); gsub(/\/$/,"", fdir); fpath=(fdir "/" fname); meta[fpath]=$0; }
#else if (FILENAME==ARGV[2]) { if (FNR==1) { giggleHeader=$0; print giggleHeader, metaHeader; next }; f=$fileCol; gsub(/[\/]+/,"/",f); md=meta[f]; if (md=="") {printf "ERROR: no metadata found for %s\n", f; exit;}; print $0, md} }' "${FILERMETA}" "${giggleOverlaps}" > "${giggleOverlapsWithMeta}"

if [ "${stopIfNoMetadata}" = 1 ]; then
## NOTE: this will stop if no metadata is found for one of the tracks
awk 'BEGIN{FS="\t";OFS="\t"; fileCol='${numInputFields}'+1; err=0;}
{ if (FILENAME==ARGV[1]) { if (FNR==1) {metaHeader=$0; next}; fdir=$19; fname=$3; gsub(/[\/]+/,"/",fdir); gsub(/\/$/,"", fdir); gsub(/^\/[^\/]+\/[^\/]+\//,"", fdir); fpath=(fdir "/" fname); meta[fpath]=$0; }
else if (FILENAME==ARGV[2]) { if (FNR==1) { giggleHeader=$0; print giggleHeader, metaHeader; next }; f=$fileCol; gsub(/[\/]+/,"/",f); gsub(/^\/[^\/]+\/[^\/]+\//,"", f); md=meta[f]; if (md=="") {printf "ERROR: no metadata found for %s\n", f; printf "ERROR: no metadata found for %s\n", f > "/dev/stderr"; err=2; exit;}; print $0, md} }END{ exit err; }' "${FILERMETA}" "${giggleOverlaps}" > "${giggleOverlapsWithMeta}"
else
## NOTE: this will not stop and will just skip lines with tracks not found in metadata
awk 'BEGIN{FS="\t";OFS="\t"; fileCol='${numInputFields}'+1; err=0;}
{ if (FILENAME==ARGV[1]) { if (FNR==1) {metaHeader=$0; next}; fdir=$19; fname=$3; gsub(/[\/]+/,"/",fdir); gsub(/\/$/,"", fdir); fpath=(fdir "/" fname); meta[fpath]=$0; }
else if (FILENAME==ARGV[2]) { if (FNR==1) { giggleHeader=$0; print giggleHeader, metaHeader; next }; f=$fileCol; gsub(/[\/]+/,"/",f); md=meta[f]; if (md=="") { printf "ERROR: no metadata found for %s\n", f > "/dev/null"; err=2; } else { print $0, md} } }' "${FILERMETA}" "${giggleOverlaps}" > "${giggleOverlapsWithMeta}"
fi

## split overlap results by genomic feature type (classification column in the FILER metadata)
overlapsByFeatureTypeDIR="${outputDir}/overlaps_by_feature_type"
mkdir -p "${overlapsByFeatureTypeDIR}"
outPrefix="${overlapsByFeatureTypeDIR}/filer_overlaps"
LC_ALL=C awk 'BEGIN{ FS="\t"; OFS="\t"; outPrefix="'"${outPrefix}"'"; }
 {
	 if (FNR==1) 
	 {
		 header=$0; # save header; will be printed for each of feature types
		 for (i=1; i<=NF; ++i)
		 {
			 columnIdx[$i]=i;
			 columnNames[i]=$i;
		 }
	   featureCol=columnIdx["classification"];
		 next;
	 }
	 #featureType=$(NF-2);
	 featureType=$featureCol;
	 outfile=(outPrefix "." featureType ".bed");
	 if (features[featureType]!=1)
	 {
		 print header > outfile; # print header for the feature file
		 features[featureType]=1;
	 }
	 print > outfile;
 }' "${giggleOverlapsWithMeta}"

echo "Overlaps (with meta): ${giggleOverlapsWithMeta}"
echo "Overlaps (no meta): ${giggleOverlaps}"
