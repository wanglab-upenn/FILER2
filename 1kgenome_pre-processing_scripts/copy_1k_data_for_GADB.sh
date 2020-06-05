mkdir -p /mnt/data2/1kg_phase3_for_GADB/{hg19,hg38} && cat 1k_vcf_metadata.tsv | cut -f1,6 | while read -r f genome; do cp -p "${f}" /mnt/data2/1kg_phase3_for_GADB/${genome}/; done
