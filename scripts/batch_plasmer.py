import sys
import os

falist = sys.argv[1].strip()
kmerdb = sys.argv[2].strip()
threads = sys.argv[3].strip()
bash = sys.argv[4].strip()

w = open(bash,"w")
with open(falist) as r:
	for line in r:
		line = line.strip()
		outdir = "/".join(line.split("/")[0:len(line.split("/"))-1])
		prefix = line.split("/")[-1]
		w.write("Plasmer -g {} -p {} -d {} -t {} -o {}".format(line,prefix,kmerdb,threads,outdir) + "\n")

w.close()
