import gzip
import os
import sys
from Bio import SeqIO

genome = sys.argv[1].strip()
seqkit = sys.argv[2].strip()
max_length = sys.argv[3].strip()
min_length = sys.argv[4].strip()
classfile = sys.argv[5].strip()
unclassfasta = sys.argv[6].strip()

w1 = open(classfile,"w")

unclassID = []

with open(seqkit) as r:
	for line in r:
		line = line.strip().split("\t")
		if float(line[1]) > float(min_length) and float(max_length) > 0 and float(line[1]) >= float(max_length):
			w1.write(line[0] + "\t" + "chromosome\n")
		elif float(line[1]) > float(min_length) and float(max_length) > 0 and float(line[1]) < float(max_length):
			unclassID.append(line[0])
		elif float(line[1]) > float(min_length) and float(max_length) == 0:
			unclassID.append(line[0])

w1.close()

w2 = open(unclassfasta,'w')

if genome.endswith('gz'):
	with gzip.open(genome,"rt") as f:
		for record in SeqIO.parse(f,"fasta"):
			if record.id in unclassID:
				SeqIO.write(record,w2,'fasta')
elif genome.endswith('fasta') or genome.endswith('fa') or genome.endswith('fna'):
	for record in SeqIO.parse(genome,"fasta"):
		if record.id in unclassID:
			SeqIO.write(record,w2,'fasta')

w2.close()
