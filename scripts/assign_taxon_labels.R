args <- commandArgs(T)

library(hash)

#kmer-db distance result file
distance <- args[1]
#file containing links between ID and name
id2name <- args[2]
#The output file,assign one or more contigs to a plasmid
outfile <- args[3]

dist <- read.csv(distance,sep=",",header=T,row.names=1)
idname <- read.table(id2name,sep="\t",stringsAsFactors=FALSE,quote="")
head(idname)

#One comma in end of each line, so need delete last column
dist <- dist[,-dim(dist)[2]]
disthash <- hash()
idnamehash <- hash()

for (r in rownames(dist)){
#get the plasmid which has the minimum distance with the contig
	target <- colnames(dist)[which(dist[r,]==min(dist[r,]))]
	print (r)
	print (target)
	print (has.key(target,disthash)[[1]])
	if (length(target)>1){
		target <- target[1]
	}
	print (target)
	if (has.key(target,disthash)[[1]]){
		.set(disthash,keys=target,values=c(disthash[[target]],r))
  	}
	else{
		.set(disthash,keys=target,values=c(r))
	}
}

for (i in 1:nrow(idname)){
	.set(idnamehash,keys=idname[i,1],values=idname[i,2])
}

for (plasmid in keys(disthash)){
	contigs <- paste(disthash[[plasmid]],sep=",")
	name <- idnamehash[[plasmid]]
	print (plasmid)
	print (name)
	out <- matrix(c(name,contigs),nrow=1)
	write.table(out,outfile,append=T,sep="\t",quote=F,col.names=F,row.names=F)
}

