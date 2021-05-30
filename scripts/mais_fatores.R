library(ade4)
library(arules)

facebook <- read.table("bases_originais/dataset_Facebook.csv", sep=";", header = T)
str(facebook)

for(i in 2:7) {
  facebook[,i] <- as.factor(facebook[,i]) } 

str(facebook)

factorsFacebook <- unlist(lapply(facebook, is.factor))  
facebookFactor <- facebook[ , factorsFacebook]
str(facebookFactor)

# One Hot Encoding
facebookDummy <- acm.disjonctif(facebookFactor)

# Discretização
inteirosFacebook <- unlist(lapply(facebook, is.integer))  
facebookInteiros <- facebook[, inteirosFacebook]
str(facebookInteiros)

facebookInteiros$Page.total.likes.Disc <- discretize(facebookInteiros$Page.total.likes, method = "interval", breaks = 3, labels = c("poucos", 'médio', 'muitos'))
