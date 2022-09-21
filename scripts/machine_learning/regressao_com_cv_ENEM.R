# carrega as bibliotecas
pacman::p_load(ade4, car, caret, corrplot, data.table, dplyr, forcats, funModeling, ggplot2, mlbench, mltools, randomForest, rattle, tidyverse)

# leitura da base de dados
ENEM_ESCOLA_2019 <- read.csv2('https://raw.githubusercontent.com/hugoavmedeiros/etl_com_r/master/bases_tratadas/ENEM_ESCOLA_2019.csv', stringsAsFactors = T) # carregando a base já tratada para o ambiente do R

ENEM_ESCOLA_2019_D <- acm.disjonctif(as.data.frame(ENEM_ESCOLA_2019$tipo))
names(ENEM_ESCOLA_2019_D) <- c('EREM', 'ETE', 'Federal', 'Privada', 'Regular')

ENEM_ESCOLA_2019 <- cbind(ENEM_ESCOLA_2019, ENEM_ESCOLA_2019_D)

# AED 
status(ENEM_ESCOLA_2019) # explorar a qualidade das variáveis
freq(ENEM_ESCOLA_2019) # explorar os fatores
plot_num(ENEM_ESCOLA_2019) # exploração das variáveis numéricas
profiling_num(ENEM_ESCOLA_2019) # estatísticas das variáveis numéricas

corrplot(cor(ENEM_ESCOLA_2019[ , c(4:12)])) # correlação entre as variáveis

# Treino e Teste: Pré-processamento
particaoENEM = createDataPartition(ENEM_ESCOLA_2019$nota, p=.7, list = F) # cria a partição 70-30
treinoENEM = ENEM_ESCOLA_2019[particaoENEM, ] # treino
testeENEM = ENEM_ESCOLA_2019[-particaoENEM, ] # - treino = teste

# Validação Cruzada: Pré-processamento
# Controle de treinamento

train.control <- trainControl(method = "cv", number = 10, verboseIter = T) # controle de treino

# Treinamentos
## Regressão Linear
ENEM_LM <- train(nota ~ EREM + ETE + Federal + Privada + Regular + TDI_03 + MHA_03, data = treinoENEM, method = "lm", trControl = train.control)
summary(ENEM_LM) # sumário do modelo linear

## Árvore de Decisão
ENEM_RPART <- train(nota ~ EREM + ETE + Federal + Privada + Regular + TDI_03 + MHA_03, data = treinoENEM, method = "rpart", trControl = train.control)

summary(ENEM_RPART)
fancyRpartPlot(ENEM_RPART$finalModel) # desenho da árvore
plot(varImp(ENEM_RPART)) # importância das variáveis

# Bagging com Floresta Aleatória
ENEM_RF <- train(nota ~ EREM + ETE + Federal + Privada + Regular + TDI_03 + MHA_03, data = treinoENEM, method = "cforest", trControl = train.control)

plot(ENEM_RF) # evolução do modelo
varImp(ENEM_RF, scale = T) # importância de cada variável
plot(varImp(ENEM_RF, scale = T)) # plot de importância

# Boosting com Boosted Generalized Linear Model
ENEM_ADA <- train(nota ~ EREM + ETE + Federal + Privada + Regular + TDI_03 + MHA_03, data = treinoENEM, method = "glmboost", trControl = train.control)

plot(ENEM_ADA) # evolução do modelo
print(ENEM_ADA) # modelo
summary(ENEM_ADA) # sumário

melhor_modelo <- resamples(list(LM = ENEM_LM, RPART = ENEM_RPART, RF = ENEM_RF, ADABOOST = ENEM_ADA))
melhor_modelo

summary(melhor_modelo)

predVals <- extractPrediction(list(ENEM_RF), testX = testeENEM[, c(8, 12, 13:17)], testY = testeENEM$nota) 

plotObsVsPred(predVals)

# MAE = Mean absolute erro (Erro médio absoluto) - Média dos módulos dos resíduos
# RMSE = Root Mean Squared Error (Raiz quadrada do erro-médio) - Média da raiz quadrada do quadrado do resíduo
  # Semelhanças
    # Mesma escala da variável de interesse
    # Quanto menor melhor (orientadas negativamente)
  # Diferenças
    # RMSE capta melhor a variância dos erros
    # MAE é mais simples de interpretar 

plot(erros1 <- c(rep(2,10)))
plot(erros2 <- c(rep(1,5), rep(3,5)))
plot(erros3 <- c(rep(0,8), rep(10,2)))
lista_erros <- matrix(c(sum(erros1)/10,sum(erros2)/10, sum(erros3)/10, sqrt(sum(erros1^2)/10), sqrt(sum(erros2^2)/10), sqrt(sum(erros3^2)/10)), ncol = 2, dimnames = list(c('Erros 1', 'Erros 2', 'Erros 3'), c('MAE', 'RMSE')))
lista_erros
