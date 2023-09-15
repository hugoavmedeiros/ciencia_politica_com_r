pacman::p_load(ff)

enderecoBase <- 'bases_originais/largeData.csv'

# criando o arquivo ff
system.time(extracaoLD4 <- read.csv.ffdf(file=enderecoBase))

class(extracaoLD4) # veja a classe do objeto
 
object.size(extracaoLD3) # a vantagem está no tamanho!

object.size(extracaoLD4) # a vantagem está no tamanho!

sum(extracaoLD4[,3]) # algumas operações são possíveis diretamente

lm(c ~ ., extracaoLD4) ## não vai rodar!!!! o vetor de computação será mt grande

# pra outras, será preciso amostrar...
extracaoLD4Amostra <- extracaoLD4[sample(nrow(extracaoLD4), 100000) , ]

lm(c ~ ., extracaoLD4Amostra) # aí, funciona!!!

system.time(extracaoLD5 <- read.csv.ffdf(file='bases_originais/Phones_accelerometer.csv'))

length(extracaoLD5$Model)

system.time(extracaoLD6 <- read.csv.ffdf(file='bases_originais/Phones_gyroscope.csv'))

length(extracaoLD6$Model)

extracaoMerge <- ffdfappend(extracaoLD5, extracaoLD6) # junta bases semelhantes

#extracaoMerge <- ffdfrbind.fill(extracaoLD5, extracaoLD6) # junta bases semelhantes forçando preenchimento

length(extracaoMerge$Model)
