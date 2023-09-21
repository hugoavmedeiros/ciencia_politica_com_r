# função
hello_word <- function() {
  cat("Hello, world!\n")
  }
hello_word()

hello_word |> formals()
hello_word |> body()
hello_word |> environment()

# agora, uma função mais útil...
centralizacao <- function(x) {
  x <- x - mean(x)
  return(x)
}

iris$Sepal.Length |> centralizacao()

centralizacao <- function(x) {
  x <- x - mean(x)
}

iris$Sepal.Length |> centralizacao()

centroTeste <- iris$Sepal.Length |> centralizacao()
centroTeste

### CARREGAR PACOTES
pacman::p_load(lsa)

### CRIAR FUNÇÃO PARA RODAR VÁRIAS ASSOCIAÇÕES
multi.ass <- function(x, y) {
  corr = cor(x, y) # Correlação
  cos = cosine(x, y) # Distância do Cosseno 
  Associações = as.data.frame(list(corr, cos))
  names(Associações) = c('Correlação', 'Cosseno')
  return(Associações)
}

multi.ass |> formals()
multi.ass |> body()
multi.ass |> environment()

multi.ass(cars$speed, cars$dist)
