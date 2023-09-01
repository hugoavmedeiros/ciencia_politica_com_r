### CARREGANDO PACOTES ###
pacman::p_load(ade4, car, caret, corrplot, dplyr, gvlma, jtools, lm.beta, lmtest, MASS, performance, sandwich, stargazer, sjPlot)

# leitura da base de dados
ENEM_ORIGINAL <- read.csv2('https://raw.githubusercontent.com/hugoavmedeiros/ciencia_politica_com_r/master/bases_tratadas/ENEM_ESCOLA_2019.csv', stringsAsFactors = T, encoding = 'Latin-1') # carregando a base já tratada para o ambiente do R

# filtrar escolas de interesse
ENEM_ESCOLA <- ENEM_ORIGINAL %>% filter(tipo %in% c('Regular', 'EREM'))
ENEM_ESCOLA <- droplevels(ENEM_ESCOLA)

# criar dummies
ENEM_ESCOLA <- fastDummies::dummy_cols(ENEM_ESCOLA)

# tratamento para retirar as variáveis que não serão usadas e lançar o ID como nome da linha
ENEM_ESCOLA <- ENEM_ESCOLA %>% dplyr::select(-c(ano, tipo, localizacao, ICG))
ENEM_ESCOLA$INSE <- scale(ENEM_ESCOLA$INSE)
ENEM_ESCOLA$INSE2 <- ENEM_ESCOLA$INSE^2

# criação dos três modelo iniciais, usando step
regENEMBack <- step(lm(nota ~ . -id, data = ENEM_ESCOLA), direction = "backward")
regENEMForw <- step(lm(nota ~ . -id, data = ENEM_ESCOLA), direction = "forward")
regENEMBoth <- step(lm(nota ~ . -id, data = ENEM_ESCOLA), direction = "both")

# comparação dos modelos usando a função stargazer
stargazer(regENEMBack, regENEMForw, regENEMBoth, type="text", object.names = TRUE, title="Modelos ENEM", single.row=TRUE)

# comapração dos modelos usando métricas auxiliares
test_performance(regENEMBack, regENEMForw, regENEMBoth) # modelos back e both são iguais e superiores
compare_performance(regENEMBack, regENEMForw, regENEMBoth, rank = TRUE, verbose = FALSE) # modelo forw possui performance inferior
plot(compare_performance(regENEMBack, regENEMForw, regENEMBoth, rank = TRUE, verbose = FALSE))

#
plot_summs(regENEMBack, regENEMForw, regENEMBoth, model.names = c("Backward", "Forward", "Both"))

#
check_model(regENEMBoth)
shapiro.test(residuals(regENEMBoth))
bptest(regENEMBoth)
check_heteroscedasticity(regENEMBoth)
check_collinearity(regENEMBoth)
check_outliers(regENEMBoth)

# importância
corrplot(cor(ENEM_ESCOLA))
varImp(regENEMBoth)

summary(regENEMBoth)

regENEMBoth2 <- step(lm(nota ~ INSE + INSE2 + TDI_EM + MHA_EM + ICG_N2 + ICG_N3 + ICG_N4, data = ENEM_ESCOLA), direction = "both")
test_performance(regENEMBoth, regENEMBoth2)
check_model(regENEMBoth2)

summary(regENEMBoth2)

regENEMBoth2 <- step(lm(nota ~ INSE + INSE2 + TDI_EM + ICG_N2 + ICG_N4, data = ENEM_ESCOLA), direction = "both")
test_performance(regENEMBoth, regENEMBoth2)
check_model(regENEMBoth2)

summary(regENEMBoth2)

# regressões teóricas
avPlots(regENEMBoth2, ask=FALSE, onepage=TRUE, id.method="identify")
influencePlot(regENEMBoth2, id.method="identify", main="Influence Plot", sub="Circle size is proportional to Cook’s distance")
residualPlots(regENEMBoth2)

ENEM_ESCOLA2 <- ENEM_ESCOLA %>% slice(-c(332, 424, 430, 460, 461))

regENEMBoth3 <- lm(nota ~ INSE + INSE2 + TDI_EM + ICG_N2 + ICG_N4, data = ENEM_ESCOLA2)
check_model(regENEMBoth3)

shapiro.test(residuals(regENEMBoth3))
bptest(regENEMBoth3)

# regressões teóricas
avPlots(regENEMBoth3, ask=FALSE, onepage=TRUE, id.method="identify")
influencePlot(regENEMBoth3, id.method="identify", main="Influence Plot", sub="Circle size is proportional to Cook’s distance")
