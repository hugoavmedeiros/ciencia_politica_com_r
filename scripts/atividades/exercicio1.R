# Crie um data frame com pelo menos 500 casos e a seguinte composição: duas variáveis normais de desvio padrão diferente, uma variável de contagem (poisson), uma variável de contagem com dispersão (binomial negativa), uma variável binomial (0,1), uma variável qualitativa que apresenta um valor quando a variável binomial é 0 e outro quando é 1, e uma variável de index. 

exercicio1 <- data.frame( # criando data.frame
  varNorm1 = rnorm(500, sd = 4), # var Normal desvio 4
  varNorm2 = rnorm(500, sd = 5), # var Normal desvio 5
  varCont1 = rpois(500, 3), # var Contagem poisson
  varCont2 = rnbinom(500, mu = 3, size = 10), # var Contagem Binomial Negativa
  varBin = rbinom(500, 1, 0.7), # var binomial binária com 70% chance de 1
  varIndex = seq(1:500)
)

exercicio1$varFactor = ifelse(exercicio1$varBin == 1, 'Azul', 'Vermelho') # codificação fatorial da variável binomial binária 

# 2. Centralize as variáveis normais. 

centralizacao <- function(x) {
  x - mean(x)
}

exercicio1[ , 1:2] <- sapply(exercicio1[ , 1:2], centralizacao)

# 3. Troque os zeros (0) por um (1) nas variáveis de contagem. 

mudaZero <- function(x) {
  x <- ifelse(x == 0, 1, x)
}

exercicio1[ , 3:4] <- sapply(exercicio1[ , 3:4], mudaZero)

# 4. Crie um novo data.frame com amostra (100 casos) da base de dados original. 

exercicio1Amostra <- exercicio1[sample(nrow(exercicio1), 100) , ]
