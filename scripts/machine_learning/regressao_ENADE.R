pacman::p_load(caret, dplyr, forcats, funModeling)

# 
ENADE2019_PRODUCAO <- read.csv2('https://raw.githubusercontent.com/hugoavmedeiros/cd_com_r/master/bases_tratadas/ENADE2019_PRODUCAO.csv')
status(ENADE2019_PRODUCAO)

# AED 
status(ENADE2019_PRODUCAO) # explorar a qualidade das variáveis

ENADE2019_PRODUCAO[ , c(1,3,4,6:13)] <- lapply(ENADE2019_PRODUCAO[ , c(1,3,4,6:13)], as.factor)

freq(ENADE2019_PRODUCAO) # explorar os fatores

# Pré-processamento
particaoENADE = createDataPartition(1:nrow(ENADE2019_PRODUCAO), p=.7) # cria a partição 70-30
treinoENADE = ENADE2019_PRODUCAO[particaoENEM$Resample1, ] # treino
testeENADE = ENADE2019_PRODUCAO[-particaoENEM$Resample1, ] # - treino = teste

levels(treinoENADE$QE_I17) <- levels(testeENADE$QE_I17)

ENADE2019_PRODUCAO_LM <- lm(NT_GER ~ CO_ORGACAD + NU_IDADE + CO_TURNO_GRADUACAO + QE_I08 + QE_I15, data = treinoENADE)
summary(ENADE2019_PRODUCAO_LM)

plot(ENADE2019_PRODUCAO_LM$residuals, pch = 16, col = "red")

plot(cooks.distance(ENADE2019_PRODUCAO_LM), pch = 16, col = "blue")

###### ETL com a base original

# ENADE2019 <- read.table('bases_originais/3.DADOS/microdados_enade_2019.txt', header = T, sep = ';', dec = ',')
# 
# ENADE2019_PRODUCAO <- ENADE2019 %>% filter(CO_GRUPO == 6208, TP_PRES == 555, CO_UF_CURSO == 26) %>% select(CO_ORGACAD, NU_IDADE, TP_SEXO, CO_TURNO_GRADUACAO, NT_GER, QE_I02, QE_I04, QE_I05, QE_I08, QE_I09, QE_I15, QE_I17, QE_I21)
# 
# status(ENADE2019_PRODUCAO)
# 
# ENADE2019_PRODUCAO[ , c(1,3,4,6:13)] <- lapply(ENADE2019_PRODUCAO[ , c(1,3,4,6:13)], as.factor)
# 
# status(ENADE2019_PRODUCAO)
# 
# levels(ENADE2019_PRODUCAO$CO_TURNO_GRADUACAO)
# 
# ENADE2019_PRODUCAO$CO_TURNO_GRADUACAO <- factor(ENADE2019_PRODUCAO$CO_TURNO_GRADUACAO, levels = c(3, 4), labels=c('Integral', 'Noturno'))
# 
# levels(ENADE2019_PRODUCAO$CO_TURNO_GRADUACAO)
# 
# ENADE2019_PRODUCAO$CO_ORGACAD <- factor(ENADE2019_PRODUCAO$CO_ORGACAD, levels = c(10019, 10020, 10022, 10026, 10028), labels=c('CEFET', 'Centro Universitário', 'Faculdade', 'IF', 'Universidade'))
# 
# write.csv2(ENADE2019_PRODUCAO, "bases_tratadas/ENADE2019_PRODUCAO.csv", row.names = F)