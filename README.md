# Plasmer

An accurate and sensitive bacterial plasmid identification tool based on deep machine-learning of shared k-mers and genomic features.

## Before running

Please download and decompress our pre-built database. The pre-built database is available at XXX.

## Run Plasmer in shell

We recommend [run Plasmer with Docker](). However, run Plasmer in shell on Linux is feasible. Be sure you installed all the required dependencies:

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

Download Plasmer from github:

```
git clone https://github.com/nekokoe/Plasmer.git
cd Plasmer
```

Usage:

```
yourplasmerpath/Plasmer -g input_fasta -p out_prefix -d db -t threads -o outpath
```

The parameters:

```
-h --help       Print the help info and exit.

-v --version    Print the version info.

-g --genome     The input fasta.

-p --prefix     The prefix for the simulate reads.

-d --db         The path of databases.

-t --threads    Number of threads.

-o --outpath    The outpath.
```

## Run Plasmer with Docker

With docker, you don't have to install any of the dependencies. See more about [Docker](https://www.docker.com/resources/what-container/)

```
docker run -d  --name nekokoe \
	-v {inputfilepath}:/input \
	-v {outputfilepath}:/output \
	-v {databasepath}:/db \
	 nekokoe/plasmer:latest \
	/bin/sh /scripts/Plasmer \
	-g /input/thefastafile \
	-p {prefix} \
	-d /db \
	-t {threadnumber} \
	-o /output
```
