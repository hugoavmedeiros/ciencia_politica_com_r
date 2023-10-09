##### ARMAZENAMENTO EM DISCO #####
#### FF ####
pacman::p_load(biglm, devtools, dplyr, ff, ffbase)

enderecoBase <- 'bases_originais/large data/largeData.csv'

# criando o arquivo ff
tempo_ff <- system.time(base_ff <- read.csv.ffdf(file=enderecoBase))

tempo_ff

base_ff %>% head()

base_ff %>% typeof() # veja a classe do objeto

base_ff %>% class() # veja a classe do objeto
 
base_ff %>% object.size() # a vantagem está no tamanho!

sum(base_ff[,3]) # algumas operações são possíveis diretamente

# REGRESSÂO #

lm(c ~ ., base_ff) ## não vai rodar!!!! o vetor de computação será mt grande

# mas pode ser feita com amostragem
base_ffAmostra <- base_ff[sample(nrow(base_ff), 100000) , ]

lm(c ~ ., base_ffAmostra) # aí, funciona!!!

# ou com funções otimizadas
modelo <- biglm(a ~ b + c,  data = base_ff)

summary(modelo)