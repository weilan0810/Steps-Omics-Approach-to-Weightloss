##  Import phenotype data 
source("http://bioconductor.org/biocLite.R")
biocLite("edgeR")
biocLite("DESeq")
library("edgeR")
setwd('/Users/siyuanxue/Desktop/capstone/pre-PCA')
getwd()
targets <- read.delim("targets.csv", sep=',', stringsAsFactors = FALSE)

## Import gene expression data
allrawdata <- read.delim("fcnt.all.csv", sep=',', check.names=FALSE, stringsAsFactors=FALSE)

## Strip the version numbers from the Ensemble gene IDs 
## “Geneid” is the column name in the fcnt.all.csv for the gene IDs (I.e., first column)
allrawdata$Geneid <- gsub('\\.[0-9]', '', allrawdata$Geneid )

## Create the DGEList object
dimpostdrop=nrow(targets)+1
rawCountData=allrawdata[,2:dimpostdrop]
y <- DGEList(counts=rawCountData,group=targets$StudyGroup)
dim(y)

## Filter low expression tags (i.e., genes) using a fairly restrictive threshold (10/L)
summary(y$samples$lib.size)
L=min(y$samples$lib.size)/1000000
thresh.default=10/L
myCPMthreshold=thresh.default
myCPMthreshold
keep <- rowSums(cpm(y)>myCPMthreshold) >= min(summary(targets$StudyGroup))

y <- y[keep, , keep.lib.sizes=FALSE]
#head(y$counts)
dim(y)

## Re-compute library sizes
y$samples$lib.size <- colSums(y$counts)
y0 = y

## Normalization with TMM. 
y <- calcNormFactors(y, method = "TMM") ## use the threshold filtered data
c=cpm(y)
write.csv(c,file = 'cpm.csv',quote = FALSE)
save(y, file ='y.DGEList.rda')
## Plot the distributions before and after
lcpm <- cpm(y0, log=TRUE)
boxplot(lcpm, las=2, col='blue', main="",names=targets$sampleId, varwidth = TRUE)
abline(h=median(lcpm),col="blue")
title(main="A. Unnormalised data",ylab="Log-cpm")

lcpm <- cpm(y, log=TRUE)
boxplot(lcpm, las=2, col='red', main="", names=targets$sampleId, varwidth = TRUE)
abline(h=median(lcpm),col="blue")
title(main="B. Normalised data",ylab="Log-cpm")