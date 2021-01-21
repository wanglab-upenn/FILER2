
#GTEx_eQTL_v6p_signif header (variant_id      gene_id tss_distance    pval_nominal    slope   slope_se        slope_fpkm      slope_fpkm_se   pval_nominal_threshold  min_pval_nominal        pval_beta)
#GADB header (chr     chrStart        chrEnd  allele1 allele2 gene_id tss_distance    pval_nominal    slope   slope_se        slope_fpkm      slope_fpkm_se   pval_nominal_threshold  min_pval_nominal        pval_beta)

#Create headerfile and refer to it in the conversion script below

#headerfile script
zcat v6p.signif_snpgene_pairs.txt.gz | head -n 1 | awk 'BEGIN{OFS="\t"}{printf "chr\tchrStart\tchrEnd\tallele1\tallele2"; for (i=2; i<=NF; ++i) printf "\t%s", $i; printf "\n"}' > GTEx_v6p_signif_headerfile

#Conversion script:
zcat v6p.signif_snpgene_pairs.txt.gz | awk 'BEGIN{FS="\t"; OFS="\t";  headerFile="GTEx_v6p_signif_headerfile"; getline header < headerFile;}{if (NR==1) {print header; next}; n=split($1,a,"_"); chr=("chr" a[1]); chrStart=a[2]-1; chrEnd=a[2]+0; a1=a[3]; a2=a[4]; geneID=$2; printf "%s\t%d\t%d\t%s\t%s\t%s", chr, chrStart, chrEnd, a1, a2, geneID; for (i=3; i<=NF; ++i) printf "\t%s", $i; printf "\n";}'

#after conversion to BED format use GTEx_BED_column_reformatting.sh to rearrange columns for consistency (for v6p_signif, v7(all and signif association), v8(all and signif association))
#each version of GTEx has different formatting structure, we used GTEx v6p_all_association as default format for GADB
