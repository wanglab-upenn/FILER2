#zcat /mnt/data/hannah/1kg_phase3/newVCFhg19/22/pop/22_EUR_CEU_INDEL_biallelic.no_monomorphic.vcf.gz | awk 'BEGIN{FS="\t"}{if ($1~/^#/) next; ref=$4; ALT=$5; n=split(ALT, a, ","); print "original",ref,ALT; for (i=1; i<=n; ++i) { alt=a[i]; indel_len=sqrt((length(alt)-length(ref))*(length(alt)-length(ref))); total_len+=indel_len;^Crint ref, alt, length(ref), length(alt), indel_len, total_len} }'

indel_vcf=${1:-/mnt/data/hannah/1kg_phase3/newVCFhg19/22/pop/22_EUR_CEU_INDEL_biallelic.no_monomorphic.vcf.gz} 

if [ $# -lt 1 ]; then
  echo "USAGE: $0 <indel_vcf>"
  echo "Ouput: vcf file name\tnumber of indels\ttotal length of indels"
  exit 1
fi

# NOTE: indel length is calculated as abs(length(alt)-length(ref))
# when applied to SNP records this will result in zero (0) length.
zcat "${indel_vcf}"| awk 'BEGIN{FS="\t";OFS="\t"}{if ($1~/^#/) next; ref=$4; ALT=$5; n=split(ALT, a, ","); total_intervals+=n; for (i=1; i<=n; ++i) { alt=a[i]; indel_len=sqrt((length(alt)-length(ref))*(length(alt)-length(ref))); total_len+=indel_len;}}END{print "'${indel_vcf}'", total_intervals, total_len}'

