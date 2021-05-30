library(ade4)
library(arules)
library(forcats)

facebook <- read.table("bases_originais/dataset_Facebook.csv", sep=";", header = T)
str(facebook)

# conversão em fatores

for(i in 2:7) {
  facebook[,i] <- as.factor(facebook[,i]) } 

str(facebook)

# filtro por tipo de dado

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

# forcats - usando tidyverse para fatores
fct_count(facebookFactor$Type) # conta os fatores

fct_anon(facebookFactor$Type) # anonimiza os fatores

fct_lump(facebookFactor$Type, n = 1) # reclassifica os fatores em mais comum e outros

