# funções
padroniza <- function(x) {
  x <- (x - min(x)) / (max(x) - min(x))
  return(x)
}

# ETL
mun_pe <- read.csv2('../../bases_tratadas/clusters_municipios_pe.csv')
mun_pe$rd <- as.factor(mun_pe$rd)
mun_pe$municipio <- as.factor(mun_pe$municipio)

# mun_pe <- read.csv2('bases_tratadas/clusters_municipios_pe.csv')