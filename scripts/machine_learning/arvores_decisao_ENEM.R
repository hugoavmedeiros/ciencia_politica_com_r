# pacotes
pacman::p_load(
  # ML
  caret, party, randomForest
)

# Github
ENEM_ESCOLA_2019 <- read.csv2('https://raw.githubusercontent.com/hugoavmedeiros/etl_com_r/master/bases_tratadas/ENEM_ESCOLA_2019.csv', stringsAsFactors = T) # carregando a base já tratada para o ambiente do R

# Pré-processamento
particaoENEM = createDataPartition(1:nrow(ENEM_ESCOLA_2019), p=.7) # cria a partição 70-30
treinoENEM = ENEM_ESCOLA_2019[particaoENEM$Resample1, ] # treino
testeENEM = ENEM_ESCOLA_2019[-particaoENEM$Resample1, ] # - treino = teste

# Mineração e predição com Árvores de Decisão
cTreeENEM <- party::ctree(nota ~ tipo + ICG + TDI_03 + MHA_03, treinoENEM) # árvore de decisão com inferência condicional
plot(cTreeENEM) # plot

forestENEM = randomForest(treinoENEM[ , c(3, 5, 11, 15)], treinoENEM[ , 4], ntree = 100, keep.forest=T, keep.inbag = TRUE, importance=T) # floresta aleatória

plot(forestENEM)

varImp(forestENEM, scale = T) # importância de cada variável
varImpPlot(forestENEM, type=2) # importância de cada variável

predicaoForest  = predict(forestENEM, testeENEM) # criar predição
predicaoCTree  = predict(cTreeENEM, testeENEM) # criar predição

postResample(testeENEM[ , 4], predicaoForest) # teste de performance da Floresta Aleatória
postResample(testeENEM[ , 4], predicaoCTree) # teste de performance da Árvore Condicional

## novos dados
novosDados <- data.frame(
  ANO = as.integer(c(2019, 2019)), 
  ID = as.integer(c(9999999, 9999999)),
  tipo = as.factor(c('Regular', 'Federal')),
  media = c(0,0), 
  MED_CAT_0 = c(0,0), 
  MED_01_CAT_0 = c(0,0), 
  MED_02_CAT_0 =c(0,0), 
  TDI_03 = c(23, 7), 
  MED_MHA = c(0,0), 
  MED_01_MHA = c(0,0), 
  MED_02_MHA = c(0,0), 
  MHA_03 = c(9, 8) 
             )
levels(novosDados$tipo) <- levels(testeENEM$tipo)

predict(forestENEM, novosDados)
