# funções de repetição - família apply

# média de cada variável do data frame iris
apply(iris[ ,-5], 2, mean) # iris[,-5] retira a última coluna, que não é numérica. no segundo parâmetro, o 2 indica que queremos a média das colunas. 
lapply(iris[, -5], mean) # sintaxe mais simples, pois não precisa especificar se é coluna ou linha
sapply(iris[, -5], mean) # mesma sintaxe, sendo a principal diferença que a sapply sempre tenta simplificar o resultado

par(mfrow = c(2, 2)) # prepara a área de plotagem para receber 4 plots

sapply(iris[ , 1:4], hist)
mapply(hist, iris[ , 1:4], MoreArgs=list(main='Histograma', xlab = 'Valores', ylab = 'Frequência')) # mapply tem a vantagem de aceitar argumentos da função original

for (i in 1:4) { # cria o loop, que deve ir de 1 a 4
  x <- iris[ , i] # atribui as colunas da base de dados a uma variável temporária
  hist(x,
       main = names(iris)[i], # atribui o nome ao gráfico de forma incremental, passando coluna por coluna
       xlab = "Valores da Variável", # rótulo eixo x
       ylab = 'Frequência', # rótulo eixo y
       xlim = c(min(iris[, i]), max(iris[, i]))) # limites do eixo x
}
