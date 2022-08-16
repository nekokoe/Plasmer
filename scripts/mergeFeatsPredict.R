args <- commandArgs(T)

print (args)

seqkitfile <- args[1]
chromosomek18 <- args[2]
chrminusplasdbk18 <- args[3]
plasdbk27 <- args[4]
plasdbminuschrk27 <- args[5]
conjugation <- args[6]
mobilization <- args[7]
mpsfile <- args[8]
ncbifam <- args[9]
oritfile <- args[10]
replication <- args[11]
rRNAfeat <- args[12]
out <- args[13]

seqkit <- read.table(seqkitfile,sep="\t")
chrk18 <- read.table(chromosomek18,sep="\t")
cmpk18 <- read.table(chrminusplasdbk18,sep="\t")
plak27 <- read.table(plasdbk27,sep="\t")
pmck27 <- read.table(plasdbminuschrk27,sep="\t")
conj <- read.table(conjugation,sep="\t")
mobi <- read.table(mobilization,sep="\t")
mps <- read.table(mpsfile,sep="\t")
amr <- read.table(ncbifam,sep="\t")
orit <- read.table(oritfile,sep="\t")
repl <- read.table(replication,sep="\t")
rRNA <- read.table(rRNAfeat,sep="\t")

colnames(seqkit) <- c("ID","Length","GC_content","GC_skew")
colnames(chrk18) <- c("ID","r_k18")
colnames(cmpk18) <- c("ID","rmp_k18")
colnames(plak27) <- c("ID","p_k25")
colnames(pmck27) <- c("ID","pmr_k25")
colnames(conj) <- c("ID","ConjAvgScore","ConjAvgEvalue","ConjMaxScore","ConjMaxEvalue","hasConj")
colnames(mobi) <- c("ID","MobiAvgScore","MobiAvgEvalue","MobiMaxScore","MobiMaxEvalue","hasMobi")
colnames(mps) <- c("ID","RDSAvgScore","RDSMaxScore","rdsBias")
colnames(amr) <- c("ID","AMRAvgScore","AMRAvgEvalue","AMRMaxScore","AMRMaxEvalue","hasAMR")
colnames(orit) <- c("ID","OritAvgEvalue","OritMaxEvalue","hasOriT")
colnames(repl) <- c("ID","ReplAvgScore","ReplAvgEvalue","ReplMaxScore","ReplMaxEvalue","hasRepl")
colnames(rRNA) <- c("ID","rRNAAvgEvalue","rRNAMaxEvalue","hasrRNA")


d1 <- merge(seqkit,chrk18,by="ID",all=TRUE)
d2 <- merge(d1,cmpk18,by="ID",all=TRUE)
d3 <- merge(d2,plak27,by="ID",all=TRUE)
d4 <- merge(d3,pmck27,by="ID",all=TRUE)
d5 <- merge(d4,conj,by="ID",all=TRUE)
d6 <- merge(d5,mobi,by="ID",all=TRUE)
d7 <- merge(d6,mps,by="ID",all=TRUE)
d8 <- merge(d7,amr,by="ID",all=TRUE)
d9 <- merge(d8,orit,by="ID",all=TRUE)
d10 <- merge(d9,repl,by="ID",all=TRUE)
d11 <- merge(d10,rRNA,by="ID",all=TRUE)

for (i in colnames(d11)[-1]){
	d11[,i] <- ifelse(is.na(d11[,i]),"0",d11[,i])
}

d11$rp <- as.numeric(d11$r_k18)/(as.numeric(d11$r_k18) + as.numeric(d11$p_k25))

if (! identical(which(is.na(d11$rp)),integer(0))){
	        d11 <- d11[-which(is.na(d11$rp)),]
			print (d11$rp)
}

d11$maxEvalue <- 0

for (i in 1:nrow(d11)){
	                d11$maxEvalue[i] <- max(d11$ConjMaxEvalue[i],d11$MobiMaxEvalue[i],d11$OritMaxEvalue[i],d11$ReplMaxEvalue[i])
}

d11 <- d11[,-c(9,10,14,15,22,23,27,30,31,35)]

write.table(d11,out,sep="\t",quote=F,row.names=F,col.names=T)
