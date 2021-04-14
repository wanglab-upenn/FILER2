# [FILER: Functional genomics repository](https://lisanwanglab.org/FILER)

FILER web server: [https://lisanwanglab.org/FILER](https://lisanwanglab.org/FILER)

## About

This repository contains scripts that can be used to 

1. deploy FILER on local server or cloud and
2. to prepare and preprocess data for use with FILER.
3. to query FILER track data and metadata (see `data_querying` scripts folder)

## Deploying FILER

### Hardware requirements:
1. Storage: FILER requires at least 2500 GB of disk space for each genome build.
2. RAM: 64GB (recommended minimum; tested with at least 64GB)
3. CPU: 8-core (recommended minimum; tested on 8-core/16-thread Xeon)  

### Software requirements:
1. Operating system: Linux (tested using Ubuntu 16.04, 18.04 and CentOS 7.6).
2. Bash v4.3+
3. [Giggle](https://github.com/pkuksa/FILER_giggle). NOTE: please use the provided updated version Giggle with corrected BED indexing and search.
4. [tabix](https://github.com/samtools/htslib)
5. [samtools](http://www.htslib.org/download)
6. jq
7. mlr
8. wget
9. md5sum

To create a local copy of the entire FILER (or of a particular FILER data source(s)) for use with
custom analysis pipelines, the provided `install_filer.sh` script can be used.
This script will 
1) download FILER tracks and re-create FILER directory structure under specified target directory (make sure there is enough space available; See Storage requirements) and
2) index FILER data collections using Giggle `install_filer.sh`.

USAGE:

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

## Command-line FILER data access

Command-line scripts for accessing/querying FILER data are available under `data_querying` directory of FILER repository.
Individual track data and track metadata can be accessed using the 
`get_region_data.sh` and `get_metadata.sh` scripts.
Tracks in FILER can also be queried by a genomic interval of interest using the `get_overlapping_tracks_by_coord.sh` script.

### Retrieving track data for a particular genomic region

```
bash data_querying/get_data_region.sh
Script: get_data_region.sh
Summary: return track records overlapping given interval

USAGE: get_data_region.sh --configFile <configFile> --region <region> --trackID <trackID> --includeMetadata <includeMetadata> --outputFormat <outputFormat>
[Required] <configFile> = FILER configuration file. Example: gadb.ini. Default: ''
[Required] <region> = genomic coordinates. Example: chr:100000-1300000. Default: ''
[Required] <trackID> = FILER track identifier. Example: NGEN000610. Default: ''
[Optional] <includeMetadata> = binary variable, set to 1 to return track metadata. Example: 0 or 1. Default: 0
[Optional] <outputFormat> = output format. Example: bed or json. Default: bed

Examples:
bash get_data_region.sh --trackID NGEN000611 --region "chr1:50000-1500000" --includeMetadata 0 --outputFormat bed --configFile gadb.ini
```

### Retrieving track metadata

```
bash data_querying/get_metadata.sh
Script: get_metadata.sh
Summary: retrieve track metadata for a given genome build and track filter

USAGE: data_querying/get_metadata.sh <filter_string> <genome_build> <config_file>
	<filter_string> = jq track filter string. Example ."Data Source" == "DASHR2". Set to "." to retrieve all tracks.
	<genome_build> = hg19|hg38
	<config_file> = FILER config file

Example:
    bash data_querying/get_metadata.sh ".\"Data Source\" == \"DASHR2\"" hg19 filer.ini
```

### Retrieving FILER tracks overlapping a given genomic region

```
bash data_querying/get_overlapping_tracks_by_coord.sh
Script: get_overlapping_tracks_by_coord.sh
Summary: return track records overlapping given interval
USAGE: get_overlapping_tracks_by_coord.sh --forceOverwrite <forceOverwrite> --genomeBuild <genomeBuild> --configFile <configFile> --giggleIndexList <giggleIndexList> --filterString <filterString> --region <region> --outputDir <outputDir> --njobs <njobs>
[Required] <configFile> = FILER config file. Example: filer.ini. Default: ''
[Required] <genomeBuild> = genome build. Example: hg19|hg38. Default: ''
[Required] <giggleIndexList> = list of giggle index directories to search. Example: giggle_index_list.txt. Default: ''
[Required] <outputDir> = output directory. Example: query_out. Default: ''
[Required] <region> = genomic region. Example: chr1:1103243-1103332. Default: ''
[Optional] <filterString> = jq track filter string. Example: ."Data Source"=="DASHR2". Default: .
[Optional] <forceOverwrite> = set to 1 to overwrite output directory if it exists. Example: 0|1. Default: 0
[Optional] <njobs> = number of jobs (giggle queries) to run in parallel. Example: 16. Default: 16

Examples:

bash get_overlapping_tracks_by_coord.sh --region "chr1:1103243-1103243" --giggleIndexList giggle_index_list.hg19.all.txt --outputDir query_out --genomeBuild hg19 --configFile gadb.ini

bash get_overlapping_tracks_by_coord.sh --region "chr1:1103243-1103243" --giggleIndexList giggle_index_list.hg19.all.txt --outputDir query_out --genomeBuild hg19 --configFile gadb.ini --filterString ".\"Data Source\" == \"DASHR2\"" --forceOverwrite 1
```

### Setting up configuration file

Example configuration file is given in the provided `data/filer.example.ini`.
Please set locations of the programs/tools in the config file to the locations in your system.
The configuration file is also used to specify FILER data and metadata location and other attributes.

## Citation
If you use FILER functional genomics database in your research, please cite:

P. P. Kuksa, P. Gangadharan, Z. Katanic, L. Kleidermacher, A. Amlie-Wolf, C.-Y. Lee, E. Greenfest-Allen, O. Valladares, Y. Y. Leung, L.-S. Wang. FILER: Integrated, large-scale Functional genomics repository. 2020 [https://doi.org/10.1101/2021.01.22.427681](https://doi.org/10.1101/2021.01.22.427681)
