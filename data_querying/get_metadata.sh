filterString=${1:-".metadata.\"Data source\"==\"DASHR2\""}
genomeBuild=${2:-"hg19"}
outDir=${3:-"out_metadata"}
configFile=${4:-"gadb.ini"}

source "${configFile}"
metadataFile="${FILERMETADATA}"

mkdir -p "${outDir}"

metadataJSONprefix="${outDir}/filer.metadata"

bash make_washu_hub.sh "${metadataFile}" "${metadataJSONprefix}"
outJSON="${metadataJSONprefix}.${genomeBuild}.json"
"${JQ}" '[.[] | select( '"${filterString}"' )]' "${outJSON}" > "${outJSON%.json}.filtered.json"

