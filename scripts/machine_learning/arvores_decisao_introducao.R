# pacotes
pacman::p_load(
  caret, rattle
) 

# Github
ENEM_ESCOLA_2019 <- read.csv2('https://raw.githubusercontent.com/hugoavmedeiros/etl_com_r/master/bases_tratadas/ENEM_ESCOLA_2019.csv', stringsAsFactors = T) # carregando a base já tratada para o ambiente do R

# Pré-processamento
particaoENEM = createDataPartition(1:nrow(ENEM_ESCOLA_2019), p=.7) # cria a partição 70-30
treinoENEM = ENEM_ESCOLA_2019[particaoENEM$Resample1, ] # treino
testeENEM = ENEM_ESCOLA_2019[-particaoENEM$Resample1, ] # - treino = teste

# Mineração e predição com Árvores de Decisão
## Árvore de Decisão
ENEM_RPART <- train(
  nota ~ tipo + ICG + TDI_03 + MHA_03, 
  data = treinoENEM, 
  method = "rpart", 
  trControl = trainControl(method = "cv"))

fancyRpartPlot(ENEM_RPART$finalModel) # desenho da árvore
plot(varImp(ENEM_RPART)) # importância das variáveis

varImp(ENEM_RPART, scale = T) # importância de cada variável

predicaoTree = predict(ENEM_RPART, newdata = testeENEM)

postResample(testeENEM[ , 7], predicaoTree) # teste de performance da Árvore Condicional

