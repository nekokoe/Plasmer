# Plasmer

[![Anaconda-Plasmer](https://anaconda.org/iskoldt/plasmer/badges/version.svg)](https://anaconda.org/iskoldt/plasmer)
[![Docker-Plasmer](https://img.shields.io/docker/pulls/nekokoe/plasmer.svg)](https://hub.docker.com/r/nekokoe/plasmer)
[![GitHub-Plasmer-last-commit](https://img.shields.io/github/last-commit/nekokoe/Plasmer.svg)](https://github.com/nekokoe/Plasmer)
<img src="https://img.shields.io/github/license/nekokoe/Plasmer.svg"/> 

An accurate and sensitive bacterial plasmid identification tool based on deep machine-learning of shared k-mers and genomic features.

## System Requirements

1. Currently tested on CentOS 7 and Ubuntu 20.04, should be working on other Linux releases
2. A minimum of 32GB system memory is required for kmer-db to load the databases
3. The AVX instruction is required (required by kmer-db)

## Before Running

Please download and decompress our pre-built database. 

The pre-built database are available at [Zenodo](https://doi.org/10.5281/zenodo.7030674) and [Google Drive](https://drive.google.com/drive/folders/1C1XLqTuPVfwyB7N3b5QAU09Rn-Qq7RdD?usp=sharing).

The link contains two file, `plasmerMainDB.tar.xz` and `customizedKraken2DB.tar.xz`. 

Check the sha1sum:

```
$ sha1sum plasmerMainDB.tar.xz 
0b08f5c30d60b137f54de6024ab7557031850db6  plasmerMainDB.tar.xz

$ sha1sum customizedKraken2DB.tar.xz 
b14efdd9232fd5f6d066716bd8e3e6ca80c9c0de  customizedKraken2DB.tar.xz
```

Extract the contents into the same directory, and provide the absolute path of the directory to the -d parameter on the command line.



## Installation

We recommend [run Plasmer with Docker](https://github.com/nekokoe/Plasmer/blob/main/README.md#run-plasmer-with-docker), with Docker you do not need to figure out how to install Plasmer. However, run Plasmer in shell directly on Linux is also feasible.

### Install Plasmer using conda

You can simply install Plasmer using [conda](https://conda.io/):

```
conda install -c iskoldt -c bioconda -c conda-forge -c defaults plasmer
```
### Install Plasmer from scratch

If you do not use conda, here is the tutorial for you to install Plasmer from scratch:

Be sure you installed all the required dependencies first, the required dependencies:

```
seqkit 2.2.0
python 3.10.4 （gzip; os; sys; Bio）
perl v5.26.2
kmer-db 1.9.4
Prodigal V2.6.3
HMMER 3.3.2
BLAST 2.10.1+
INFERNAL 1.1.4
diamond v2.0.8.146
GNU Parallel 20220722
Kraken version 2.1.2
R version 4.2.0 （hash; randomForest 4.7-1.1）
```

Then download Plasmer from GitHub:

```
git clone https://github.com/nekokoe/Plasmer.git
cd Plasmer
export PATH=$PATH:$(pwd)
```

Add the current directory to your PATH environment variable permanently:

```
echo 'export PATH=$PATH:'$(pwd) >> ~/.bashrc && source ~/.bashrc
```

## Usage

```
Plasmer -g input_fasta -p out_prefix -d db -t threads -m minimum_length -l length -o outpath
```

The parameters:

```
-h	--help				Print the help info and exit.

-v	--version			Print the version info.

-g	--genome			The input fasta. [required]

-p	--prefix			The prefix for intermediate files and results. [Default: output]

-d	--db				The path of pre-built Plasmer databases. [required]

-t	--threads			Number of threads. [Default: 8]

-m	--minimum_length	The minimum length(bp) of sequences, the sequences shorter than the length will be dropped. [Default: 500]
		
-l	--length			The length(bp) threshold of sequences as chromosome to filtered. If set 0, no sequence are filtered, all sequences will be predicted. [Default: 500000]

-o	--outpath			The outpath. [required]
```


## Run Plasmer with Docker

With docker, you don't have to install any of the dependencies. See more about [Docker](https://hub.docker.com/repository/docker/nekokoe/plasmer)

Download the Docker image first:

```
docker pull nekokoe/plasmer:latest
```

Assuming the input FASTA file was deposited in `{inputfilepath}`/input.fasta

Run the following command to get result in `{outputfilepath}`

You can replace `input.fasta` with the actual name of your file.

```
docker run -d --rm --name plasmer \
	-v {inputfilepath}:/input \
	-v {outputfilepath}:/output \
	-v {databasepath}:/db \
	 nekokoe/plasmer:latest \
	/bin/sh /scripts/Plasmer \
	-g /input/input.fasta \
	-p {prefix} \
	-d /db \
	-t {threadnumber} \
	-m 500 \
	-l 500000 \
	-o /output
```

Replace with your own input:
`{inputfilepath}`  : Absolute path contains `input.fasta` in your file system

`{outputfilepath}` :  Absolute path for output in your file system

`{databasepath}`   : Absolute path for the downloaded pre-built Plasmer database

`{prefix}`         : Prefix for intermediate and output files

`{threadnumber}`   : Number of CPUs wish to use

### dockerrun_batch.sh

We also provide a bash shell script that runs the Docker for you, if you have many input files in a directory.

```
bash dockerrun_batch.sh /input/files/path /output/files/path /database/path CPU_threads minimum_length length
```

## Output

In the outpath/results, 4 files are generated, including:

`prefix.plasmer.predProb.tsv`

`prefix.plasmer.predClass.tsv`

`prefix.plasmer.predPlasmids.taxon`

`prefix.plasmer.predPlasmids.fa`


Have a look at `result_example` folder of the Github repository:

The `example.plasmer.predProb.tsv`: The probability of each contig classified to chromosome and plasmid.

| Contig | chromosome | plasmid |
| --- | --- | --- |
| contig_1 | 0.832 | 0.168 |
| contig_2 | 0.952 | 0.048 |
| contig_3 | 0.022 | 0.978 |
| contig_4 | 0.984 | 0.016 |
| contig_5 | 0 | 1 |
| contig_6 | 0 | 1 |
| contig_7 | 0.906 | 0.094 |
| contig_8 | 0 | 1 |
| contig_9 | 0.84 | 0.16 |
| contig_10 | 0 | 1 |

The `example.plasmer.predClass.tsv`: The class of each contig.

| Contig | Type |
| --- | --- |
| contig_1 | chromosome |
| contig_2 | chromosome |
| contig_3 | plasmid |
| contig_4 | chromosome |
| contig_5 | plasmid |
| contig_6 | plasmid |
| contig_7 | chromosome |
| contig_8 | plasmid |
| contig_9 | chromosome |
| contig_10 | plasmid |

The `example.plasmer.predPlasmids.taxon`: The taxonomy of each predicted plasmid contig.

| Contig | Taxonomy ID |
| --- | --- |
| contig_1 | Enterococcus faecium (taxid 1352) |
| contig_2 | Enterococcus faecium (taxid 1352) |
| contig_3 | Enterococcus faecium (taxid 1352) |
| contig_4 | Enterococcus faecium (taxid 1352) |
| contig_5 | Enterococcus faecium (taxid 1352) |
| contig_6 | Enterococcus faecium Aus0085 (taxid 1305849) |
| contig_7 | Enterococcus faecium (taxid 1352) |
| contig_8 | Enterococcus faecium (taxid 1352) |
| contig_9 | Enterococcus faecium (taxid 1352) |
| contig_10 | Enterococcus faecium (taxid 1352) |

The `example.plasmer.predPlasmids.fa`: The sequences of predicted plasmid contigs.

## Prediction results of other tools

Download the results of other tools from [Zenodo](https://doi.org/10.5281/zenodo.7763548) or [Google Drive](https://drive.google.com/drive/folders/1AhJ3RYq8alAOMx8QGH0PjePKkB0qP3YP?usp=share_link).

## Feedback

Your feedback, bug-report and suggestions are welcomed to nekokoe (at) qq.com and husn (at) im.ac.cn

## License

This project is licensed under the terms of the MIT license.
