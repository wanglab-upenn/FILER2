# to extract enhancers from ROADMAP ChromHMM data

zcat bed.gz | cut -f4 | grep -i "enh" 
