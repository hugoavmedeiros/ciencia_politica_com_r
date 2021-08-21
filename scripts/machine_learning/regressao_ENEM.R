# carrega as bibliotecas
pacman::p_load(car, caret, corrplot, dplyr, forcats, funModeling)

# Github
ENEM_ESCOLA_2019 <- read.csv2('https://raw.githubusercontent.com/hugoavmedeiros/etl_com_r/master/bases_tratadas/ENEM_ESCOLA_2019.csv', stringsAsFactors = T) # carregando a base já tratada para o ambiente do R

# AED 
status(ENEM_ESCOLA_2019) # explorar a qualidade das variáveis
freq(ENEM_ESCOLA_2019) # explorar os fatores
plot_num(ENEM_ESCOLA_2019) # exploração das variáveis numéricas
profiling_num(ENEM_ESCOLA_2019) # estatísticas das variáveis numéricas

# Pré-processamento
particaoENEM = createDataPartition(1:nrow(ENEM_ESCOLA_2019), p=.7) # cria a partição 70-30
treinoENEM = ENEM_ESCOLA_2019[particaoENEM$Resample1, ] # treino
testeENEM = ENEM_ESCOLA_2019[-particaoENEM$Resample1, ] # - treino = teste

ENEM_LM <- lm(media ~ tipo + MED_CAT_0 + MED_01_CAT_0 + MED_02_CAT_0 + TDI_03 + MED_MHA + MED_01_MHA + MED_02_MHA + MHA_03, data = treinoENEM)

summary(ENEM_LM)

corrplot(cor(treinoENEM[ , c(4:12)]))

ENEM_LM <- lm(media ~ tipo + MED_CAT_0 + MED_MHA, data = treinoENEM)

summary(ENEM_LM)

plot(ENEM_LM$residuals, pch = 16, col = "red")

plot(cooks.distance(ENEM_LM), pch = 16, col = "blue")

predicaoLM = predict(ENEM_LM, testeENEM)

postResample(testeENEM[ , 4], predicaoLM)

save(ENEM_LM, file = "modelos/ENEM_LM.RData")
