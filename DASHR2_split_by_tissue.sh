dashrDIR="/mnt/data/DASHR2_data"
OUTDIR="DASHR2_tracks_for_GADB"
mkdir -p "${OUTDIR}"
for dsDIR in "${dashrDIR}"/*; do
  ds=${dsDIR##*/} # data source name
  annotTable=${dsDIR}/${ds}.peaks_annot.tsv
  unannotTable=${dsDIR}/${ds}.peaks_unannot.tsv
  # split into individual tracks by tissue
  dsOutDIR="${OUTDIR}/${ds}"
  mkdir -p "${dsOutDIR}"
  awk 'BEGIN{FS="\t"; outDIR="'${dsOutDIR}'";}
       {
         tissue=$55;
         fout=(outDIR "/" tissue "_peaks_annot.bed");
         print > fout;
       }' "${annotTable}"
  awk 'BEGIN{FS="\t"; outDIR="'${dsOutDIR}'";}
       {
         tissue=$55;
         fout=(outDIR "/" tissue "_peaks_unannot.bed");
         print > fout;
       }' "${unannotTable}"
done
