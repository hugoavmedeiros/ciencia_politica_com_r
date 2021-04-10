# vetores
poissonSimulacao[1] # acessa o primeiro elemento
poissonSimulacao[c(1:10, 15)] # acessa os elementos 1, 2 até 10 e 15

# matrizes
matrix1[1, ] # linha 1
matrix1[ ,1] # coluna 1
matrix1[1,1] # linha 1, coluna 1

# data.frames
iris$Species # retorna apenas a coluna species do data.frame iris

iris[ , 5] # retorna todas as linhas apenas a coluna species do data.frame iris

iris[1:10, 2:5] # retorna as 10 primeiras linhas das colunas 2 a 5 do data.frame iris

iris[, 'Species'] # retorna a coluna espécies, indexada pelo nome

iris[, 'Species', drop = FALSE] # retorna a coluna espécies, indexada pelo nome, em formato de coluna

iris[ , -5] # retorna todas as colunas, menos a 5 - espécies

# listas
regCarros$coefficients
regCarros$coefficients[1]
regCarros[['coefficients']][1]
regCarros[[1]][1]

# usando operadores lógicos
a <- 5
b <- 7
c <- 5

a < b
a <= b
a > b
a >= b
a == b
a != b

a %in% c(b, c)
a == c & a < b
a != c | a > b
xor(a != c, a < b)
!a != c
any(a != c, a < c, a == c)
all(a != c, a < c, a == c)

# operadores lógicos na prática
iris$Sepal.Length <= 0 # testa se os valores na sepal.length são menores ou iguais a 0 

iris$Sepal.Length >= 0 & iris$Sepal.Width <= 0.2 # testa se, numa dada linha, os valores na sepal.length são menores ou iguais a 0 OU se os valores em sepal.width são iguais ou menores que 0.2

which(iris$Sepal.Length <= 5) # a função which mostra a posição (as linhas) em que a condição é atendida

match(iris$Species, 'setosa') # também é possível usar a função match para encontrar a correspondência entre dados ou objetos

