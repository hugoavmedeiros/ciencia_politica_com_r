# o R como calculadora

binomialnegSimulacao <- rnbinom(300, mu = 3, size = 10)

poissonSimulacao <- rpois(300, 3)

hist(binomialnegSimulacao)
hist(poissonSimulacao)

binomialnegSimulacao + poissonSimulacao # soma as distribuições

poissonSimulacao + 100 # soma 100 a cada elemento

poissonSimulacao^2 # eleva ao quadrado

poissonSimulacao * binomialnegSimulacao # multiplica

round(distNormalSimulacao, 0) # arredonda o vetor para inteiros

ceiling(distNormalSimulacao) # arredonda para cima

floor(distNormalSimulacao) # arredonda para baixo

distNormalSimulacao %% poissonSimulacao # módulo dos vetores

# também podemos usar funções estatísticas no R

# média
mean(poissonSimulacao)
mean(binomialnegSimulacao)

# mediana
median(poissonSimulacao)
median(binomialnegSimulacao)

# desvio padrão
sd(poissonSimulacao)
sd(binomialnegSimulacao)

# variância
var(poissonSimulacao)
var(binomialnegSimulacao)

# uma aplicação prática?? vamos centralizar a nossa simulação poisson
poissonSimulacaoCentral <- poissonSimulacao - mean(poissonSimulacao)
hist(poissonSimulacao)
hist(poissonSimulacaoCentral)
