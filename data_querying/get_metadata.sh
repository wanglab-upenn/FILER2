filterString=${1:-"."}
genomeBuild=${2:-"hg19"}
configFile=${3:-"filer.ini"}

if [ $# -lt 3 ]; then
  cat <<HELP
Script: $(basename $0)
Summary: retrieve track metadata for a given genome build and track filter
USAGE: $0 <filter_string> <genome_build> <config_file>
		<filter_string> = jq track filter string. Example ."Data Source" == "DASHR2". Set to "." to retrieve all tracks.
		<genome_build> = hg19|hg38
		<config_file> = FILER config file
Example:
    bash $0 ".\"Data Source\" == \"DASHR2\"" hg19 filer.ini 
HELP
	exit 1
fi

source "${configFile}"
metadataFile="${FILERMETADATA}"
MLR="${MLR}"
JQ="${JQ}"

"${MLR}" --icsv --fs tab --rs lf --ojson --jlistwrap cat "${metadataFile}" | "${JQ}" '[ .[] | select( ."Genome build" == "'"${genomeBuild}"'" and ('"${filterString}"') ) ]'

