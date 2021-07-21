[TOC]

# Installation

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
Tabix
```
apt-get install tabix
```
or compile from source
```
git clone https://github.com/samtools/htslib
```

Samtools
```
http://www.htslib.org/download
```

jq
```
wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
chmod a+x jq-linux64
```

Miller/mlr
```
https://github.com/johnkerl/miller
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

To install sample data and test the set up/environment:

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


To install GRCh37/hg19 FILER data:
```
bash install_filer.sh FILER_hg19 https://tf.lisanwanglab.org/GADB/metadata/filer.latest.hg19.template filer.ini
```

To install GRCh38/hg38 FILER data:
```
bash install_filer.sh FILER_hg38 https://tf.lisanwanglab.org/GADB/metadata/filer.latest.hg38.template filer.ini
```

To install custom subset of the FILER data:

1. Download template metafile
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

## Query FILER data 

For the next steps, please make sure to use updated FILER config file with the FILER root directory, FILER metadata, FILER schema file locations specified.

Data querying scripts are available in the *data_querying/* directory of FILER scripts/code repository.
To execute the commands below please `cd` into the folder with FILER scripts (e.g., `FILER_scripts`).

### Find tracks with genomic records overlapping a given genomic region

```
bash data_querying/get_overlapping_tracks_by_coord.sh --region chr1:1103243-1203243 --outputDir query_out --genomeBuild hg19 --configFile filer.ini
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

### Retrieve genomic records from a particular track overlapping a given genomic region

```
bash data_querying/get_data_region.sh --trackID NGEN000601 --region chr1:50000-1500000 --includeMetadata 1 --outputFormat json --configFile filer.ini > out.overlaps.json

bash data_querying/get_data_region.sh --trackID NGEN000601 --region chr1:50000-1500000 --includeMetadata 1 --outputFormat bed --configFile filer.ini > out.overlaps.bed
```

### Retrieve track information (FILER metadata)

```
bash data_querying/get_metadata.sh ".\"Data Source\" == \"ENCODE\" and .\"cell type\" == \"CD14+ monocyte\" " hg19 filer.ini > out.metadata.json
```

