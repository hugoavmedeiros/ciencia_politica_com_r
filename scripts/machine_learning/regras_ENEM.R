### Regras de Associação 
pacman::p_load(ade4, arules, arulesCBA, arulesViz, car, caret, chunked, data.table, data.tree, dplyr, ff, ffbase, foreign, funModeling, ggparty, ggplot2, ggtree, gplots, LaF, Metrics, party, partykit, permimp,plm, randomForest, rattle, readr, REEMtree, sqldf)

# Github
ENEM_ESCOLA_2019 <- read.csv2('https://raw.githubusercontent.com/hugoavmedeiros/etl_com_r/master/bases_tratadas/ENEM_ESCOLA_2019.csv', stringsAsFactors = T) # carregando a base já tratada para o ambiente do R

ENEM_ESCOLA_2019 <- ENEM_ESCOLA_2019 %>% select(ID, tipo, media, TDI_03, MHA_03)

ENEM_ESCOLA_2019[ , -1] <- discretizeDF(ENEM_ESCOLA_2019[ , -1])

# Pré-processamento
particaoENEM = createDataPartition(1:nrow(ENEM_ESCOLA_2019), p=.7) # cria a partição 70-30
treinoENEM = ENEM_ESCOLA_2019[particaoENEM$Resample1, ] # treino
testeENEM = ENEM_ESCOLA_2019[-particaoENEM$Resample1, ] # - treino = teste

regrasENEM = arulesCBA::CBA(media ~ ., treinoENEM, supp=0.01, conf=0.01) 
inspect(regrasENEM$rules)
plot(regrasENEM$rules)

predicaoRegrasENEM <- predict(regrasENEM, testeENEM)

confusionMatrix(predicaoRegrasENEM, testeENEM$media)

