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