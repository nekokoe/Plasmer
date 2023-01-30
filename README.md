# Plasmer

<img src="https://anaconda.org/iskoldt/plasmer/badges/version.svg"/> <img src="https://img.shields.io/docker/pulls/nekokoe/plasmer.svg"/> <img src="https://img.shields.io/github/last-commit/nekokoe/Plasmer.svg"/> <img src="https://img.shields.io/github/license/nekokoe/Plasmer.svg"/> 



An accurate and sensitive bacterial plasmid identification tool based on deep machine-learning of shared k-mers and genomic features.

## System Requirements

1. Currently tested on CentOS 7 and Ubuntu 20.04, should be working on other Linux releases
2. A minimum of 32GB system memory is required for kmer-db to load the databases
3. The AVX instruction is required (required by kmer-db)

## Before Running

Please download and decompress our pre-built database. 

The pre-built database is available at https://doi.org/10.6084/m9.figshare.20709454.

Provide the absolute path of database folder to -d parameter on the command line.

## Run Plasmer in Shell

We recommend [run Plasmer with Docker](https://github.com/nekokoe/Plasmer/blob/main/README.md#run-plasmer-with-docker).


However, run Plasmer in shell directly on Linux is also feasible.

You can simply install Plasmer using conda:

```
conda install -c iskoldt -c bioconda -c conda-forge -c defaults plasmer
```

Or you prefer to download it from github and solve the dependencies yourself.

Download Plasmer from github:

```
git clone https://github.com/nekokoe/Plasmer.git
cd Plasmer
```

The required dependencies:

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

Be sure you installed all the required dependencies, they can also be easily installed by conda:

```
conda env create -f environment.yaml
conda activate plasmer
```

## Usage

```
{absolutePathToPlasmer}/Plasmer -g input_fasta -p out_prefix -d db -t threads -o outpath
```
Replace `{absolutePathToPlasmer}/` with the path to Plasmer script, omit it if you install Plasmer directly using conda.

The parameters:

```
-h --help       Print the help info and exit.

-v --version    Print the version info.

-g --genome     The input fasta. [required]

-p --prefix     The prefix for intermediate files and results. [Default: output]

-d --db         The path of pre-built Plasmer databases. [required]

-t --threads    Number of threads. [Default: 8]

-o --outpath    The outpath. [required]
```


## Run Plasmer with Docker

With docker, you don't have to install any of the dependencies. See more about [Docker](https://hub.docker.com/repository/docker/nekokoe/plasmer)


Assuming the input FASTA file was deposited in `{inputfilepath}`/input.fasta

Run the following command to get result in `{outputfilepath}`

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
	-o /output
```

Replace with your own input:
`{inputfilepath}`  : Absolute path contains `input.fasta` in your file system

`{outputfilepath}` :  Absolute path for output in your file system

`{databasepath}`   : Absolute path for the downloaded pre-built Plasmer database

`{prefix}`         : Prefix for intermediate and output files

`{threadnumber}`   : Number of CPUs wish to use

## Output

In the outpath/results, 4 files are generated, including:

```
  prefix.plasmer.predProb.tsv: The probability of each contig classified to chromosome and plasmid.

  prefix.plasmer.predClass.tsv: The class of each contig.

  prefix.plasmer.predPlasmids.taxon: The taxonomy of each predicted plasmid contig.

  prefix.plasmer.predPlasmids.fa: The sequences of predicted plasmid contigs.
```

## Feedback

Your feedback, bug-report and suggestions are welcomed to nekokoe (at) qq.com and husn (at) im.ac.cn

