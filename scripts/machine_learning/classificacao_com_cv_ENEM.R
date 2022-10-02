# carrega as bibliotecas
pacman::p_load(ade4, arules, car, caret, corrplot, data.table, dplyr, e1071, forcats, funModeling, ggplot2, mlbench, mltools, randomForest, rattle, tidyverse)

# leitura da base de dados
ENEM_ESCOLA_2019 <- read.csv2('https://raw.githubusercontent.com/hugoavmedeiros/etl_com_r/master/bases_tratadas/ENEM_ESCOLA_2019.csv', stringsAsFactors = T) # carregando a base já tratada para o ambiente do R

# Dummies
ENEM_ESCOLA_2019_D <- acm.disjonctif(as.data.frame(ENEM_ESCOLA_2019$tipo))
names(ENEM_ESCOLA_2019_D) <- c('EREM', 'ETE', 'Federal', 'Privada', 'Regular')

ENEM_ESCOLA_2019 <- cbind(ENEM_ESCOLA_2019, ENEM_ESCOLA_2019_D)

# Discretização
ENEM_ESCOLA_2019$nota <- discretize(ENEM_ESCOLA_2019$nota, method = "frequency", breaks = 2, labels = c("baixa", "alta"))

# Treino e Teste: Pré-processamento
particaoENEM = createDataPartition(ENEM_ESCOLA_2019$nota, p=.7, list = F) # cria a partição 70-30
treinoENEM = ENEM_ESCOLA_2019[particaoENEM, ] # treino
testeENEM = ENEM_ESCOLA_2019[-particaoENEM, ] # - treino = teste

# Validação Cruzada: Pré-processamento
# Controle de treinamento
train.control <- trainControl(method = "cv", number = 10, verboseIter = T) # controle de treino

# Treinamentos
## Máquina de Vetor se Suporte (SVM)
ENEM_SVM_CLASS <- train(nota ~ EREM + ETE + Federal + Privada + Regular + TDI_03 + MHA_03, data = treinoENEM, method = "svmLinear", trControl = train.control)
ENEM_SVM_CLASS # sumário da máquina de vetor se suporte
plot(varImp(ENEM_SVM_CLASS))

# criar a máquina de vetor de suporte
svmENEMCLass = svm(nota ~ EREM + ETE + Federal + Privada + Regular + TDI_03 + MHA_03, data = treinoENEM, cost = 10, scale = F)
svmENEMCLass
plot(svmENEMCLass, treinoENEM, TDI_03 ~ MHA_03)

## Árvore de Decisão
ENEM_RPART_CLASS <- train(nota ~ EREM + ETE + Federal + Privada + Regular + TDI_03 + MHA_03, data = treinoENEM, method = "rpart", trControl = train.control)

summary(ENEM_RPART_CLASS)
fancyRpartPlot(ENEM_RPART_CLASS$finalModel) # desenho da árvore
plot(varImp(ENEM_RPART_CLASS)) # importância das variáveis

# Bagging com Floresta Aleatória
ENEM_RF_CLASS <- train(nota ~ EREM + ETE + Federal + Privada + Regular + TDI_03 + MHA_03, data = treinoENEM, method = "cforest", trControl = train.control)

plot(ENEM_RF_CLASS) # evolução do modelo
plot(varImp(ENEM_RF_CLASS)) # plot de importância

# Boosting com Boosted Generalized Linear Model
ENEM_ADA_CLASS <- train(nota ~ EREM + ETE + Federal + Privada + Regular + TDI_03 + MHA_03, data = treinoENEM, method = "glmboost", trControl = train.control)

plot(ENEM_ADA_CLASS) # evolução do modelo
print(ENEM_ADA_CLASS) # modelo
summary(ENEM_ADA_CLASS) # sumário

melhor_modelo <- resamples(list(SVM = ENEM_SVM_CLASS, RPART = ENEM_RPART_CLASS, RF = ENEM_RF_CLASS, ADABOOST = ENEM_ADA_CLASS))
melhor_modelo

summary(melhor_modelo)

predVals <- extractPrediction(list(SVM = ENEM_SVM_CLASS, RPART = ENEM_RPART_CLASS, RF = ENEM_RF_CLASS, ADABOOST = ENEM_ADA_CLASS), testX = testeENEM[, c(8, 12:17)], testY = testeENEM$nota) 

plotObsVsPred(predVals)
