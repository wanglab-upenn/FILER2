# [FILER: Functional genomics repository](https://lisanwanglab.org/FILER)

FILER web server: [https://lisanwanglab.org/FILER](https://lisanwanglab.org/FILER)

## About

This repository contains scripts that can be used to 

1. deploy FILER on local server or cloud and
2. to prepare and preprocess data for use with FILER.

## Deploying FILER

### Requirements:
1. Storage: FILER requires at least 2500 GB of disk space for each genome build.
2. Operating system: Linux (tested using Ubuntu and CentOS).
3. Bash
4. [Giggle](https://github.com/pkuksa/FILER_giggle). NOTE: please use the provided updated version Giggle with corrected BED indexing and search.
5. [tabix](https://github.com/samtools/htslib)
6. wget
7. md5sum

To create a local copy of the entire FILER (or of a particular FILER data source(s)) for use with
custom analysis pipelines, the provided `install_filer.sh` script can be used.
This script will 
1) download FILER tracks and re-create FILER directory structure under specified target directory (make sure there is enough space available; See Storage requirements) and
2) index FILER data collections using Giggle

`install_filer.sh` USAGE:
```
bash install_filer.sh <target_FILER_dir> <FILER_metadata_url|FILER_metadata_file>
```

For example, to install the latest GRCh37/hg19 FILER tracks into FILER/ directory on your server:

```
bash install_filer.sh FILER https://tf.lisanwanglab.org/GADB/metadata/filer.latest.hg19.template
```

To install the latest GRCh38/hg38 FILER annotation data:
```
bash install_filer.sh FILER https://tf.lisanwanglab.org/GADB/metadata/filer.latest.hg38.template
```
Similarly, the lifted GRCh38/hg38 FILER data can be installed using
```
bash install_filer.sh FILER https://tf.lisanwanglab.org/GADB/metadata/filer.latest.hg38-lifted.template
```

## Staging a custom subset of the FILER data 
Downloading and indexing steps (see Deploying section) are guided by the provided metadata template file.
To install/deploy only a subset of FILER data, metadata template files containing only tracks of interest can be provided as the input to `install_filer.sh`.
For example, to only deploy ENCODE ChIP-seq data
please first generate corresponding template file with the desired subset of tracks, e.g., 
```
awk 'BEGIN{FS="\t"}{ if (NR==1) {print; next}; dataSource=$2; assay=$16; if (dataSource=="ENCODE" && assay=="ChIP-seq") print; }' filer.latest.hg38.template > filer.encode_chipseq.hg38.template
```
and use the new template file with the `install_gadb.sh`:
```
bash install_filer.sh FILER_ENCODE_ChIP_seq filer.encode_chipseq.hg38.template
```

NOTE: While FILER data can be stored in any directory with the sufficient space (see Storage requirements)
on the target machine/server (e.g., `/mnt/data/FILER`),
as *absolute paths* are used to create Giggle indexes for FILER datasets,
the data should not be moved to another place after indexing,
otherwise Giggle re-indexing will be required.

