### CARREGANDO PACOTES ###
pacman::p_load(car, gvlma, lm.beta, lmtest, sandwich)

### REGRESSÃO FERTILIDADE - BASE SWISS
regSwiss <- lm(Fertility ~ ., data = swiss) # ESTIMANDO A REGRESSÃO
summary(regSwiss) # SUMÁRIO DA REGRESSÃO
lm.beta(regSwiss) # COEFICIENTES PADRONIZADOS

# Stepwise #
regSwissBack <- step(lm(Fertility ~ ., data = swiss), direction = 'backward') # de trás pra frente
summary(regSwissBack)
regSwissForw <- step(lm(Fertility ~ ., data = swiss), direction = 'forward') # do início pro fim
summary(regSwissForw)
regSwissBoth <- step(lm(Fertility ~ ., data = swiss), direction = 'both') # nos dois sentidos
summary(regSwissBoth)

### VERIFICAÇÃO DOS PRESSUPOSTOS ###
# normalidade dos resíduos
shapiro.test(residuals(exemplo_swiss))
plot(regSwiss, which=1, col=c("blue")) # resíduos x ajuste
plot(regSwiss, which=2, col=c("red")) # Q-Q Plot
plot(regSwiss, which=5, col=c("blue"))  # Observações Influentes

#= Correção seria retirar as observações influentes =#

# inflação da variância
vif(regSwiss)
barplot(vif(regSwiss), main = "VIF Values", horiz = TRUE, xlim = c(0,10), col = "steelblue")
abline(v = 5, lwd = 3, lty = 2)

#= Correção seria usar apenas uma das variáveis correlacionadas =#

# homocedasticidade (H0 = homocedasticidade)
bptest(regSwiss) # teste de homocedasticidade
plot(regSwiss, which=3, col=c("blue"))  # Scale-Location Plot

#= Correção seria usar estimativas robustas =#
regSwiss$robse <- vcovHC(regSwiss, type = "HC1")
coeftest(regSwiss, regSwiss$robse)

