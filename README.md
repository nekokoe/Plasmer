# Plasmer

An accurate and sensitive bacterial plasmid identification tool based on deep machine-learning of shared k-mers and genomic features![image](https://user-images.githubusercontent.com/99703980/187062400-d78e0d2c-50c5-4062-8409-ef7f7aa785e2.png)


## Run Plasmer in shell

Be sure you installed all the required dependencies.

Download Plasmer from github:

```
git clone https://github.com/nekokoe/Plasmer.git
cd Plasmer
./Plasmer -h
```

## Run Plasmer by Docker

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
