set -eu

#if [ ! -x $(command -v bcftools) ]; then
#  echo "Error: bcftools not found" >&2
#  exit 1
#fi

BCFTOOLS=/mnt/data/bin/bcftools-1.9/bin/bcftools

# 1K directory
kgDir=/mnt/data/hannah/1kg_phase3/

# output files
kg_bed_metadata=1k_bed_metadata.txt
errorLog=bed_files.txt.errors


echo -e "#file_name\tfile_size\tvariant_type\tnum_variants\tgenome_build\tchr" > "${kg_bed_metadata}"
find "${kgDir}" -type f -wholename '*/pop/*_CEU_SNP_biallelic.bed.gz' -printf "%p\t%s\n" | \
	while read -r f fsize; do 
	  #echo "${f}";
	  nvar=$( zgrep -c "$" "${f}" );
	  nvar=$(( nvar+0 ));
      read -r vartype genome chr <<< $( echo "${f}" | \
	    awk 'BEGIN{FS="\t";OFS="\t"}
        {
	      fpath=$1; n=split(fpath,a,"/"); fname=a[n];
	      if (a[n-1]=="pop") { genome=a[n-3]; subpop=b[3]; } else {genome=a[n-2];};
	      fname_no_ext=fname; gsub(/\..+$/,"", fname_no_ext);
	      n=split(fname_no_ext, b, "_");
		  chr=b[1]; superpop=b[2]; vartype=(b[n-1] "_" b[n]);
	      gsub(/^newVCF/,"",genome);
	      print vartype, genome, chr
	  }')
	  echo -e "${f}\t${fsize}\t${vartype}\t${nvar}\t${genome}\t${chr}";
    done 2> "${errorLog}" 1>> "${kg_bed_metadata}"

num_errors=$(wc -l ${errorLog} | awk '{print $1}')
if [ $num_errors != 0 ]; then
  echo "${num_errors} errors found. Check ${errorLog} for errors"
  exit 1
fi

