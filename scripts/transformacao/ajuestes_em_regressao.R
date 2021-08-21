## ajuste em regressão

ENEM_ESCOLA_2019 <- read.csv2('https://raw.githubusercontent.com/hugoavmedeiros/etl_com_r/master/bases_tratadas/ENEM_ESCOLA_2019.csv', stringsAsFactors = T) # carregando a base já tratada para o ambiente do R

ENEM_ESCOLA_2019$codCasos <- seq(1:nrow(ENEM_ESCOLA_2019))

# 
ENEM_ESCOLA_2019_FEDERAL <- ENEM_ESCOLA_2019 %>% filter(tipo == 'Federal')

p1 <-plot_ly(y = ENEM_ESCOLA_2019_FEDERAL$MED_CAT_0, type = "box", text = ENEM_ESCOLA_2019_FEDERAL$codCasos, boxpoints = "all", jitter = 0.3)

p2 <-plot_ly(y = ENEM_ESCOLA_2019_FEDERAL$MHA_03, type = "box", text = ENEM_ESCOLA_2019_FEDERAL$codCasos, boxpoints = "all", jitter = 0.3)

p3 <-plot_ly(y = ENEM_ESCOLA_2019_FEDERAL$media, type = "box", text = ENEM_ESCOLA_2019_FEDERAL$codCasos, boxpoints = "all", jitter = 0.3)

subplot(p1, p2, p3)

ENEM_ESCOLA_2019$MED_CAT_0[which(ENEM_ESCOLA_2019$codCasos == 407)] <- NA

ENEM_ESCOLA_2019$MED_CAT_0 <- impute(ENEM_ESCOLA_2019$MED_CAT_0, fun = mean)

# Pré-processamento
particaoENEM = createDataPartition(1:nrow(ENEM_ESCOLA_2019), p=.7) # cria a partição 70-30
treinoENEM = ENEM_ESCOLA_2019[particaoENEM$Resample1, ] # treino
testeENEM = ENEM_ESCOLA_2019[-particaoENEM$Resample1, ] # - treino = teste

ENEM_LM_v2 <- lm(media ~ tipo + MED_CAT_0 + MED_MHA, data = treinoENEM)

summary(ENEM_LM_v2)

#### OUTLIERS
outlierTest(ENEM_LM_v2) # identificar outliers na regressão

# identificar pontos de alavancagem
hat.plot <- function(fit) {
  p <- length(coefficients(fit))
  n <- length(fitted(fit))
  plot(hatvalues(fit), main="Pontos de Alavancagem")
  abline(h=c(2,3)*p/n, col="red", lty=2)
  identify(1:n, hatvalues(fit), names(hatvalues(fit)))
}
hat.plot(ENEM_LM_v2)

# identificar observações influentes
influencePlot(ENEM_LM_v2, id.method="identify", main="Observações Influentes")