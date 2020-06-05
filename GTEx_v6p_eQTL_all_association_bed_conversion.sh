
#GTEx_eQTL_v6p_all_association header (gene_id variant_id      tss_distance    pval_nominal    slope   slope_se)
#GADB header (chr     chrStart        chrEnd  allele1 allele2 gene_id tss_distance    pval_nominal    slope   slope_se)

#Create headerfile and refer to it in the conversion script below

#headerfile script
zcat v6p.all_snpgene_pairs.txt.gz | head -n 1 | awk 'BEGIN{OFS="\t"}{printf "chr\tchrStart\tchrEnd\tallele1\tallele2"; printf "\t%s", $1; for (i=3; i<=NF; ++i) printf "\t%s", $i; printf "\n"}' > GTEx_v6p_all_headerfile

#Conversion script:
zcat v6p.all_snpgene_pairs.txt.gz | awk 'BEGIN{FS="\t"; OFS="\t";  headerFile="GTEx_v6p_all_headerfile"; getline header < headerFile;}{if (NR==1) {print header; next}; n=split($2,a,"_"); chr=("chr" a[1]); chrStart=a[2]-1; chrEnd=a[2]+0; a1=a[3]; a2=a[4]; geneID=$1; printf "%s\t%d\t%d\t%s\t%s\t%s", chr, chrStart, chrEnd, a1, a2, geneID; for (i=3; i<=NF; ++i) printf "\t%s", $i; printf "\n";}'


#we used v6p_all_association format (column arrangement) for consistency

#each version of GTEx has different formatting structure, we used GTEx v6p_all_association as default format for GADB
