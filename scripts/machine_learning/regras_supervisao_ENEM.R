### Regras de Associação 
pacman::p_load(
  arules, arulesCBA, caret
)

# Github
ENEM_ESCOLA_2019 <- read.csv2('https://raw.githubusercontent.com/hugoavmedeiros/etl_com_r/master/bases_tratadas/ENEM_ESCOLA_2019.csv', stringsAsFactors = T) # carregando a base já tratada para o ambiente do R

ENEM_ESCOLA_2019 <- ENEM_ESCOLA_2019 %>% select(id, tipo, nota, TDI_03, MHA_03) # selecionando variáveis de interesse

# Pré-processamento de variáveis
ENEM_ESCOLA_2019[ , -c(1:2)] <- discretizeDF(ENEM_ESCOLA_2019[ , -c(1:2)]) # transforma variáveis numéricas em fatores

# Pré-processamento de base
particaoENEM = createDataPartition(1:nrow(ENEM_ESCOLA_2019), p=.7) # cria a partição 70-30
treinoENEM = ENEM_ESCOLA_2019[particaoENEM$Resample1, ] # treino
testeENEM = ENEM_ESCOLA_2019[-particaoENEM$Resample1, ] # - treino = teste

treinoENEM <- treinoENEM[ , -1]
testeENEM <- testeENEM[ , -1]

# Modelagem
regrasENEM = arulesCBA::CBA(nota ~ ., treinoENEM, supp=0.001, conf=0.001) 
inspect(regrasENEM$rules)
plot(regrasENEM$rules)

predicaoRegrasENEM <- predict(regrasENEM, testeENEM)

confusionMatrix(predicaoRegrasENEM, testeENEM$nota)
