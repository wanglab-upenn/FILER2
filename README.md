[FILER: Functional genomics repository](https://lisanwanglab.org/FILER)

FILER web server: [https://lisanwanglab.org/FILER](https://lisanwanglab.org/FILER)

[TOC]


# About

This repository contains scripts that can be used to 

1. deploy FILER on a local server or cloud; 
2. to prepare and preprocess data for use with FILER;
3. to query FILER track data and metadata (see `data_querying` scripts folder).

# Deploying FILER

FILER supports installation on a local server of [a full copy of all FILER tracks](#markdown-header-deploying-filer) or of [a custom subset of FILER data](#markdown-header-staging-a-custom-subset-of-the-filer-data). For steps/instructions, please see corresponding sections on deploying a full copy of FILER or deploying of a custom subset. Please also refer to the [Hardware](#markdown-header-hardware-requirements) and [Software](#markdown-header-software-requirements) sections for requirements/prerequisites for a successful installation.


## Hardware requirements
1. Storage: Recommended disk space for **full** installation of FILER is 2500 GB for each genome build. **Partial** installation described in [Staging of a subset of FILER data](#markdown-header-staging-a-custom-subset-of-the-filer-data) section will require less space.
 
2. RAM: 64GB (recommended; tested with at least 64GB)
3. CPU: 8-core (recommended; tested on 8-core/16-thread Xeon CPU)  


## Prerequisites

1. Linux/Mac 
2. Bash >=4.3
3. [FILER Giggle](https://github.com/pkuksa/FILER_giggle) >=0.6.3fsb
4. [tabix](https://github.com/samtools/htslib) >=1.12
5. [jq](https://stedolan.github.io/jq/download/) >=1.6.
6. [Miller/mlr](https://github.com/johnkerl/miller) >=3.4.0
7. [samtools](http://www.htslib.org/download) >=1.9
8. Standard tools (awk, wget, git, m5sum)


## Check out FILER installation and data scripts

```
git clone https://bitbucket.org/wanglab-upenn/filer.git FILER_scripts
```

## Check out and install FILER Giggle
FILER Giggle
```
git clone https://github.com/pkuksa/FILER_giggle.git FILER_giggle
cd FILER_giggle
make clean
make
cd ..
```

## Download/install if necessary any missing programs/tools

### Linux

1\. Tabix

```
apt-get install tabix
```

Or for most recent versions:
```
git clone https://github.com/samtools/htslib
and see instructions for installation
```

2\. Samtools

```
apt-get install samtools
```

Or for most recent versions:
```
http://www.htslib.org/download
```

3\. jq

```
apt-get install jq
```

Or download binary:
```
wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
chmod a+x jq-linux64
```

4\. Miller/mlr
```
apt-get install miller
```
Building from source and other installation instructions: 
```
https://miller.readthedocs.io/en/latest/install.html
```

### Mac
Command-line tools:
```
xcode-select --install
```

Homebrew to manage/install missing packages/software:
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Get other necessary tools:
```
brew install openssl
brew install samtools
brew install wget
brew install miller
brew install jq
brew install md5sha1sum
```

Update Bash (recommended):
```
brew install bash
```
This will install updated bash in `/usr/local/bin/bash`.

To change default shell to the updated version:
```
chsh -s /usr/local/bin/bash "$USER"
```

## Setting up configuration file

Example configuration file is provided in *data/filer.example.ini*.
Please set locations of the programs/tools in the config file to the locations in your system.
The configuration files are also used to specify FILER root directory, FILER metadata file, file schema file, and other parameters. NOTE: the FILER data locations can be specified after FILER data has been installed locally (see below).
This configuration file is required to run FILER installation and command line scripts.


``` 
# FILER configuration file
# please set absolute path for binaries/executable, FILER data locations, etc

# 1. necessary executables
# 1.1 giggle, tabix are required for FILER tracks installation (install_filer.sh)
# and for querying FILER data
# for succesfull initial FILER tracks installation, please set the absolute paths for giggle
# NOTE: giggle must be FILER_giggle version (obtained from FILER_giggle github https://github.com/pkuksa/FILER_giggle.git)
BINDIR=/usr/local/bin
GIGGLE="${BINDIR}/giggle"
TABIX="${BINDIR}/tabix"

# 1.2. other binaries
# these will be needed by the scripts for working with/querying FILER track data and metadata
BGZIP="{BINDIR}/bgzip"
SAMTOOLS=${BINDIR}/samtools
JQ="${BINDIR}/jq"
MLR=${BINDIR}/mlr"

# 2. parameters for the local FILER instance
# FILER metadata, and FILER tracks schemas, and FILER root directory parameters will be read and used by all the data access/query scripts
# these parameters can be specified after a full copy or a custom subset of FILER data has been set up
BASEURL=https://lisanwanglab.org/FILER
FILERVERSION=v1
FILERDIR="/mnt/data/FILER"
FILERMETADATA=${FILERDIR}/metadata/FILER_metadata.tsv
FILERTRACKSCHEMAS=${FILERDIR}/metadata/FILER_BED_schema.tsv
```

NOTE: place updated configuration file in the main FILER script folder, e.g., as *filer.ini*.

## Install FILER data

For these steps, please change into FILER scripts folder (`cd FILER_scripts`) to access the installation and data querying scripts (alternatively, provide absolute/relative path to the corresponding FILER script/directory, e.g., as `bash /path/to/the/script.sh`)
Also, please make sure to have an updated FILER config with the paths/locations for all necessary binaries/executables.

### To install sample data and test the set up/environment

1. Install (download and index) sample FILER data: 
```
bash install_filer.sh FILER_test https://tf.lisanwanglab.org/FILER/test_metadata.hg19.template filer.ini
```

2. Download FILER file formats/schemas file:
```
wget https://tf.lisanwanglab.org/GADB/metadata/filer.schemas.latest.tsv -P FILER_test/metadata/ 
``` 
NOTE: the file format/schemas file is necessary for parsing/extracting data from individual tracks; see "Querying FILER data section" below.

3. Update FILER configuration file with the locations of FILER installation directory, metadata, and file format/schema file from above.


### To install GRCh37/hg19 FILER data
```
bash install_filer.sh FILER_hg19 https://tf.lisanwanglab.org/GADB/metadata/filer.latest.hg19.template filer.ini
```

### To install GRCh38/hg38 FILER data
```
bash install_filer.sh FILER_hg38 https://tf.lisanwanglab.org/GADB/metadata/filer.latest.hg38.template filer.ini
```

### To install custom subset of the FILER data

1. Download template metafile, e.g., hg38
```
wget https://tf.lisanwanglab.org/GADB/metadata/filer.latest.hg38.template
```

2. Edit/filter the template file to obtain a desired set of tracks
```
awk 'BEGIN{FS="\t"}{ if (NR==1) {print; next}; dataSource=$2; assay=$16; if (dataSource=="ENCODE" && assay=="ChIP-seq") print; }' filer.latest.hg38.template > filer.encode_chipseq.hg38.template

```

3. Use `install_filer.sh` to check out the desired set of tracks
```
bash install_filer.sh FILER_ENCODE_ChIP_seq_hg38 filer.encode_chipseq.hg38.template filer.ini
```

# Querying FILER data 

For the next steps, please make sure to use updated FILER config file with the FILER root directory, FILER metadata, FILER schema file locations specified.

Data querying scripts are available in the *data_querying/* directory of FILER scripts/code repository.
To execute the commands below please `cd` into the folder with FILER scripts (e.g., `FILER_scripts`).

## Find tracks with genomic records overlapping a given genomic region

```
bash data_querying/get_overlapping_tracks_by_coord.sh --region chr1:1103243-1203243 --outputDir query_out --genomeBuild hg19 --configFile filer.ini
```

Example output:
```
WARNING: list of giggle index directories was not specified. will scan /mnt/data/filer/FILER_test for giggle_index directories
List of directories that will be searched=/mnt/data/filer/query_out/giggle_index_dirs_for_search.hg19.txt

Searched 1,398,285 intervals (10 tracks) in 0.523184 seconds (2,672,644.805652 intervals/sec)

Found 158 overlaps.
Found 10 overlapping tracks.
Per-track overlap counts (tsv): /mnt/data/filer/query_out/overlapping_tracks.txt
Overlapping tracks metadata (tsv): /mnt/data/filer/query_out/overlapping_tracks.metadata.hg19.filtered.tsv
Overlapping tracks metadata (JSON): /mnt/data/filer/query_out/overlapping_tracks.metadata.hg19.filtered.json
Run summary: /mnt/data/filer/query_out/run_summary.txt
```

## Retrieve genomic records from a particular track overlapping a given genomic region

```
bash data_querying/get_data_region.sh --trackID NGEN000601 --region chr1:50000-1500000 --includeMetadata 1 --outputFormat json --configFile filer.ini > out.overlaps.json

bash data_querying/get_data_region.sh --trackID NGEN000601 --region chr1:50000-1500000 --includeMetadata 1 --outputFormat bed --configFile filer.ini > out.overlaps.bed
```

## Retrieve track information (FILER metadata)

```
bash data_querying/get_metadata.sh ".\"Data Source\" == \"ENCODE\" and .\"cell type\" == \"CD14+ monocyte\" " hg19 filer.ini > out.metadata.json
```

# FILER command-line scripts usage

## FILER installation `install_filer.sh` script

To create a local copy of the entire FILER (or of a particular FILER data source(s)) for use with
custom analysis pipelines, the provided `install_filer.sh` script can be used.

The `install_filer.sh` script will 

1. download FILER tracks and re-create FILER directory structure under specified target directory (make sure there is enough space available; See Storage requirements) and
2. index FILER data collections using `giggle`
3. index individual data tracks using `tabix`

### Basic usage:

```
bash install_filer.sh <target_FILER_dir> <FILER_metadata_url|FILER_metadata_file> <FILER_config_file>
```

For example, to install the latest GRCh37/hg19 FILER tracks into FILER/ directory on your server:

```
bash install_filer.sh FILER https://tf.lisanwanglab.org/GADB/metadata/filer.latest.hg19.template filer_config.ini
```

To install the latest GRCh38/hg38 FILER annotation data:
```
bash install_filer.sh FILER https://tf.lisanwanglab.org/GADB/metadata/filer.latest.hg38.template filer_config.ini
```
Similarly, the lifted GRCh38/hg38 FILER data can be installed using
```
bash install_filer.sh FILER https://tf.lisanwanglab.org/GADB/metadata/filer.latest.hg38-lifted.template filer_config.ini
```

For an example of FILER configuration file please see `data/filer.example.ini`. To prepare configuration file for your system, please update this with the locations of executables/software on your system (see also section on [setting up configuration file](#markdown-header-setting-up-configuration-file)).

### Detailed `install_filer.sh` script usage

```
USAGE: install_filer.sh <target_annot_dir> <template_metadata_URL|template_metadata_file> <config_file> < [<force_overwrite>] [<force_continue>] [<skip_download>]

Example:
bash install_filer.sh FILER_test https://tf.lisanwanglab.org/FILER/test_metadata.hg19.template filer.ini
where
1. FILER_test is the target directory for installing FILER data
2. template points to the FILER metadata template file (URL or a local file)
with TARGETDIR placeholder.
   TARGETDIR placeholder in the template file will be replaced with the actual target directory (absolute path) to obtain a complete FILER metadata file.
3. filer.ini is the configuration file with all the necessary parameters and paths for executables
   See data/filer.example.ini for an example of the configuration file.
```

### Staging a custom subset of the FILER data

Downloading and indexing steps (see Deploying section) are guided by the provided metadata template file.
To install/deploy only a specific subset of FILER data, metadata template files containing only tracks of interest can be provided as the input to `install_filer.sh`.

For example, to only deploy GRCh38/hg38 ENCODE ChIP-seq data
please first generate corresponding template file with the desired subset of tracks, e.g., 
```
awk 'BEGIN{FS="\t"}{ if (NR==1) {print; next}; dataSource=$2; assay=$16; if (dataSource=="ENCODE" && assay=="ChIP-seq") print; }' filer.latest.hg38.template > filer.encode_chipseq.hg38.template
```
and use the new template file with the `install_filer.sh`:
```
bash install_filer.sh FILER_ENCODE_ChIP_seq_hg38 filer.encode_chipseq.hg38.template filer_config.ini
```

Similarly, to obtain only GRCh38/hg38 ROADMAP enhancer tracks, prepare a metadata template file containing only the enhancer tracks of interest:
```
awk 'BEGIN{FS="\t"}{ if (NR==1) {print; next}; dataSource=$2; if (dataSource=="ROADMAP_Enhancers") print; }' filer.latest.hg38.template > filer.roadmap_enhancers.hg38.template
```
and use the generated enhancer template file with the `install_filer.sh` to reproduce/download and index ROADMAP enhancer FILER tracks on your system.

NOTE: While FILER data can be stored in any directory with the sufficient space (see Storage requirements)
on the target machine/server (e.g., `/mnt/data/FILER`),
as *absolute paths* are used to create Giggle indexes for FILER datasets,
the data should not be moved to another place after indexing,
otherwise Giggle re-indexing will be required.

## Command-line FILER data access and querying scripts

Command-line scripts for accessing/querying FILER data are available under `data_querying` directory of FILER repository. NOTE: before using command-line scripts, please first [set up a full FILER instance](#markdown-header-deploying-filer) or [stage custom subset FILER data](#markdown-header-staging-a-custom-subset-of-the-filer-data).
Individual track data and track metadata can be accessed using the 
`get_region_data.sh` and `get_metadata.sh` scripts.
Tracks in FILER can also be queried by a genomic interval of interest using the `get_overlapping_tracks_by_coord.sh` script.

### Retrieving track data for a particular genomic region

```
bash data_querying/get_data_region.sh
Script: get_data_region.sh
Summary: return track records overlapping given interval

USAGE: get_data_region.sh --configFile <configFile> --region <region> --trackID <trackID> --includeMetadata <includeMetadata> --outputFormat <outputFormat>
[Required] <configFile> = FILER configuration file. Example: filer.ini. Default: ''
[Required] <region> = genomic coordinates. Example: chr:100000-1300000. Default: ''
[Required] <trackID> = FILER track identifier. Example: NGEN000610. Default: ''
[Optional] <includeMetadata> = binary variable, set to 1 to return track metadata. Example: 0 or 1. Default: 0
[Optional] <outputFormat> = output format. Example: bed or json. Default: bed

Examples:
bash get_data_region.sh --trackID NGEN000611 --region "chr1:50000-1500000" --includeMetadata 0 --outputFormat bed --configFile filer.ini
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

bash get_overlapping_tracks_by_coord.sh --region "chr1:1103243-1103243" --giggleIndexList giggle_index_list.hg19.all.txt --outputDir query_out --genomeBuild hg19 --configFile filer.ini

bash get_overlapping_tracks_by_coord.sh --region "chr1:1103243-1103243" --giggleIndexList giggle_index_list.hg19.all.txt --outputDir query_out --genomeBuild hg19 --configFile filer.ini --filterString ".\"Data Source\" == \"DASHR2\"" --forceOverwrite 1
```

# Frequently Asked Questions (FAQ)

## **Q1**. How can I download individual FILER tracks?

**A1**. Individual tracks can be downloaded in several ways:

1. Using the FILER website: from [Browse page](https://tf.lisanwanglab.org/FILER/browse.php) using provided *Download* links in the *Download file* column of the FILER track table.
2. Using download link provided in the FILER metadata table (see *Processed File Download URL* column, e.g., in [GRCh37/hg19](https://tf.lisanwanglab.org/GADB/metadata/filer.latest.hg19.template) or [GRCh38/hg38](https://tf.lisanwanglab.org/GADB/metadata/filer.latest.hg38.template) FILER metadata tables)

## **Q2**. Running FILER script fails with an error message:
e.g., `declare: -A: invalid option` or `ERROR: Bash version 4+ is required`

**A2**. FILER scripts require Bash v4.3+. Please check `bash --version` and update if necessary (e.g., using `brew install bash` on Mac OS, `yum update bash` on Cent OS, `apt-get install --only-upgrade bash` for Ubuntu)


## **Q3**. How can I download a particular/custom subset of FILER tracks?

1. Using the website: Use data selectors/filters on the [Browse page](https://tf.lisanwanglab.org/FILER/browse.php) to filter tracks down to a desired set.
Then click on *Download* button above the FILER track table to download FILER track metadata for the selected tracks. Column *Processed File Download URL* will contain download URLs for individual tracks, while column *wget command* will contain wget download commands. Importantly, these wget commands will reproduce FILER directory structures/data collections. Alternatively, each track can be downloaded using *Download* link under *Download file* column.


2. Using the command-line: Use `bash install_filer.sh <filer_metadata_template_file>`. Template metadata files are available for all [GRCh37/hg19](https://tf.lisanwanglab.org/GADB/metadata/filer.latest.hg19.template) and [GRCh38/hg38](https://tf.lisanwanglab.org/GADB/metadata/filer.latest.hg38.template) FILER tracks. These template metadata files can be filtered to obtain a desired/specific subset of FILER tracks before running `bash install_filer.sh` (see also the section on [installing a custom subset of FILER tracks](#markdown-header-staging-a-custom-subset-of-the-filer-data) for examples). 

# Citation
If you use FILER functional genomics database in your research, please cite:

P. P. Kuksa, P. Gangadharan, Z. Katanic, L. Kleidermacher, A. Amlie-Wolf, C.-Y. Lee, E. Greenfest-Allen, O. Valladares, Y. Y. Leung, L.-S. Wang. FILER: Integrated, large-scale Functional genomics repository. 2020 [https://doi.org/10.1101/2021.01.22.427681](https://doi.org/10.1101/2021.01.22.427681)
