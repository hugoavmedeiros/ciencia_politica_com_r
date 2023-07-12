# distribuição normal simulada
distNormalSimulacao <- rnorm(1000, mean = 3, sd = 1) # usa a função rnorm para criar uma distribuição normal, indicando o total de casos

# amostragem sem reposição usando função sample
sample(distNormalSimulacao, 15, replace = FALSE) # se você não tiver o objeto distNormalSimulacao no seu ambiente, crie com o script anterior

# amostragem com reposição usando função sample
sample(distNormalSimulacao, 15, replace = TRUE)

# bootstraping com função replicate
set.seed(412) # agora, não vamos mais usar como tarefa mas como execução ponto a ponto

bootsDistNormal10 <- replicate(10, sample(distNormalSimulacao, 10, replace = TRUE)) # replicamos 10x a amostra, criando assim um bootstrapping
bootsDistNormal10

# calculando uma estatística com bootstrapping (10 amostras)
mediaBootsNormal10 <- replicate(10, mean(sample(distNormalSimulacao, 10, replace = TRUE))) # calculamos a média de 10 amostras de 10 casos
mediaBootsNormal50 <- replicate(50, mean(sample(distNormalSimulacao, 10, replace = TRUE))) # calculamos a média de 50 amostras de 10 casos
mediaBootsNormal100 <- replicate(100, mean(sample(distNormalSimulacao, 10, replace = TRUE))) # calculamos a média de 100 amostras de 10 casos

# vamos comparar???
mean(mediaBootsNormal10) # media do boostraping 10
mean(mediaBootsNormal50) # media do boostraping 50
mean(mediaBootsNormal100) # media do boostraping 100
mean(distNormalSimulacao) # media dos dados originais

# vamos comparar???
par(mfrow=c(2,2), ask = FALSE)
hist(mediaBootsNormal10, main = 'Bootstrap 10 Repetições', xlab = 'Média 10 Repetições') # media do boostraping 10
hist(mediaBootsNormal50, col='blue', main = 'Bootstrap 50 Repetições', xlab = 'Média 50 Repetições') # media do boostraping 50
hist(mediaBootsNormal100, col='red', main = 'Bootstrap 100 Repetições', xlab = 'Média 100 Repetições') # media do boostraping 100
hist(distNormalSimulacao, col='black', main = 'Dados Originais', xlab = 'Média Original') # media dos dados originais

# partições
install.packages('caret', dependencies = T) # caret é um pacote geral de machine learning # se já tiver não, innstale =D
library(caret)

# primeiro, criamos as partições de dados
particaoDistNormal <- createDataPartition(1:length(distNormalSimulacao), p=.7) # passamos o tamanho do vetor e o parâmetro de divisão
treinoDistNormal <- distNormalSimulacao[unlist(particaoDistNormal)] # criamos uma partição para treinar os dados, usando a partição anterior. Atenção: o comando unlist é muito usado para transformar uma lista num vetor
testeDistNormal <- distNormalSimulacao[- unlist(particaoDistNormal)] # criamos uma partição para testar os dados, usando a partição anterior. Atenção: o comando unlist é muito usado para transformar uma lista num vetor
