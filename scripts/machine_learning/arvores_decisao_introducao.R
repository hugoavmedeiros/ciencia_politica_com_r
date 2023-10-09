# pacotes
pacman::p_load(
  caret, ggplot2, plotly, rattle
)

# Github
ENEM_ESCOLA_2019 <- read.csv2('https://raw.githubusercontent.com/hugoavmedeiros/etl_com_r/master/bases_tratadas/ENEM_ESCOLA_2019.csv', stringsAsFactors = T) # carregando a base já tratada para o ambiente do R

ENEM_ESCOLA_2019 <- ENEM_ESCOLA_2019 %>% dplyr::filter(tipo != 'Privada')

set.seed(3)

# Pré-processamento
particaoENEM = createDataPartition(1:nrow(ENEM_ESCOLA_2019), p=0.7) # cria a partição 70-30
treinoENEM = ENEM_ESCOLA_2019[particaoENEM$Resample1, ] # treino
testeENEM = ENEM_ESCOLA_2019[-particaoENEM$Resample1, ] # - treino = teste

# Controle de treinamento
train.control <- trainControl(method = "cv", number = 100, verboseIter = T) # controle de treino

# Mineração e predição com Árvores de Decisão
## Árvore de Decisão
ENEM_RPART <- train(
  nota ~ tipo + localizacao + ICG + TDI_03 + MHA_03 + REP_EM,
  data = treinoENEM, 
  method = "rpart", 
  trControl = train.control,
  tuneGrid = expand.grid(cp = c(0.00362, runif(19, 0, 0.25)))
  # , tuneLength = 20
  )

plot(ENEM_RPART)

fancyRpartPlot(ENEM_RPART$finalModel) # desenho da árvore

plot(varImp(ENEM_RPART)) # importância das variáveis

predicaoTree = predict(ENEM_RPART, newdata = testeENEM)

postResample(testeENEM[ , 7], predicaoTree) # teste de performance da Árvore Condicional

base_avaliacao <- data.frame(
  Observado = testeENEM[ , 7],
  Predição = predicaoTree)

predicao_arvore <- base_avaliacao %>% 
  ggplot(aes(x=Observado, y=Predição)) + 
  geom_point() + # cria os pontos
  geom_smooth() # cria a curva de associação
ggplotly(predicao_arvore)
