set -eu
#shopt -s expand_aliases
#$( echo ${BASH_ALIASES[bcftools]}) || $( command -v bcftools )
BCFTOOLS=/mnt/data/bin/bcftools-1.9/bin/bcftools

# 1K directory
kgDir=/mnt/data/hannah/1kg_phase3/

# output files
kg_vcf_metadata=1k_vcf_metadata.txt
kg_bed_metadata=1k_bed_metadata.txt
errorLog=vcf_files.txt.errors
errorLogBed=bed_files.txt.errors

#find ${kgDir}  -type f -iname '*.no_monomorphic.vcf.gz' -printf "%p\t%s\n" | while read f fsize; do nvar=$("${BCFTOOLS}" index --nrecords "${f}"); nvar=$(( nvar+0 )); nsubj=$("${BCFTOOLS}" view -h "${f}" | awk '{if ($1~/^#CHROM/) {print NF-9; exit}}'); nsubj=$(( nsubj+0 )); echo -e "${f}\t${fsize}\t${nvar}\t${nsubj}"; done 2> vcf_files.txt.errors 1> vcf_files.txt

# find -type f -iname '*.no_monomorphic.vcf.gz' -printf "%p\t%s\n" | while read f fsize; do nvar=$(bcftools index --nrecords "${f}"); nvar=$(( nvar+0 )); nsubj=$(bcftools view -h "${f}" | awk '{if ($1~/^#CHROM/) {print NF-9; exit}}'); nsubj=$(( nsubj+0 )); vartype=$( echo "${f}" | awk '{gsub(/^.+\//,""); gsub(/\..+$/,""); n=split($0,a,"_"); vartype=(a[n-1] "_" a[n]); print vartype}'); echo -e "${f}\t${fsize}\t${vartype}\t${nvar}\t${nsubj}"; done 2> vcf_files.txt.errors 1> vcf_files.txt

echo -e "#file_name\tfile_size\tvariant_type\tnum_variants\tnum_subjects\tgenome_build\tchr\tsuper_population\tpopulation" > "${kg_vcf_metadata}"
find "${kgDir}" -type f -iname '*.no_monomorphic.vcf.gz' -printf "%p\t%s\n" | \
	while read f fsize; do 
	  nvar=$("${BCFTOOLS}" index --nrecords "${f}");
	  nvar=$(( nvar+0 ));
	  nsubj=$("${BCFTOOLS}" query -l "${f}" | wc -l);
	  #nsubj=$("${BCFTOOLS}" view -h "${f}" | awk '{if ($1~/^#CHROM/) {print NF-9; exit}}');
	  nsubj=$(( nsubj+0 ));
	  vartype=$( echo "${f}" | awk '{gsub(/^.+\//,""); gsub(/\..+$/,""); n=split($0,a,"_"); vartype=(a[n-1] "_" a[n]); print vartype}');
      read -r genome chr superpop subpop <<< $( echo "${f}" | \
	    awk 'BEGIN{FS="\t";OFS="\t"}
        {
	      fpath=$1; n=split(fpath,a,"/"); fname=a[n];
	      fname_no_ext=fname; gsub(/\..+$/,"", fname_no_ext);
	      split(fname_no_ext, b, "_"); chr=b[1]; superpop=b[2]; vartype=(b[n-1] "_" b[n]);
	      subpop="SUPER";
	      if (a[n-1]=="pop") { genome=a[n-3]; subpop=b[3]; } else {genome=a[n-2];};
	      gsub(/^newVCF/,"",genome);
	      print genome, chr, superpop, subpop
	  }')
	  echo -e "${f}\t${fsize}\t${vartype}\t${nvar}\t${nsubj}\t${genome}\t${chr}\t${superpop}\t${subpop}";
    done 2> "${errorLog}" 1>> "${kg_vcf_metadata}"

num_errors=$(wc -l vcf_files.txt.errors | awk '{print $1}')
if [ $num_errors != 0 ]; then
  echo "${num_errors} errors found. Check ${errorLog} for errors"
  exit 1
fi



<<COMMENT
awk 'BEGIN{FS="\t";OFS="\t"}
     {
	   fpath=$1; n=split(fpath,a,"/"); fname=a[n];
	   fname_no_ext=fname; gsub(/\..+$/,"", fname_no_ext);
	   split(fname_no_ext, b, "_"); chr=b[1]; superpop=b[2]; vartype=(b[n-1] "_" b[n]);
	   subpop="SUPER";
	   if (a[n-1]=="pop") { genome=a[n-3]; subpop=b[3]; } else {genome=a[n-2];};
	   gsub(/^newVCF/,"",genome);
	   print $0, genome, chr, superpop, subpop
     }' vcf_files.txt
COMMENT
