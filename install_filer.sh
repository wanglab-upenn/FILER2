#!/bin/bash
set -eu
set -o pipefail

time_stamp=$( date +%H-%M-%S-%d-%m-%y )
# currently log file will be created in the current directory
logFile="`pwd`/FILER_install.${time_stamp}.$$.log"
exec 3>&1 1> >(awk '{print (strftime("[%m/%d/%Y %H:%M:%S]", systime()) "\t" $0); fflush();}' | tee -i ${logFile}) 2>&1

if [ $# -lt 2 ]; then
	echo "USAGE: $0 <target_annot_dir> <template_metadata_URL> [<force_overwrite] [<force_continue>]"
	exit 1
fi

# input
TARGETDIR=${1:-FILER}
ANNOT_URL=${2:-https://tf.lisanwanglab.org/GADB/metadata/gadb.test.hg19.template}
# hg19: https://tf.lisanwanglab.org/GADB/metadata/filer.latest.hg19.template
# hg38: https://tf.lisanwanglab.org/GADB/metadata/filer.latest.hg19.template

forceOverwrite=${3:-0} # set to 1 to OVERWRITE target dir/delete all data
forceRestart=${4:-0}

# metadata columns to be used for downloading and installing
fnameCol=3 # file name
fsizeCol=18 # file size
fpathCol=19 # file directory
md5Col=24 # file md5 sum
wgetCol=25 # wget command containing file url and target dir (relative path)

echo "Installing FILER" 
echo "Log file: ${logFile}"
echo "Using metadata=${ANNOT_URL}" 

# check if necessary commands are available
set +e
GIGGLE=$(command -v giggle) 
if [ ! -x "${GIGGLE}" ]; then
  echo "ERROR: giggle not found, please make sure giggle is installed and is in the path"
  exit 1
fi
TABIX=$(command -v tabix)
if [ ! -x "${TABIX}" ]; then
  echo "ERROR: tabix not found, please make sure giggle is installed and is in the path"
  exit 1
fi
set -e

# deal with the case when TARGET directory already exists
if [ -d "${TARGETDIR}" ]; then
  if [ "${forceOverwrite}" = 1 ]; then
	  echo "WARNING: OVERWRITING existing directory $TARGETDIR"
	  rm -rf "${TARGETDIR}"/*
	elif [ "${forceRestart}" = 1 ]; then
	  echo "WARNING: CONTINUING within existing directory";
	else
	  echo "Target directory ${TARGETDIR} already exist"
	  echo "Please set forceOverwrite=1 to overwrite this directory."
	  echo "WARNING: with forceOverwrite set to 1 ALL data in the directory will be DELETED."
    echo "Please set forceRestart=1 to continue."
		exit 1
	fi
fi

mkdir -p "${TARGETDIR}"
mkdir -p "${TARGETDIR}/metadata"

ANNOTDIR=$( cd "$TARGETDIR" && pwd ) # get absolute path for TARGET dir 

echo "Install directory=$ANNOTDIR"

# STEP 1. prepare metadata from template (url, or local file)
urlRegex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
isURL=0
if [[ ${ANNOT_URL} =~ ${urlRegex} ]]; then
	  isURL=1
fi

if [ ${isURL} = 1 ]; then
  wget -N "${ANNOT_URL}" -P "$TARGETDIR/metadata/"
else
	# local file is provided: copy it into metadata/ dir
	cp "${ANNOT_URL}" "${TARGETDIR}/metadata/"
fi

# template and final meta files
meta_file_template="$TARGETDIR/metadata/${ANNOT_URL##*/}"
meta_file="${meta_file_template%.template}.tsv"

# replace TARGETDIR placeholder in template with actual FILER directory name
export TARGETDIR="${ANNOTDIR}"
cat "${meta_file_template}" | envsubst > "${meta_file}"

# STEP 2. Download annotation tracks

# FIXME: handle re-download, partial download, .1, .2, etc files
#   DNS failure
# NOTE: cut output is in increasing column number order
# it's important that fnameCol < md5Col < wgetCol
echo "Starting dowloading ..."
tail -n+2 "${meta_file}" | cut -f${fnameCol},${fsizeCol},${md5Col},${wgetCol} | \
	while IFS=$'\t' read -r fname fsize md5 wgetCmd; do
     # download data track
		 url=$( echo "${wgetCmd}" | awk '{print $2}' )
     tgDir=$( echo "${wgetCmd}" | awk '{print $4}')
	   downloadedFile="${tgDir}/${fname}"
		 echo "Dowloading ${url}"
		 if [ -f "${downloadedFile}" ]; then
			 existingFileSize=$( stat "${downloadedFile}" --print "%s\n" )
			 if [ "${existingFileSize}" != "${fsize}" ]; then
				 echo "***WARNING: file size mismatch: ${downloadedFile}"
				 echo "expected file size=${fsize}"
				 echo "existing file size=${existingFileSize}"
				 echo "removing existing file and re-downloading..."
				 rm "${downloadedFile}"
			 fi
		 fi

		 # download file; use time-stamping
		 wget -N "${url}" -P "${tgDir}"

		 # check file size match
		 existingFileSize=$( stat "${downloadedFile}" --print "%s\n" )
		 if [ "${existingFileSize}" != "${fsize}" ]; then
				 echo "***WARNING: file size mismatch: ${downloadedFile}"
				 echo "expected file size=${fsize}"
				 echo "existing file size=${existingFileSize}"
				 exit 1
		 fi

		 # check downloaaded md5 sum against expected md5 sum in metadata
		 md5downloaded=$( md5sum "${downloadedFile}" | awk '{print $1}' )
		 if [ "$md5" != "$md5downloaded" ]; then
       echo "***ERROR: Downloading ${url} failed"
			 echo -e "***Dowloaded file: ${downloadedFile}"
			 echo -e "***md5 mismatch:\nexpected: md5=${md5}\ndownloaded: md5=${md5downloaded}"
			 exit 1
		 fi
	done

echo "Dowloading completed..." 

# STEP 3: Index annotation tracks using Giggle

# Find directories for indexing  
dirList=${ANNOTDIR}/annot.directories_to_index.txt
tail -n+2 "${meta_file}" | cut -f${fpathCol}  | sort -u > "${dirList}"
numDir=$(wc -l "${dirList}" | awk '{print $1}')


ulimit -Sn 65536 # this is very important for large file collections 

echo "Starting Giggle indexing..."
echo "Using ${GIGGLE}"
echo "Found $numDir directories for indexing."

awk '{print ($1 "\t" NR)}' "${dirList}" | \
  while read -r d dirNum; do
		# FIXME: skip directories without bed.gz files for now (e.g., vcf, fasta, etc)
		ls "${d}"/*.bed.gz 1>/dev/null 2>/dev/null || { echo "***WARNING: SKIPPING directory ${d}. NO *.bed.gz files found. No Giggle index will be created"; continue; }

    indexDir="${d}/giggle_index"
    echo "Indexing ${d} [$dirNum/$numDir]"

		# remove index directory if exists
    if [ -d "${indexDir}" ]; then
      rm -r "${indexDir}"
    fi

		# giggle index directory
    "${GIGGLE}" index -s -i "${d}/*.bed.gz" -o "${indexDir}" 
  done

# STEP 4. make tabix index for each individual file
# using -f to overwrite existing index if any
echo "Creating tabix index for individual tracks..."
tail -n+2 "${meta_file}" | \
	awk -F$'\t' 'BEGIN{fnameCol='${fnameCol}'; fpathCol='${fpathCol}';}
               { fname=$fnameCol; fpath=$fpathCol;
								 abspath=(fpath "/" fname);
								 ftype="bed"; if (fname~/.vcf.gz$/) ftype="vcf";
								 print (" " ftype " " abspath)}' | \
		xargs -L 1 "${TABIX}" -f -p

echo "Log file=${logFile}"
