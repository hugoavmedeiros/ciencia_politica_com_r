
vetorC[1] # acessa o primeiro elemento do vetor

vetorC[c(1, 2:10, 15)] # acessa os elementos 1, 2 até 10 e 15


iris$Species # retorna apenas a coluna species do data.frame iris

iris[, 5] # retorna todas as linhas apenas a coluna species do data.frame iris

iris[1:10, 2:5] # retorna as 10 primeiras linhas das colunas 2 a 5 do data.frame iris

iris[, 'Species'] # retorna a coluna espécies, indexada pelo nome

iris[, 'Species', drop = FALSE] # retorna a coluna espécies, indexada pelo nome, em formato de coluna

iris[, -5] # retorna todas as colunas, menos a 5 - espécies