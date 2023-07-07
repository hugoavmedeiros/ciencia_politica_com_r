##### PREPARAÇÃO #####
### CARREGANDO PACOTES ###
pacman::p_load(ade4, car, caret, corrplot, dplyr, EnvStats, gvlma, jtools, lm.beta, lmtest, MASS, Metrics, performance, sandwich, simpleboot, SmartEDA, sjPlot, stargazer)

### ETL ###
# leitura da base de dados
idepeOriginal <- read.csv2('https://raw.githubusercontent.com/hugoavmedeiros/ciencia_politica_com_r/master/bases_tratadas/idepe_escolas_2019.csv', stringsAsFactors = T, encoding = 'UTF-8') # carregando a base já tratada para o ambiente do R

# explorar dados
ExpData(data=idepeOriginal, type=2)
# remover casos ausentes
idepeOriginal <- idepeOriginal[complete.cases(idepeOriginal), ]

# criar dummies
idepeTratada <- idepeOriginal %>% filter(tp_escola != 'TECNICA')
idepeTratada <- droplevels(idepeTratada)
idepeTratada <- fastDummies::dummy_cols(idepeTratada)
idepeTratada <- idepeTratada %>% dplyr::select(-c(tp_escola, tp_localizacao, p_em, nota_lp, nota_mt, idepe))
colnames(idepeTratada)[13:17] <- c('Integral', 'Regular', "SemiIntegral", 'Rural', "Urbana")

##### MODELAGEM #####
### criação dos três modelo iniciais, usando step ###
regIdepeBack <- step(lm(nota_saep ~ . -cod_escola, data = idepeTratada), direction = "backward")
regIdepeForw <- step(lm(nota_saep ~ . -cod_escola, data = idepeTratada), direction = "forward")
regIdepeBoth <- step(lm(nota_saep ~ . -cod_escola, data = idepeTratada), direction = "both")

### comparação dos modelos ###
# Sumários
stargazer(regIdepeBack, regIdepeForw, regIdepeBoth, type="text", object.names = TRUE, title="Modelos IDEPE", single.row=TRUE)
plot_summs(regIdepeBack, regIdepeForw, regIdepeBoth, model.names = c("Backward", "Forward", "Both"))
# Performance
test_performance(regIdepeBack, regIdepeForw, regIdepeBoth)
compare_performance(regIdepeBack, regIdepeForw, regIdepeBoth, rank = TRUE, verbose = FALSE)
plot(compare_performance(regIdepeBack, regIdepeForw, regIdepeBoth, rank = TRUE, verbose = FALSE))

### Diagnóstico ###
# checagem geral #
check_model(regIdepeBoth)
# testes unitários #
shapiro.test(residuals(regIdepeBoth))
check_heteroscedasticity(regIdepeBoth)
check_collinearity(regIdepeBoth)
# outliers #
check_outliers(regIdepeBoth)
influencePlot(regIdepeBoth, id.method="identify", main="Observações Influentes", sub="Círculo proporcional à distância de Cook")
residualPlots(regIdepeBoth)

### Remodelagem 1 ###
idepeTratada$qt_mat_bas_r <- sqrt(idepeTratada$qt_mat_bas)
idepeTratada <- idepeTratada %>% dplyr::select(-c(qt_mat_bas, tdi_em))

regIdepeBoth2 <- step(lm(nota_saep ~ . -cod_escola, data = idepeTratada), direction = "both")
summary(regIdepeBoth2)

par(ask = FALSE)
check_model(regIdepeBoth2)
residualPlots(regIdepeBoth2)

###### Correções #####
### Multicolinearidade ###
# Seleção de variáveis por importância
par(mfrow = c(1, 1))
corrplot(cor(idepeTratada))
varImp(regIdepeBoth2)

### Remodelagem 2 ###
regIdepeBoth3 <- step(lm(nota_saep ~ tx_mat_med_int + tx_mat_bas_fem + tx_mat_bas_branca + Integral + Rural + qt_mat_bas_r, data = idepeTratada), direction = "both")
summary(regIdepeBoth3)

par(ask = FALSE)
check_model(regIdepeBoth3)
residualPlots(regIdepeBoth3)

### Ausência de normalidade nos resíduos ######
# Remoção de outliers #
cooksdIdepe <- cooks.distance(regIdepeBoth3)
obsInfluentes <- cooksdIdepe[cooksdIdepe > 4*mean(cooksdIdepe, na.rm=T)]

idepeTratada %>% slice(c(as.integer(names(obsInfluentes))))

idepeTratada2 <- idepeTratada %>% slice(-c(as.integer(names(obsInfluentes))))

regIdepeBoth4 <- step(lm(nota_saep ~ tx_mat_med_int + tx_mat_bas_fem + tx_mat_bas_branca + Integral + Rural + qt_mat_bas_r, data = idepeTratada2), direction = "both")
summary(regIdepeBoth4)
check_model(regIdepeBoth4)

# Transformação Box-Cox#
idepeBoxCox <- EnvStats::boxcox(regIdepeBoth3, optimize = T)

par(mfrow=c(1,2), ask = FALSE)
qqnorm(resid(regIdepeBoth3))
qqline(resid(regIdepeBoth3))
plot(idepeBoxCox, plot.type = "Q-Q Plots", main = 'Normal Q-Q Plot')
par(mfrow=c(1,1), ask = FALSE)

lambda <- idepeBoxCox$lambda
lambda

regIdepeBoxCox <- step(lm((nota_saep^lambda-1)/lambda ~ tx_mat_med_int + tx_mat_bas_fem + tx_mat_bas_branca + Integral + Rural + qt_mat_bas_r, data = idepeTratada2), direction = "both")

summary(regIdepeBoxCox)
check_model(regIdepeBoxCox)

# Bootstraping #
regIdepeBoot <- Boot(regIdepeBoth3, R=199)
summary(regIdepeBoot, high.moments=TRUE)

############## EXTRAS #####################
# predição
rmse(idepeTratada$nota_saep, predict(regIdepeBoth))
predicaoIdepe <- data.frame(predicao = predict(regIdepeBoth), reais = idepeTratada$idepe)
ggplot(predicaoIdepe, aes(x = predicao, y = reais)) + geom_point() + geom_abline(intercept = 0, slope = 1, color = "red", size = 2)

### Heterocedasticidade ###
# Estimativas robustas
regIdepeBoth2$robse <- vcovHC(regIdepeBoth3, type = "HC1")
coeftest(regIdepeBoth3, regIdepeBoth3$robse)