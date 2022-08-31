args <- commandArgs(T)

model <- args[1]
contigFeatures<- args[2]

load(model)

library(randomForest)

alldata <- read.table(contigFeatures,sep="\t",header=T,row.names=1)

#colnames(alldata)

data.rf <- useddata.rf

#rownames(useddata.rf$importance)

alldata <- alldata[,rownames(useddata.rf$importance)]

#colnames(alldata)

alldata.pred.class <- predict(data.rf, alldata)
alldata.pred.prob <- predict(data.rf, alldata,type="prob")

write.table(as.data.frame(alldata.pred.class),paste(contigFeatures,".plasmer.predClass.tsv",sep=""),sep="\t",quote=F,col.names=F)
write.table(alldata.pred.prob,paste(contigFeatures,".plasmer.predProb.tsv",sep=""),sep="\t",quote=F,col.names=T)
