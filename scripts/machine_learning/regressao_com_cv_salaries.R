# carrega as bibliotecas
pacman::p_load(ade4, car, mboost, caret, corrplot, data.table, dplyr, forcats, funModeling, ggplot2, mlbench, mltools, randomForest, rattle, tidyverse)

# carregando base pronta do tidyverse 
salarios <- carData::Salaries

salarios_D <- acm.disjonctif(as.data.frame(salarios$sex))
names(salarios_D) <- c('Female','Male')

salarios <- cbind(salarios, salarios_D)

# AED 
status(salarios) # explorar a qualidade das variáveis
freq(salarios) # explorar os fatores
plot_num(salarios) # exploração das variáveis numéricas
profiling_num(salarios) # estatísticas das variáveis numéricas

corrplot(cor(salarios[ , c(6,3:4)])) # correlação entre as variáveis

# Treino e Teste: Pré-processamento
particao_salarios = createDataPartition(salarios$salary, p=.7, list = F) # cria a partição 70-30
treino_salarios = salarios[particao_salarios, ] # treino
teste_salarios = salarios[-particao_salarios, ] # - treino = teste

# Validação Cruzada: Pré-processamento
# Controle de treinamento

train.control <- trainControl(method = "cv", number = 10, verboseIter = T) # controle de treino

# Treinamentos
## Regressão Linear

salarios_LM <- train(salary ~ yrs.since.phd + yrs.service + Female + Male, data = treino_salarios, method = "lm", trControl = train.control)
summary(salarios_LM) # sumário do modelo linear

## Árvore de Decisão
salarios_RPART <- train(salary ~ yrs.since.phd + yrs.service + Female + Male, data = treino_salarios, method = "rpart", trControl = train.control)

summary(salarios_RPART)
fancyRpartPlot(salarios_RPART$finalModel) # desenho da árvore
plot(varImp(salarios_RPART)) # importância das variáveis

# Bagging com Floresta Aleatória
salarios_RF <- train(salary ~ yrs.since.phd + yrs.service + Female + Male, data = treino_salarios, method = "cforest", trControl = train.control)

plot(salarios_RF) # evolução do modelo
varImp(salarios_RF, scale = T) # importância de cada variável
plot(varImp(salarios_RF, scale = T)) # plot de importância

# Boosting com Boosted Generalized Linear Model
salarios_ADA <- train(salary ~ yrs.since.phd + yrs.service + Female + Male, data = treino_salarios, method = "glmboost", trControl = train.control)

plot(salarios_ADA) # evolução do modelo
print(salarios_ADA) # modelo
summary(salarios_ADA) # sumário

salarios_KNN <- train(salary ~ yrs.since.phd + yrs.service + Female + Male, data = treino_salarios, method = "knn", trControl = train.control)
summary(salarios_LM) # sumário do modelo de vizinhança

melhor_modelo <- resamples(list(LM = salarios_LM, RF = salarios_RF, RPART = salarios_RPART,  ADABOOST = salarios_ADA, KNN = salarios_KNN))
melhor_modelo

summary(melhor_modelo)

predVals <- extractPrediction(list(salarios_KNN), testX = teste_salarios[, c(3, 4, 7, 8)], testY = teste_salarios$salary) 
plotObsVsPred(predVals)
