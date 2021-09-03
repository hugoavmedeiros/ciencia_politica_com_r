# carrega as bibliotecas
pacman::p_load(car, caret, corrplot, data.table, dplyr, forcats, funModeling, mltools, tidyverse)

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

corrplot(cor(treinoENEM[ , c(4:12)]))

# Define training control
train.control <- trainControl(method = "boot", number = 100)
train.control <- trainControl(method = "cv", number = 10)
# Train the model
ENEM_LM <- train(media ~ tipo + TDI_03 + MHA_03, data = ENEM_ESCOLA_2019, method = "lm", trControl = train.control)
# Summarize the results
print(ENEM_LM)
summary(ENEM_LM)


