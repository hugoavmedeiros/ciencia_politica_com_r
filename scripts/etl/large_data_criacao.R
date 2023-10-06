# install.packages('data.table')
pacman::p_load(data.table)

casos= 2e7 # reduza os números antes e depois do e, caso esteja difícil de computar # mas tente manter pelo menos 1e6, para garantir o efeito se large data

# cria o data.frame com o total de casos definido acima
largeData = data.table(
  a = rpois(casos, 3), 
  b = rbinom(casos, 1, 0.7), 
  c = rnorm (casos), 
  d = sample(c("fogo","agua","terra","ar"), casos, replace=TRUE), 
  e = rnorm(casos), 
  f = rpois(casos, 3), 
  g = rnorm(casos))

object.size(largeData) # retorna o tamanho do objeto

head(largeData) # vê as primeiras linhas

write.table(largeData,"bases_originais/largeData.csv",sep=",",row.names=FALSE,quote=FALSE) # salva em disco

### base correlacionada ###
# cria o data.frame com o total de casos definido acima
a = rpois(casos, 3)
e = rnorm(casos)

largeData2 = data.table(
  a = a, 
  b = 10 + 0.5*a,
  c = sqrt(a),
  d = sample(c("fogo","agua","terra","ar"), casos, replace=TRUE), 
  e = e, 
  f = a - e, 
  g = e^2 +2*a)

object.size(largeData2) # retorna o tamanho do objeto

head(largeData2) # vê as primeiras linhas

write_parquet(largeData2,"bases_originais/largeData2.parquet") # salva em disco

# versão menor

casos= 9e6 # reduza os números antes e depois do e, caso esteja difícil de computar # mas tente manter pelo menos 1e6, para garantir o efeito se large data

# cria o data.frame com o total de casos definido acima
largeData1 = data.table(a=rpois(casos, 3),
                       b=rbinom(casos, 1, 0.7),
                       c=rnorm(casos),
                       d=sample(c("fogo","agua","terra","ar"), casos, replace=TRUE),
                       e=rnorm(casos),
                       f=rpois(casos, 3)
)

object.size(largeData1) # retorna o tamanho do objeto

head(largeData1) # vê as primeiras linhas

write.table(largeData1,"bases_originais/largeData1.csv",sep=",",row.names=FALSE,quote=FALSE) # salva em disco
