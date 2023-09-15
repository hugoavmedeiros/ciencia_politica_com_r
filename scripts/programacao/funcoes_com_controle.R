# função com estrutura de repetição
hello_word_rep <- function(nro) {
  for(i in 1:nro) {
    cat("Hello, world!\n")
  }
}
hello_word_rep(3)

formals(hello_word_rep)
body(hello_word_rep)
environment(hello_word_rep)

# função com estrutura condicional e de repetição
f <- function(nro) {
  if(nro < 10) {
    for(i in 1:nro) {
      cat("Hello, world!\n")
    }
  } else {
    cat("Tá de brincadeira imprimir isso tudo")
  }
}
f(9)
f(10)