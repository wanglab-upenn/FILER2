# to extract enhancers from ROADMAP ChromHMM data
INRM=${1:-E012_15_coreMarks_mnemonics.bed.gz} # input Roadmap BED4 file
zcat "${INRM}" | cut -f 4 | grep -i "enh" 
