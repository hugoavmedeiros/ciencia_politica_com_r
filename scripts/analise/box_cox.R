##### PREPARAÇÃO #####
# limpar ambiente: rm(list=ls())
### CARREGANDO PACOTES ###
pacman::p_load(dplyr, EnvStats, fastDummies, performance)

### ETL ###
# leitura da base de dados
idepeOriginal <- read.csv2('https://raw.githubusercontent.com/hugoavmedeiros/ciencia_politica_com_r/master/bases_tratadas/idepe_escolas_2019.csv', stringsAsFactors = T, encoding = 'UTF-8') # carregando a base já tratada para o ambiente do R
# remover casos ausentes
idepeOriginal <- idepeOriginal[complete.cases(idepeOriginal), ]
# remover escolas técnicas
idepeTratada <- idepeOriginal %>% dplyr::filter(tp_escola != 'TECNICA')
idepeTratada <- droplevels(idepeTratada)
# criar dummies
idepeTratada <- fastDummies::dummy_cols(idepeTratada)
# remover variáveis que não serão usadas
idepeTratada <- idepeTratada %>% dplyr::select(-c(tp_escola, tp_localizacao, p_em, nota_lp, nota_mt, idepe))
# renomear variáveis
colnames(idepeTratada)[13:17] <- c('Integral', 'Regular', "SemiIntegral", 'Rural', "Urbana")

##### MODELAGEM #####
### REGRESSÃO ###
regIdepeBoth <- step(lm(nota_saep ~ tx_mat_med_int + tx_mat_bas_fem + tx_mat_bas_branca + Integral + Rural, data = idepeTratada), direction = "both")
# análise #
summary(regIdepeBoth)
par(ask = FALSE)
performance::check_model(regIdepeBoth)

# Transformação Box-Cox#
idepeBoxCox <- EnvStats::boxcox(regIdepeBoth, optimize = T)

# Comparação dos resíduos
par(mfrow=c(1,2), ask = FALSE)
plot(regIdepeBoth, which=2, col=c("red"), main = 'Regressão original') 
plot(idepeBoxCox, plot.type = "Q-Q Plots", main = 'Regressão Box Cox')

# Extração de lambda
idepeBoxCox$optimize.bounds
(lambda <- idepeBoxCox$lambda)
idepeTratada$nota_saep_bc <- idepeTratada$nota_saep^lambda

# Comparação das variáveis
par(mfrow=c(1,2), ask = FALSE)
hist(idepeTratada$nota_saep, col='blue', main = 'Variável Original', xlab = 'Nota SAEP')
hist((idepeTratada$nota_saep)^lambda, col='red', main = 'Variável Transformada', xlab = 'Nota SAEP Box-Cox')

# Remodelagem
regIdepeBoxCox <- step(lm((nota_saep^lambda)~ tx_mat_med_int + tx_mat_bas_fem + tx_mat_bas_branca + Integral + Rural, data = idepeTratada), direction = "both")
regIdepeBoxCox2 <- step(lm((nota_saep^lambda-1)/lambda ~ tx_mat_med_int + tx_mat_bas_fem + tx_mat_bas_branca + Integral + Rural, data = idepeTratada), direction = "both")

# Comparação dos resíduos
par(mfrow=c(1,3), ask = FALSE)
plot(regIdepeBoth, which=2, col=c("red"), main = 'Regressão original') 
plot(regIdepeBoxCox, which=2, col=c("blue"), main = 'Regressão Box Cox 1')
plot(regIdepeBoxCox2, which=2, col=c("blue"), main = 'Regressão Box Cox 2')
