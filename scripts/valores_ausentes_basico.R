library(data.table)
library(funModeling) 
library(tidyverse) 

idade <- c(floor(runif(70, 0, 80)), NA, NA)
mean(idade)
mean(idade, na.rm = TRUE)

covid19PE <- fread('https://dados.seplag.pe.gov.br/apps/basegeral.csv')

## identificando e removendo valores ausentes
status(covid19PE) # estrutura dos dados (missing etc)

# Complete-case analysis – listwise deletion
dim(covid19PECompleto <- na.omit(covid19PE)) # deixa apenas os casos completos, mas vale a pena?

# Variação de Complete-case analysis – listwise deletion
dim(covid19PECompleto <- covid19PE %>% filter(!is.na(faixa_etaria)))

## estimando se o NA é MCAR, MAR ou MANR
## Shadow Matrix do livro R in Action

data(sleep, package = "VIM") # importa a base sleep

head(sleep) # observa a base

x <- as.data.frame(abs(is.na(sleep))) # cria a matrix sombra
head(x) # observa a matriz sombra

y <- x[which(sapply(x, sd) > 0)] # mantém apenas variáveis que possuem NA
cor(y) # observa a correlação entre variáveis

cor(sleep, y, use="pairwise.complete.obs") # busca padrões entre os valores específicos das variáveis e os NA

## Shadow Matrix da nossa base de covid19 com adaptações

covid19PENA <- as.data.frame(abs(is.na(covid19PE))) # cria a matriz sombra da base de covid19

covid19PENA <- covid19PENA[which(sapply(covid19PENA, sd) > 0)] # mantém variáveis com NA
round(cor(covid19PENA), 3) # calcula correlações

# modificação já que vão temos uma base numérica
covid19PENA <- cbind(covid19PENA, municipio = covid19PE$municipio) # trazemos uma variável de interesse (municípios) de volta pro frame
covid19PENAMun <- covid19PENA %>% group_by(municipio) %>% summarise(across(everything(), list(sum))) # sumarizamos e observamos se os NA se concentram nos municípios com mais casos
