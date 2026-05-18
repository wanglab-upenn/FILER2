giggleOverlaps=$1
FILERMETA=$2
numInputFields=$3
awk 'BEGIN{FS="\t";OFS="\t"; fileCol='${numInputFields}'+1;}
{ if (FILENAME==ARGV[1]) { if (FNR==1) {metaHeader=$0; next}; fdir=$19; fname=$3; gsub(/[\/]+/,"/",fdir); gsub(/\/$/,"",fdir); fpath=(fdir "/" fname); meta[fpath]=$0; if (fpath~/CADD/) print fpath}
else if (FILENAME==ARGV[2]) { if (FNR==1) { giggleHeader=$0; print giggleHeader, metaHeader; next }; f=$fileCol; gsub(/[\/]+/,"/",f); md=meta[f]; if (md=="") {printf "ERROR: no metadata found for %s\n", f; exit;}; print $0, md} }' "${FILERMETA}" "${giggleOverlaps}" #> "${giggleOverlapsWithMeta}"
