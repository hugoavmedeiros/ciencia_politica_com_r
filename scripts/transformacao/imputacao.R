library(data.table)

## imputação numérica
# preparação da base, colocando NA aleatórios
irisDT <- iris %>% setDT() #copiar base iris, usando a data.table

(irisNASeed <- round(runif(10, 1, 50))) # criamos 10 valores aleatórios

(irisDT$Sepal.Length[irisNASeed] <- NA) # imputamos NA nos valores aleatórios

# tendência central
library(Hmisc) # biblio que facilita imputação de tendência central
irisDT$Sepal.Length <- impute(irisDT$Sepal.Length, fun = mean) # média
irisDT$Sepal.Length <- impute(irisDT$Sepal.Length, fun = median) # mediana

is.imputed(irisDT$Sepal.Length) # teste se o valor foi imputado
table(is.imputed(irisDT$Sepal.Length)) # tabela de imputação por sim / não

# predição
irisDT$Sepal.Length[irisNASeed] <- NA # recolocamos os NA

regIris <- lm(Sepal.Length ~ ., data = irisDT) # criamos a regressão
irisNAIndex <- is.na(irisDT$Sepal.Length) # localizamos os NA
irisDT$Sepal.Length[irisNAIndex] <- predict(regIris, newdata = irisDT[irisNAIndex, ]) # imputamos os valores preditos

## Hot deck
# imputação aleatória
irisDT$Sepal.Length[irisNASeed] <- NA # recolocamos os NA

(irisDT$Sepal.Length <- impute(irisDT$Sepal.Length, "random")) # fazemos a imputação aleatória

# imputação por instâncias
irisDT$Sepal.Length[irisNASeed] <- NA # recolocamos os NA

library(VIM)
irisDT2 <- kNN(irisDT)
