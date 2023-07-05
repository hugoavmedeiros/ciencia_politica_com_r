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
idepeOriginal$qt_mat_bas_r <- sqrt(idepeOriginal$qt_mat_bas)

# criar dummies
idepeTratada <- idepeOriginal %>% filter(tp_escola != 'TECNICA')
idepeTratada <- droplevels(idepeTratada)
idepeTratada <- fastDummies::dummy_cols(idepeTratada)
idepeTratada <- idepeTratada %>% dplyr::select(-c(tp_escola, tp_localizacao, p_em, nota_lp, nota_mt, nota_saep, qt_mat_bas, tdi_em, inse))
colnames(idepeTratada)[11:15] <- c('Integral', 'Regular', "SemiIntegral", 'Rural', "Urbana")

##### MODELAGEM #####
### criação dos três modelo iniciais, usando step ###
regIdepeBack <- step(lm(idepe ~ . -cod_escola, data = idepeTratada), direction = "backward")
regIdepeForw <- step(lm(idepe ~ . -cod_escola, data = idepeTratada), direction = "forward")
regIdepeBoth <- step(lm(idepe ~ . -cod_escola, data = idepeTratada), direction = "both")

### comparação dos modelos ###
# sumários
stargazer(regIdepeBack, regIdepeForw, regIdepeBoth, type="text", object.names = TRUE, title="Modelos ENEM", single.row=TRUE)
plot_summs(regIdepeBack, regIdepeForw, regIdepeBoth, model.names = c("Backward", "Forward", "Both"))
# performance
test_performance(regIdepeBack, regIdepeForw, regIdepeBoth)
compare_performance(regIdepeBack, regIdepeForw, regIdepeBoth, rank = TRUE, verbose = FALSE)
plot(compare_performance(regIdepeBack, regIdepeForw, regIdepeBoth, rank = TRUE, verbose = FALSE))

### Diagnóstico ###
# checagem geral #
check_model(regIdepeBoth)
gvlma(regIdepeBoth)
# testes unitários #
shapiro.test(residuals(regIdepeBoth))
check_heteroscedasticity(regIdepeBoth)
check_collinearity(regIdepeBoth)
# outliers #
check_outliers(regIdepeBoth)
avPlots(regIdepeBoth, ask=FALSE, onepage=TRUE, id.method="identify")
influencePlot(regIdepeBoth, id.method="identify", main="Influence Plot", sub="Circle size is proportional to Cook’s distance")
residualPlots(regIdepeBoth)
# predição
rmse(idepeTratada$idepe, predict(regIdepeBoth))
predicaoIdepe <- data.frame(predicao = predict(regIdepeBoth), reais = idepeTratada$idepe)
ggplot(predicaoIdepe, aes(x = predicao, y = reais)) + geom_point() + geom_abline(intercept = 0, slope = 1, color = "red", size = 2)

### Remodelagem ###
summary(regIdepeBoth)
regIdepeBoth2 <- lm(idepe ~ in_eja + tx_mat_bas_fem + tx_mat_bas_branca + mha_em + qt_mat_bas_r + Integral + Rural, data = idepeTratada)
summary(regIdepeBoth2)

###### Correções #####
### Multicolinearidade ###
# Seleção de variáveis por importância
corrplot(cor(idepeTratada))
varImp(regIdepeBoth2)

### Heterocedasticidade ###
# Estimativas robustas
regIdepeBoth2$robse <- vcovHC(regIdepeBoth2, type = "HC1")
coeftest(regIdepeBoth2, regIdepeBoth2$robse)

### Ausência de normalidade ######
# Remoção de outliers #
cooksdIdepe <- cooks.distance(regIdepeBoth2)
obsInfluentes <- cooksdIdepe[cooksdIdepe > 4*mean(cooksdIdepe, na.rm=T)]

idepeTratada %>% slice(c(as.integer(names(obsInfluentes))))

idepeTratada3 <- idepeTratada %>% slice(-c(as.integer(names(obsInfluentes))))

regIdepeBoth3 <- step(lm(idepe ~ in_eja + tx_mat_bas_fem + tx_mat_bas_branca + mha_em + qt_mat_bas_r + Integral + Rural, data = idepeTratada3), direction = "both")
summary(regIdepeBoth3)
check_model(regIdepeBoth3)

# Transformação Box-Cox #
idepeBoxCox <- EnvStats::boxcox(regIdepeBoth2, optimize = T)

par(mfrow=c(1,2))
qqnorm(resid(regIdepeBoth2))
qqline(resid(regIdepeBoth2))
plot(idepeBoxCox, plot.type = "Q-Q Plots", main = 'Normal Q-Q Plot')
par(mfrow=c(1,1))

lambda <- regIdepeBoxCox$lambda

regIdepeBoxCox2 <- lm(((idepe^lambda-1)/lambda) ~ in_eja + tx_mat_bas_fem + tx_mat_bas_branca + mha_em + qt_mat_bas_r + Integral + Rural, data = idepeTratada)

# Bootstraping #
regIdepeBoot <- Boot(regIdepeBoth2, R=199)
summary(regIdepeBoot, high.moments=TRUE)