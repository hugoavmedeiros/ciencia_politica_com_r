# carrega as bibliotecas
pacman::p_load(ade4, arules, car, caret, corrplot, data.table, dplyr, DMwR, e1071, forcats, funModeling, ggplot2, mlbench, mltools, randomForest, rattle, tidyverse)

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

prop.table(table(treinoENEM$notaDisc))

# Validação Cruzada: Pré-processamento
# Controle de treinamento
train.control <- trainControl(method = "cv", number = 10, verboseIter = T) # controle de treino

matrizCusto <- matrix(c(0,1,1000,0), ncol = 2)
rownames(matrizCusto) <- levels(treinoENEM$notaDisc)
colnames(matrizCusto) <- levels(treinoENEM$notaDisc)
matrizCusto

ENEM_RF_CLASS <- randomForest(notaDisc ~ EREM + ETE + Federal + Privada + Regular + TDI_03 + MHA_03, data = treinoENEM, method = "cforest", parms = list(loss = matrizCusto))
ENEM_RF_CLASS

ENEM_C5_CLASS <- train(notaDisc ~ EREM + ETE + Federal + Privada + Regular + TDI_03 + MHA_03, data = treinoENEM, method = "C5.0Cost", trControl = train.control)
ENEM_C5_CLASS

predicaoENEM_RF_CLASS = predict(ENEM_RF_CLASS, testeENEM) # criar predição
cmENEM_RF_CLASS <- confusionMatrix(predicaoENEM_RF_CLASS, testeENEM$notaDisc)
cmENEM_RF_CLASS

predicaoENEM_C5_CLASS = predict(ENEM_C5_CLASS, testeENEM) # criar predição
cmENEM_C5_CLASS <- confusionMatrix(predicaoENEM_C5_CLASS, testeENEM$notaDisc)
cmENEM_C5_CLASS
