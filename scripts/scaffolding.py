import sys
import os.path
from Bio import SeqIO

plasmidRef = sys.argv[1].strip()
plasdb = sys.argv[2].strip()
plasmidfa = sys.argv[3].strip()
outdir = sys.argv[4].strip()

plasContig = {}
with open(plasmidRef) as r:
	for line in r:
		line = line.strip().split("\t")
		plasmid = line[0]
		contigID = line[1].split(",")
		plasContig[plasmid] = contigID

if not os.path.isdir(outdir):
	os.makedirs(outdir)
	
for k in plasContig.keys():
	if len(plasContig[k])>1:
		os.system("seqkit grep -p {} {} > {}/{}.ref.fa".format(k,plasdb,outdir,k))
		for i in plasContig[k]:
			i = i.split(" ")[0]
			os.system("seqkit grep -p {} {} >> {}/{}.contigs.fa".format(i,plasmidfa,outdir,k))
#		os.system("conda activate ragtag")
		os.system("ragtag.py scaffold -o {}/{}.plasmer.scaffolding.out {}/{}.ref.fa {}/{}.contigs.fa".format(outdir,k,outdir,k,outdir,k))
	else:
		print (k + " " + "only one contig.")	
