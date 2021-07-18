# seta a semente aleatória de geração de dados
# usando a função addTaskCallback deixamos a set.seed fixa, rodando no back

tarefaSemente <- addTaskCallback(function(...) {set.seed(123);TRUE}) # atribui a tarefa à variável tarefaSemente
tarefaSemente # chama a tarefaSemente

# distribuição normal simulada
distNormalSimulacao <- rnorm(100) # usa a função rnorm para criar uma distribuição normal, indicando o total de casos

summary(distNormalSimulacao) # sumário da distNormalSimulacao

# distribuição binomial simulada
distBinominalSimulacao <- rbinom(100, 1, 0.7) # rbinom para criar distribuição binominal, indicando casos, tamanho e probabilidade

# repetições
classeSimulacao <- c(rep("Jovem", length(distBinominalSimulacao)/2), rep("Jovem Adulto", length(distBinominalSimulacao)/2)) # vetor repetindo a classe Jovem 15x e Jovem Adulto 15x

# sequências
indexSimulacao <- seq(1, length(distNormalSimulacao)) # vetor com índex dos dados, usando a função length para pegar o total de casos

# por fim, podemos usar a função removeTaskCallback para remover a tarefa que criamos lá em cima
removeTaskCallback(tarefaSemente)
