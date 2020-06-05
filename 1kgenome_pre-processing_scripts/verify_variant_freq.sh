#zcat test.bed.gz | awk 'BEGIN{FS="\t"}{split($9,a,"="); gaf=a[2]; split($10,a,"="); gac=a[2]; split($11,a,"="); gan=a[2]; sac=0; split($13,a,";"); for (i in a) {kv=a[i]; split(kv,b,"="); sac+=(b[2]+0);}; san=0; split($14,a,";"); for (i in a) {kv=a[i]; split(kv,b,"="); san+=(b[2]+0)}; pac=0; split($16,a,";"); for (i in a) {kv=a[i]; split(kv,b,"="); pac+=(b[2]+0)}; pan=0; split($17,a,";"); for (i in a) {kv=a[i]; split(kv,b,"="); pan+=(b[2]+0)};  if (!(san==gan && pan==gan && sac==gac && pac==gac && sqrt((gaf-(sac/san))*(gaf-sac/san))<0.0001  && sqrt((gaf-pac/pan)*(gaf-pac/pan))<0.0001)) print gac, gan, sac, san, pac, pan, gaf, sac/san, pac/pan}'
kgDir=/mnt/data/hannah/1kg_phase3

find "${kgDir}" -type f -wholename '*/pop/*_CEU_SNP_biallelic.bed.gz' | \
  while read -r fbed; do
	echo "${fbed}"
    zcat "${fbed}" | awk 'BEGIN{FS="\t"}{split($9,a,"="); gaf=a[2]; split($10,a,"="); gac=a[2]; split($11,a,"="); gan=a[2]; sac=0; split($13,a,";"); for (i in a) {kv=a[i]; split(kv,b,"="); sac+=(b[2]+0);}; san=0; split($14,a,";"); for (i in a) {kv=a[i]; split(kv,b,"="); san+=(b[2]+0)}; pac=0; split($16,a,";"); for (i in a) {kv=a[i]; split(kv,b,"="); pac+=(b[2]+0)}; pan=0; split($17,a,";"); for (i in a) {kv=a[i]; split(kv,b,"="); pan+=(b[2]+0)};  if (!(san==gan && pan==gan && sac==gac && pac==gac && sqrt((gaf-(sac/san))*(gaf-sac/san))<0.0001  && sqrt((gaf-pac/pan)*(gaf-pac/pan))<0.0001)) print "'${fbed}'", gac, gan, sac, san, pac, pan, gaf, sac/san, pac/pan}'
  done
