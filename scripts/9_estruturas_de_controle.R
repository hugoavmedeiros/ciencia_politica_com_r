#estrutura condicional

x <- runif(1, 0, 5)  
x

if(x > 3) {
  y <- 5
} else {
  y <- 0
}
y

# avaliação condicional simples
irisCopia$SpeciesDummy <- ifelse(irisCopia$Species == 'setosa', 1, 0)

# estrutura de repetição
par(mfrow = c(2, 2)) # prepara a tela de gráficos como uma matriz 2x2 para receber os 4 gráficos gerados abaixo

for (i in 1:4) { # cria o loop, que deve ir de 1 a 4
  x <- iris[ , i] # atribui as colunas da base de dados a uma variável temporária
  hist(x,
       main = paste("Variável", i, names(iris)[i]), # atribui o nome ao gráfico de forma incremental, passando coluna por coluna
       xlab = "Valores da Variável", # rótulo do eixo x
       xlim = c(0, 10)) # limite mínimo e máximo do eixo x
}

lapply(iris[, 1:4], hist)
