### outliers em regressões

# carrega as bibliotecas
pacman::p_load(car, caret, corrplot, dplyr, forcats, funModeling)

load("modelos/ENEM_LM.RData") # carrega modelo pronto

summary(ENEM_LM)

outlierTest(ENEM_LM) # identificar outliers na regressão

# identificar pontos de alavancagem
hat.plot <- function(fit) {
  p <- length(coefficients(fit))
  n <- length(fitted(fit))
  plot(hatvalues(fit), main="Pontos de Alavancagem")
  abline(h=c(2,3)*p/n, col="red", lty=2)
  identify(1:n, hatvalues(fit), names(hatvalues(fit)))
}
hat.plot(ENEM_LM)

# identificar observações influentes
influencePlot(ENEM_LM, id.method="identify", main="Observações Influentes")

# base para identificação de outlier
ENEM_ESCOLA_2019 <- read.csv2('https://raw.githubusercontent.com/hugoavmedeiros/etl_com_r/master/bases_tratadas/ENEM_ESCOLA_2019.csv', stringsAsFactors = T) # carregando a base já tratada para o ambiente do R

