pacman::p_load(
  #ETL
  janitor,
  # DISCRETIZAÇÃO
  ade4,
  arules,
  # FATORES
  forcats)

facebook <- read.table(
  "https://raw.githubusercontent.com/hugoavmedeiros/ciencia_politica_com_r/master/bases_originais/dataset_Facebook.csv", 
  sep=";", 
  header = T)

str(facebook)

# conversão em fatores

for(i in 2:7) {
  facebook[,i] <- as.factor(facebook[,i]) } 

facebook %>% str()

# filtro por tipo de dado

factorsFacebook <- unlist(lapply(facebook, is.factor))  
facebookFactor <- facebook[ , factorsFacebook]
str(facebookFactor)

# One Hot Encoding
facebookDummy <- facebookFactor %>% acm.disjonctif()

# Discretização
inteirosFacebook <- unlist(lapply(facebook, is.integer))  
facebookInteiros <- facebook[, inteirosFacebook]
facebookInteiros %>% str()

facebookInteiros$Page.total.likes.Disc <- discretize(facebookInteiros$Page.total.likes, method = "interval", breaks = 3, labels = c("poucos", 'médio', 'muitos'))

facebookInteiros <- facebookInteiros %>% clean_names() # simplifica nomes usando janitor

facebookInteiros %>% names()

# forcats - usando tidyverse para fatores
fct_count(facebookFactor$Type) # conta os fatores

fct_anon(facebookFactor$Type) # anonimiza os fatores

fct_lump(facebookFactor$Type, n = 1) # reclassifica os fatores em mais comum e outros

