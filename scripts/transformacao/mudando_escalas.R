# mudando escalas
carsNovo <- cars # copiando a base de dados nativa para um novo objeto
carsNovo$distSqrt <- sqrt(carsNovo$dist) # criando variável com raiz quadrada
carsNovo$distNorm <- scale(carsNovo$dist) # criando variável normalizada
carsNovo$distScale <- (carsNovo$dist-min(carsNovo$dist))/(max(carsNovo$dist) - min(carsNovo$dist)) # criano variável padronizada
carsNovo$distLog <- log10(carsNovo$dist) # criano variável com log
plot_num(carsNovo)