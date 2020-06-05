# [FILER: Functional genomics repository](https://lisanwanglab.org/FILER)

## About

This repository contains scripts that can be used to deploy FILER and to prepare and preprocess data for use with FILER.

## Deploying FILER

### Requirements:
1. Storage: FILER requires at least XXX GB of disk space for each genome build.
2. Bash
3. [Giggle](https://github.com/chienyuehlee/giggle)
4. [tabix](https://github.com/samtools/htslib)
5. wget
6. md5sum

To create a local copy of FILER (or particular FILER data source) for use with
custom analysis pipelines, `install_annot.sh` script can be used.
This script will 1) download FILER tracks and re-create FILER directory structure under specified target directory and 2) index data using Giggle.

USAGE:
```
bash install_annot.sh <target_FILER_dir> <FILER_metadata_url|FILER_metadata_file>
```

For example, to install latest GRCh37/hg19 FILER tracks into FILER/ directory:

```
bash install_annot.sh FILER https://tf.lisanwanglab.org/FILER/metadata/gadb.latest.hg19.template
```

To install latest GRCh38/hg38 FILER annotation data:
```
bash install_annot.sh FILER https://tf.lisanwanglab.org/FILER/metadata/gadb.latest.hg38.template
```

NOTE: While FILER data can be stored in any directory with sufficient space
on the target machine/server (e.g., `/mnt/data/FILER`),
as *absolute paths* are used to create Giggle indexes,
the data should not be moved to another place after indexing,
otherwise Giggle re-indexing will be required.

