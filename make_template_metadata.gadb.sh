# generate a template meta file
# replace filepath prefix with a placeholder variable ($TARGETDIR)
# replace prefix wget -P with a placeholder variable ($TARGETDIR)
set -e
META_FILE=${1:-/mnt/data2/GADB/metadata/GADB_metadata_V1_final_512020.tsv}
OUTPREFIX=${2:-"gadb.latest"}
OUTSUFFIX=${3:-"template"}
echo "META_FILE=${META_FILE}"
echo "Output prefix=${OUTPREFIX}"
echo "Output suffix=${OUTSUFFIX}"

awk 'BEGIN{ FS="\t";OFS="\t";
            outPrefix="'"${OUTPREFIX}"'";
					  outSuffix="'"${OUTSUFFIX}"'"; }
{
	if (FNR==1) {header=$0; next};
  fpathCol=19;
  genomeCol=7;
	genomeBuild=$genomeCol;
	fpath=$fpathCol;

	trackCnts[genomeBuild]++;

	# replace file path prefix with TARGETDIR placeholder
  gsub(/^.+\/GADB\//,"${TARGETDIR}/", fpath);
  $fpathCol=fpath;

  #replace -P GADB/ with -P ${TARGETDIR}/ across all wget commands
  gsub(/-P[[:space:]]+GADB\//,"-P ${TARGETDIR}/", $0);

	# output into separate files for each genome build
  outFile=(outPrefix "." genomeBuild "." outSuffix);
	if (trackCnts[genomeBuild]==1) print header > outFile;
	print > outFile;
}
END{ print "Template files saved:"
     for (gb in trackCnts)
		 {
			 cnt=trackCnts[gb]+0;
       printf "%s.%s.%s\t[%d records]\n", outPrefix, gb, outSuffix, cnt;
			 totalTracks+=cnt;
		 }
		 printf "Total number of records: %s\n", totalTracks;
}' "${META_FILE}"



