# install.packages('pacman') # melhor pacote para trabalhar com pacotes!

# pacotes
pacman::p_load(ade4, car, caret, chunked, data.table, data.tree, dplyr, ff, ffbase, foreign, funModeling, ggparty, ggplot2, ggtree, gplots, LaF, Metrics, party, partykit, permimp,plm, randomForest, rattle, readr, REEMtree, sqldf) # usando o p_load do pacman vc garante que 1) se o pacote estiver instalado, será carregado 2) se não estiver será instalado

# Desktop
ENEM_ESCOLA_2019 <- read.csv2('bases_tratadas/ENEM_ESCOLA_2019.csv', stringsAsFactors = T) # carregando a base já tratada para o ambiente do R

# Github
ENEM_ESCOLA_2019 <- read.csv2('https://raw.githubusercontent.com/hugoavmedeiros/etl_com_r/master/bases_tratadas/ENEM_ESCOLA_2019.csv', stringsAsFactors = T) # carregando a base já tratada para o ambiente do R

# AED 
status(ENEM_ESCOLA_2019) # explorar a qualidade das variáveis
freq(ENEM_ESCOLA_2019) # explorar os fatores

# Pré-processamento
particaoENEM = createDataPartition(1:nrow(ENEM_ESCOLA_2019), p=.7) # cria a partição 70-30
treinoENEM = ENEM_ESCOLA_2019[particaoENEM$Resample1, ] # treino
testeENEM = ENEM_ESCOLA_2019[-particaoENEM$Resample1, ] # - treino = teste

# Mineração e predição com Árvores de Decisão
cTreeENEM <- party::ctree(media ~ tipo + TDI_03 + MHA_03, treinoENEM) # árvore de decisão com inferência condicional
plot(cTreeENEM) # plot

forestENEM = randomForest(treinoENEM[ , c(3, 8, 12)], treinoENEM[ , 4], ntree = 100, keep.forest=T, keep.inbag = TRUE, importance=T) # floresta aleatória

plot(forestENEM)

permimp(forestENEM) # importância de cada variável
varImp(forestENEM, scale = T) # importância de cada variável
varImpPlot(forestENEM, type=2) # importância de cada variável

predicaoForest  = predict(forestENEM, testeENEM) # criar predição
predicaoCTree  = predict(cTreeENEM, testeENEM) # criar predição

postResample(testeENEM[ , 4], predicaoForest) # teste de performance da Floresta Aleatória
postResample(testeENEM[ , 4], predicaoCTree) # teste de performance da Árvore Condicional

## novos dados
novosDados <- data.frame(
  ANO = as.integer(2019), 
  ID = as.integer(9999999),
  tipo = as.factor('Regular'),
  media = 0, 
  MED_CAT_0 = 0, 
  MED_01_CAT_0 = 0, 
  MED_02_CAT_0 =0, 
  TDI_03 = 23, 
  MED_MHA = 0, 
  MED_01_MHA = 0, 
  MED_02_MHA = 0, 
  MHA_03 = 9)

levels(novosDados$tipo) <- levels(testeENEM$tipo)

predict(forestENEM, novosDados)
