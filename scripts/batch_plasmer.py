import sys
import os

falist = sys.argv[1].strip()
script = sys.argv[2].strip()
model = sys.argv[3].strip()
kmerdb = sys.argv[4].strip()
threads = sys.argv[5].strip()
bash = sys.argv[6].strip()

w = open(bash,"w")
with open(falist) as r:
	for line in r:
		line = line.strip()
		outdir = "/".join(line.split("/")[0:len(line.split("/"))-1])
		prefix = line.split("/")[-1]
		w.write("bash {} -g {} -p {} -m {} -d {} -t {} -o {}".format(script,line,prefix,model,kmerdb,threads,outdir) + "\n")

w.close()
