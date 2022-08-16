import sys
from Bio import SeqIO

contigfa = sys.argv[1].strip()
predClass = sys.argv[2].strip()
out = sys.argv[3].strip()

plasID = []
with open(predClass) as f:
	for line in f:
		line = line.strip().split("\t")
		if line[1] == "plasmid":
			plasID.append(line[0])
w = open(out,"w")
for record in SeqIO.parse(contigfa.strip(),"fasta"):
	if record.id in plasID:
		SeqIO.write(record,w,"fasta")
w.close()

