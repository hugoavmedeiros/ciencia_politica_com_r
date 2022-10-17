# carrega as bibliotecas
pacman::p_load(ade4, arules, car, caret, corrplot, data.table, dplyr, e1071, forcats, funModeling, ggplot2, mlbench, mltools, randomForest, rattle, tidyverse)

# leitura da base de dados
ENEM_ESCOLA_2019 <- read.csv2('https://raw.githubusercontent.com/hugoavmedeiros/etl_com_r/master/bases_tratadas/ENEM_ESCOLA_2019.csv', stringsAsFactors = T) # carregando a base já tratada para o ambiente do R

# Dummies
ENEM_ESCOLA_2019_D <- acm.disjonctif(as.data.frame(ENEM_ESCOLA_2019$tipo))
names(ENEM_ESCOLA_2019_D) <- c('EREM', 'ETE', 'Federal', 'Privada', 'Regular')

ENEM_ESCOLA_2019 <- cbind(ENEM_ESCOLA_2019, ENEM_ESCOLA_2019_D)

# Discretização
ENEM_ESCOLA_2019$notaDisc <- discretize(ENEM_ESCOLA_2019$nota, method = "interval", breaks = 2, labels = c("baixa", "alta"))

table(ENEM_ESCOLA_2019$notaDisc)

# Treino e Teste: Pré-processamento
particaoENEM = createDataPartition(ENEM_ESCOLA_2019$nota, p=.7, list = F) # cria a partição 70-30
treinoENEM = ENEM_ESCOLA_2019[particaoENEM, ] # treino
testeENEM = ENEM_ESCOLA_2019[-particaoENEM, ] # - treino = teste

table(treinoENEM$notaDisc)

# down / under
treinoENEMDs <- downSample(x = treinoENEM[, -ncol(treinoENEM)], y = treinoENEM$notaDisc)
table(treinoENEMDs$Class)   

# up
treinoENEMUs <- upSample(x = treinoENEM[, -ncol(treinoENEM)], y = treinoENEM$notaDisc)
table(treinoENEMUs$Class)  
