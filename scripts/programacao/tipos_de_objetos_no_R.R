# tipos de objetos no R

# vetor
vetor1 <- c(1, 2, 3, 4, 5, 6) # vetor usando a função c (concatenar)

is.vector(vetor1) # testa se é vetor
typeof(vetor1) # tipo do objeto
class(vetor1) # classe do objeto
str(vetor1) # estrutura do objeto
length(vetor1) # tamanho objeto

# array
array1 <- array(c(c('João', 'Luis', 'Ana', 'Claudia'), 21:24), dim = c(2, 2, 2)) # cria array usando as funções array e c

is.array(array1) # teste se é array
typeof(array1) # tipo do objeto
class(array1) # classe do objeto
str(array1) # estrutura do objeto
length(array1) # tamanho objeto

# matriz
matrix1 <- matrix(vetor1, nrow = 2)

is.matrix(matrix1) # teste se é matriz
typeof(matrix1) # tipo do objeto
class(matrix1) # classe do objeto
str(matrix1) # estrutura do objeto
length(matrix1) # tamanho objeto

# lista
regCarros <- lm(mpg ~ ., mtcars) # criação de um modelo de regressão

is.list(regCarros) # teste se é lista
typeof(regCarros) # tipo do objeto
class(regCarros) # classe do objeto
str(regCarros) # estrutura do objeto
length(regCarros) # tamanho objeto

# data frame / quadro de dados
iris # data frame nativo do R

is.data.frame(iris) # teste se é lista
typeof(iris) # tipo do objeto
class(iris) # classe do objeto
str(iris) # estrutura do objeto
length(iris) # tamanho objeto

#### Vamos criar nosso próprio data.frame

#primeiro, vamos instalar um novo pacote: eeptools
install.packages('eeptools')

#depois, vamos chamar o pacote
library(eeptools)

# vetor com nome dos alunos
nomeAluno <- c("João", "José", "Luis", "Maria", "Ana", "Olga")

# vetor com datas de nascimento
nascimentoAluno <- as.Date(c("1990-10-23", "1992-03-21", "1993-07-20", "1989-07-20", "1994-01-25", "1985-12-15"))

# vetor com as idades
idadeAluno <- round( age_calc( nascimentoAluno, units = 'years')) # Idade usando a função age_calc do pacote eeptools e a função round (arredondar)

# data.frame com base nos vetores
listaAlunos <- data.frame(
  nome = nomeAluno,      # Nome 
  dataNascimento = nascimentoAluno, # Data de nascimento
  idade = idadeAluno # idade
) 

# matrix1 <- matrix(vetor1, nrow = 2)
