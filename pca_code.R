setwd("/Users/siyuanxue/Desktop/capstone/pre-PCA/pca")
cpm_data <- read.delim("cpm.csv", sep=',', check.names=FALSE, stringsAsFactors=FALSE)
#this place can choose whether use transform or not
pca <- prcomp(t(cpm_data),scale=TRUE)
plot(pca$x[,1],pca$x[,2])
pca.var <- pca$sdev*2
pca.var.per <- round(pca.var/sum(pca.var)*100,1)
barplot(pca.var.per,main="Scree Plot",xlab="principal component",
        ylab="percent variation")
#(pca.var)
write.csv(pca$rotation,file = 'pca_rotation.csv',quote = FALSE)
write.csv(pca.var.per,file = 'pca_var_per.csv',quote = FALSE)
write.csv(pca$x,file = 'pca_x.csv',quote = FALSE)


