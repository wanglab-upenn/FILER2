# [FILER: Functional genomics repository](https://lisanwanglab.org/FILER)

FILER web server: [https://lisanwanglab.org/FILER](https://lisanwanglab.org/FILER)

## About

This repository contains scripts that can be used to 

1. deploy FILER on local server or cloud; 
2. to prepare and preprocess data for use with FILER;
3. to query FILER track data and metadata (see `data_querying` scripts folder).

## Deploying FILER <a name="fulldeployment"></a>

FILER supports installation on a local server of [a full copy of all FILER tracks](#fulldeployment) or of [a custom subset of FILER data](#customstaging). For steps/instructions, please see corresponding sections on deploying a full copy of FILER or deploying of a custom subset. Please also refer to the [Hardware](#hardware-req) and [Software](#software-req) sections for requirements/prerequisites for a successful installation.

### Hardware requirements: <a name="hardware-req"></a>
1. Storage: Recommended disk space for **full** installation of FILER is 2500 GB for each genome build. **Partial** installation described in [Staging of a subset of FILER data](#customstaging) section will require less space.
 
2. RAM: 64GB (recommended; tested with at least 64GB)
3. CPU: 8-core (recommended; tested on 8-core/16-thread Xeon CPU)  

### Software requirements: <a name="software-req"></a>
1. Operating system: Linux (tested using Ubuntu 16.04, 18.04 and CentOS 7.6).
**NOTE**: As FILER scripts are Bash-based, Mac OS-based installation are possible, but require updated Bash (v4.3+), wget, and other tools (see below), which can be installed, e.g., using brew (`brew install bash`, `brew install wget`), and from the repositories listed below.
2. Bash v4.3+. NOTE: updated Bash is required.  
3. [Giggle](https://github.com/pkuksa/FILER_giggle). NOTE: please use the provided updated version Giggle with corrected BED indexing and search.
4. [tabix](https://github.com/samtools/htslib)
5. [samtools](http://www.htslib.org/download)
6. [jq](https://stedolan.github.io/jq/download/)
7. [Miller/mlr](https://github.com/johnkerl/miller)
8. wget
9. md5sum
10. git
11. [gawk](https://www.gnu.org/software/gawk/) v4.1+

### Setting up configuration file <a href="#configfile"></a>

An example configuration file is given in the provided `data/filer.example.ini` file.
Please update this file to set locations of the programs/tools in the config file to the locations in your system.
The configuration file is also used to specify FILER data and metadata location and other attributes.
This configuration file is required to run FILER command line scripts.

### Setting-up a full FILER instance
This will create full copy of the FILER on your server/cluster. See [Hardware](#hardware-req) and [Software](#software-req) requirements/prerequisites for successful installation.
To create a local copy of the entire FILER (or of a particular FILER data source(s)) for use with
custom analysis pipelines, the provided `install_filer.sh` script can be used.
The `install_filer.sh` script will 

1. download FILER tracks and re-create FILER directory structure under specified target directory (make sure there is enough space available; See Storage requirements) and
2. index FILER data collections using `giggle`
3. index individual data tracks using `tabix`

Basic usage:

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

For an example of FILER configuration file please see `data/filer.example.ini`. To prepare configuration file for your system, please update this with the locations of executables/software on your system (see also section on [setting up configuration file](#configfile)).

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

## Staging a custom subset of the FILER data <a name="customstaging"></a>

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

## Command-line FILER data access

Command-line scripts for accessing/querying FILER data are available under `data_querying` directory of FILER repository. NOTE: before using command-line scripts, please first [set up a full FILER instance](#fulldeployment) or [stage custom subset FILER data](#customstaging).
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

## Frequently Asked Questions (FAQ)

### **Q1**. How can I download individual FILER tracks?

**A1**. Individual tracks can be downloaded in several ways:

1. Using the FILER website: from [Browse page](https://tf.lisanwanglab.org/FILER/browse.php) using provided *Download* links in the *Download file* column of the FILER track table.
2. Using download link provided in the FILER metadata table (see *Processed File Download URL* column, e.g., in [GRCh37/hg19](https://tf.lisanwanglab.org/GADB/metadata/filer.latest.hg19.template) or [GRCh38/hg39](https://tf.lisanwanglab.org/GADB/metadata/filer.latest.hg38.template) FILER metadata tables)

### **Q2**. Running FILER script fails with an error message:
e.g., `declare: -A: invalid option` or `ERROR: Bash version 4+ is required`

**A2**. FILER scripts require Bash v4.3+. Please check `bash --version` and update if necessary (e.g., using `brew install bash` on Mac OS, `yum update bash` on Cent OS, `apt-get install --only-upgrade bash` for Ubuntu)


### **Q3**. How can I download a particular/custom subset of FILER tracks?

1. Using the website: Use data selectors/filters on the [Browse page](https://tf.lisanwanglab.org/FILER/browse.php) to filter tracks down to a desired set.
Then click on *Download* button above the FILER track table to download FILER track metadata for the selected tracks. Column *Processed File Download URL* will contain download URLs for individual tracks, while column *wget command* will contain wget download commands. Importantly, these wget commands will reproduce FILER directory structures/data collections. Alternatively, each track can be downloaded using *Download* link under *Download file* column.


2. Using the command-line: Use `bash install_filer.sh <filer_metadata_template_file>`. Template metadata files are available for all [GRCh37/hg19](https://tf.lisanwanglab.org/GADB/metadata/filer.latest.hg19.template) and [GRCh38/hg39](https://tf.lisanwanglab.org/GADB/metadata/filer.latest.hg38.template) FILER tracks. These template metadata files can be filtered to obtain a desired/specific subset of FILER tracks before running `bash install_filer.sh` (see also the section on [installing a custom subset of FILER tracks](#customstaging) for examples). 

## Citation
If you use FILER functional genomics database in your research, please cite:

P. P. Kuksa, P. Gangadharan, Z. Katanic, L. Kleidermacher, A. Amlie-Wolf, C.-Y. Lee, E. Greenfest-Allen, O. Valladares, Y. Y. Leung, L.-S. Wang. FILER: Integrated, large-scale Functional genomics repository. 2020 [https://doi.org/10.1101/2021.01.22.427681](https://doi.org/10.1101/2021.01.22.427681)
