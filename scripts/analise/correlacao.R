## CORRELAÇÃO COM R ##
# PRIMEIRO, VAMOS CARREGAR OS PACOTES
pacman::p_load(corrplot, dplyr, ggplot2)

# BASE DE DADOS IRIS SEM AS ESPÉCIES #
iris2 <- iris %>% select(Species)

# TABELA DE CORRELAÇÃO COM TODAS AS VARIÁVEIS #
cor(iris2)

# GRÁFICOS DE DISPERSÃO PAREADOS DAS VARIÁVEIS #
pairs(iris2)

# CORRPLOT DAS VARIÁVEIS #
irisCor <- cor(iris2) # Tabela de correlações
corrplot(irisCor, method = "number", order = 'alphabet')
corrplot(irisCor, order = 'alphabet') 
corrplot(irisCor, method = "square", order = 'AOE')
