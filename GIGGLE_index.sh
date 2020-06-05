#giggle/0.6.3

#GIGGLE is a genomics search engine that identifies and ranks the significance of shared genomic loci between query features and thousands of genome interval files.
#GIGGLE has two high-level functions:
#index creates an index from a directory of bgzipped annotations (BED files or VCF files)
#search takes a region or a file of regions and searches them against an index

giggle index -s -i "`pwd`/*.gz" -o "`pwd`/giggle_index"

# giggle-search
# giggle search -i giggle_index -l
