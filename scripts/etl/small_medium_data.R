library(data.table)

enderecoBase <- 'bases_originais/largeData.csv'

# extração direta via read.csv
system.time(extracaoLD1 <- read.csv2(enderecoBase))

# extração via amostragem com read.csv

# ler apenas as primeiras 20 linhas
amostraLD1 <- read.csv2(enderecoBase, nrows=20)  

amostraLD1Classes <- sapply(amostraLD1, class) # encontra a classe da amostra amostra

# fazemos a leitura passando as classes de antemão, a partir da amostra
system.time(extracaoLD2 <- data.frame(read.csv2("bases_originais/largeData.csv", colClasses=amostraLD1Classes) ) )  

# extração via função fread, que já faz amostragem automaticamente
system.time(extracaoLD3 <- fread(enderecoBase))
