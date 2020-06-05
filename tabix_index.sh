#tabix – Generic indexer for TAB-delimited genome position files

tabix -p input.bed

#for i in $(ls *bed.gz); do tabix -p bed $i; done
