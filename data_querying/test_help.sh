#!/bin/bash
scriptSummary="This is a test script"
script=$( basename $0 )
scriptDir=$( dirname $0 )
# source help and argument parsing functions
source "${scriptDir}/help.sh"

# script arguments: argument name, required/optional, description, example value, default value
params=( "inBed;;;r;;;input BED file (NOTE: must be in sorted bgzip bed.gz format);;;input.bed.gz;;;''" "giggleIndexDirList;;;o;;;file with the list of giggle-indexed directories to search. NOTE: one giggle index directory (absolute path) per-line;;;giggle_index_dirs.txt;;;''" "configFile;;;r;;;FILER configuration file;;;filer.ini;;;''" "outputDir;;;r;;;output directory;;;filer_out;;;''" )

# optional: HELPNOTES will be printed after arguments
read -r -d '' HELPNOTES << NOTES

NOTE: input BED must be coordinate-sorted and bgzipped. E.g., to prepare a BED file for overlap the following command can be used:
LC_ALL=C sort -k1,1 -k2,2n -k3,3n input.bed | bgzip -c > input.sorted.bed.gz

NOTES

# optional: examples will be printed at the end
read -r -d '' HELPEXAMPLES << EXAMPLES

Examples:

bash filer_overlap.sh --configFile gadb.ini --giggleIndexDirList giggle_index_list.hg19.test.txt --inBed test.hg19.bed.gz --outputDir test_filer_out

EXAMPLES

paramValues=()
SetParams "$@" # parse command-line argument and set all parameters

# print out parameters and their values
for arg in "${paramValues[@]}"; do
  p="${arg%%;;;*}"
	v="${arg#*;;;}"
  echo "$p=$v"
done

