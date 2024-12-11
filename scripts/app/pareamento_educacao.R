#### pacotes ----
pacman::p_load(cobalt, MatchIt, rbounds, sensemakr, tidyverse)

#### etl ----
PPE_PAR  <- read.csv2(
  'bases_tratadas/base par ep.csv', 
  sep = ";", 
  dec = ",",
  encoding = 'UTF-8')

# pareamento por proximidade
PPE_PAR_EPN <- matchit(dtSINT ~ TDI + ABA, data = PPE_PAR, method = "nearest") # melhor par possível sem repetição # otimização local # proximidade
# pareamento por exatidão
PPE_PAR_EPE <- matchit(dtSINT ~ TDI + ABA, data = PPE_PAR, method = "exact") # melhor par de valor exato 
# pareamento por otimizaçãoo global
PPE_PAR_EPO <- matchit(dtSINT ~ TDI + ABA, data = PPE_PAR, method = "optimal", ratio = 2) # melhor par sem repetição # otimização global
# pareamento por inteligência artificial (algoritmos genéticos)
PPE_PAR_EPG <- matchit(dtSINT ~ TDI + ABA, data = PPE_PAR, method = "genetic", distance = "logit") # melhor par possível, sem regras a priori

# matriz de pareados e total de pareados
PPE_PAR_EPN$match.matrix
PPE_PAR_EPE$match.matrix
PPE_PAR_EPO$match.matrix
PPE_PAR_EPG$match.matrix

PPE_PAR_EPN$nn
PPE_PAR_EPE$nn
PPE_PAR_EPO$nn
PPE_PAR_EPG$nn

# sumário e gráfico de avaliação do pareamento
summary(PPE_PAR_EPN)$sum.matched
summary(PPE_PAR_EPO)$sum.matched
summary(PPE_PAR_EPG)$sum.matched
plot(PPE_PAR_EPN, main = "Pareamento por Proximidade")
plot(PPE_PAR_EPO, main = "Pareamento por Otimização")
plot(PPE_PAR_EPG, main = "Pareamento por Algortimo Genético")

plot(PPE_PAR_EPN, type = "histogram", interactive = FALSE)

# data-frame apenas com os dados pareados
PPE_PAR_EP <- matchit(dtSINT ~ TDI + ABA, data = PPE_PAR, method = "nearest")
PPE_2014_EP <- match.data(PPE_PAR_EP)
PPE_2014_EP_G <- match.data(PPE_PAR_EPG)

View(PPE_2014_EP)

# regressão com os dados pareados
PPE_2014_EP_REG1 <- lm(IDEPE ~ TDI + dtSINT + Res_Rural, data = PPE_2014_EP)
PPE_2014_EP_REG1_G <- lm(IDEPE ~ TDI + dtSINT + Res_Rural, data = PPE_2014_EP_G)
PPE_2014_EP_REG1_G

# sumário e avaliação do modelo
summary(gvlma(PPE_2014_EP_REG1))

# acrescentando os res?duos ao frame original
PPE_2014_EP$res <- PPE_2014_EP_REG1$residuals

# retirando os outliers
PPE_2014_EP_OUT <- subset(PPE_2014_EP, PPE_2014_EP$res > out.inf(PPE_2014_EP$res) 
                        & PPE_2014_EP$res < out.sup(PPE_2014_EP$res))

# nova regressão 
PPE_2014_EP_REG2 <- lm(IDEPE ~ TDI + dtSINT + Res_Rural, data = PPE_2014_EP_OUT)

# sumário e avaliação do novo modelo
summary(gvlma(PPE_2014_EP_REG2))

#### final ----
# Pareamento com nearest (local)
PPE_PAR_EPN <- matchit(dtSINT ~ TDI + ABA, data = PPE_PAR, method = "nearest")

# Avaliar balanceamento antes e depois do pareamento
dev.off()
love.plot(PPE_PAR_EPN, threshold = 0.1)

# Plotar histograma para verificar sobreposição de escores de propensão
plot(PPE_PAR_EPN, type = "histogram")

# Gerar dados pareados
PPE_2014_EP <- match.data(PPE_PAR_EPN)

# Modelo de impacto do tratamento após pareamento
modelo <- lm(IDEPE ~ TDI + dtSINT + Res_Rural, data = PPE_2014_EP)
summary(modelo)

# Carregar pacotes necessários
library(MatchIt)
library(rbounds)

# Dados pareados
matched_data <- match.data(PPE_PAR_EPN) # Extraindo dados pareados

# Definir os vetores de resultados observados
x <- matched_data[matched_data$dtSINT == 1, "IDEPE"]  # Resultado no grupo tratado
y <- matched_data[matched_data$dtSINT == 0, "IDEPE"]  # Resultado no grupo controle

# Análise de Sensibilidade
psens_result <- psens(x = x, y = y, Gamma = 1.5)

# Exibir resultados
print(psens_result)

#### sensibilidade 2 ----
sensitivity <- sensemakr(
  model = modelo,
  treatment = "dtSINT",
  benchmark_covariates = "TDI",
  alpha = 0.05
)

# Resumo dos resultados
summary(sensitivity)

# Visualizar o impacto de variáveis omitidas
plot(sensitivity)
