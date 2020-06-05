set -eu

BGZIP=$( command -v bgzip )
if [ ! -x "${BGZIP}" ]; then
  echo "ERROR: bgzip not found."
  exit 1
fi

# reformat GTEx file
oldFile=${1:-/mnt/data2/GADB/Annotationtracks/GTEx.save/v7/v7_signif_association/bed16/hg19/Adipose_Subcutaneous.v7.signif_variant_gene_pairs.bed.gz}
#newFile=${2:-/mnt/data2/GADB/Annotationtracks/GTEx/v7/v7_signif_association/bed16/hg19/Adipose_Subcutaneous.v7.signif_variant_gene_pairs.bed.gz}
newFile=${2:-${oldFile/GTEx.save/GTEx}} # new file name is automatically derived from old file

# NOTE: to reformat all files can use xargs
# E.g., 
# find Annotationtracks/GTEx.save/v7/v7_signif_association/bed16/hg19 -iname '*.bed.gz' | xargs -L 1 -P 16 bash fix_gtex_format_v7_v8_signif.sh

#old header (v7, v8):
#chr	chrStart	chrEnd	allele1	allele2	gene_id	tss_distance	ma_samples	ma_count	maf	pval_nominal	slope	slope_se	pval_nominal_threshold	min_pval_nominal	pval_beta

# new header:
#chr	chrStart	chrEnd	allele1	allele2	gene_id	tss_distance	pval_nominal	slope	slope_se	pval_nominal_threshold	min_pval_nominal	pval_beta	ma_samples	ma_count	maf

newHeader="#chr	chrStart	chrEnd	allele1	allele2	gene_id	tss_distance	pval_nominal	slope	slope_se	pval_nominal_threshold	min_pval_nominal	pval_beta	ma_samples	ma_count	maf"

newDir=$(dirname "${newFile}") # new (output) directory
mkdir -p "${newDir}" # make output directory if does not exists
echo -e "Processing: ${oldFile}\nNew file: ${newFile}"


# reformat: update header and rearrange columns
zcat "${oldFile}" | \
  awk 'BEGIN{ FS="\t"; OFS="\t"; }
      { if (NR==1) {print "'"${newHeader}"'"; next}; # update header
		# rearrange columns
	    print $1, $2, $3, $4, $5, $6, $7, $11, $12, $13, $14, $15, $16, $8, $9, $10 }' | \
	${BGZIP} -c > "${newFile}"

# NOTE: both bedtools and tabix support comment/header lines
# original giggle does not support header lines in bed files (only in vcf)
# /mnt/data/bin/giggle/bin/giggle has been fixed (file_read.c, moving past the BED header part) to skip header lines in BED files
