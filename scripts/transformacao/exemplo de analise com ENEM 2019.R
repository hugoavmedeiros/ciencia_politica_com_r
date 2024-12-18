##### Análise ENEM

library("caret") # carregar pacote 

ENEM2019 <- read.csv2('https://raw.githubusercontent.com/hugoavmedeiros/cd_com_r/master/bases_tratadas/ENEM_ESCOLA_2019.csv')

View(ENEM2019)

ENEM2019 <- read.csv2('bases_tratadas/ENEM_ESCOLA_2019.csv')

View(ENEM2019)

featurePlot(x = ENEM2019[ , c(4, 5, 9)], y = ENEM2019$tipo)

summary(ENEM2019)
str(ENEM2019)

ENEM2019$tipo <- as.factor(ENEM2019$tipo)

featurePlot(x = ENEM2019[ , c(4)], y = ENEM2019$tipo)

featurePlot(x = ENEM2019[ , c(5)], y = ENEM2019$tipo)

featurePlot(x = ENEM2019[ , c(9)], y = ENEM2019$tipo)
