log=verify_log.txt
# total number of files
## expected 5952 =  (26 pop + 5 superpop) x 4 variant types x 24 chr x  2 builds5952
num_vcfs=$( find . -iname "*monomorphic.vcf.gz" | wc -l | awk '{print $1}' )
echo "Found $num_vcfs VCF files (expected = 5952)"

# verify index correcteness using bcftools
find -type f -iname '*.no_monomorphic.vcf.gz' -printf "%p\t%s\n" | while read f size; do n=$(bcftools index --nrecords "${f}"); n=$(( n+0 )); echo -e "${f}\t${n}"; done 2> nrecords_vcf_files.txt.errors 1> nrecords_vcf_files.txt

num_index_errors=$( wc -l nrecords_vcf_files.txt.errors | awk '{print $1}' )
echo "Found $num_index_errors indexing errors"

# verify subjects
# using population-level VCFs
grep -v SUPER 1k_metadata.tsv | while read fname size vartype n nsubj genome chr super pop; do zgrep -m 1 "^#CHROM" "${fname}" | awk 'BEGIN{FS="\t"; OFS="\t"}{for (i=10; i<=NF; ++i) print $i, "'${pop}'", "'${super}'"}'; done > subjects.combined
sort -u subjects.combined.unique

cut -f1-3 raw_hg19/integrated_call_samples_v3.20130502.ALL.panel | sort -u > subjects.raw.unique

diff subjects.combined.unique subjects.raw.unique

grep -v SUPER 1k_metadata.tsv | while read fname size vartype n nsubj genome chr super pop; do zgrep -m 1 "^#CHROM" "${fname}" | awk 'BEGIN{FS="\t";OFS="\t"}{for (i=10; i<=NF; ++i) print $i, "'${pop}'", "'${super}'", "'${chr}'"}'; done > subjects.combined
sort -u subjects.combined | cut -f 4 | freq # this should give same number of subjects (2504) for each chromosome

# verify subjects
# using superpopulation VCFs
grep SUPER 1k_metadata.tsv | while read fname size vartype n nsubj genome chr super pop; do zgrep -m 1 "^#CHROM" "${fname}" | awk 'BEGIN{FS="\t";OFS="\t"}{for (i=10; i<=NF; ++i) print $i, "'${pop}'", "'${super}'"}'; done > subjects.combined.super
cut -f1,3 subjects.combined.super | sort -u > subjects.combined.super.unique
cut -f1,3 raw_hg19/integrated_call_samples_v3.20130502.ALL.panel | sort -u > subjects.raw.super.unique

diff subjects.combined.super.unique subjects.raw.super.unique

