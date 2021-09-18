# funções
padroniza <- function(x) {
  x <- (x - min(x)) / (max(x) - min(x))
  return(x)
}

# ETL
mun_pe <- read.csv2('https://raw.githubusercontent.com/hugoavmedeiros/cd_com_r/master/bases_tratadas/clusters_municipios_pe.csv')
mun_pe$rd <- as.factor(mun_pe$rd)
mun_pe$municipio <- as.factor(mun_pe$municipio)

# mun_pe <- read.csv2('bases_tratadas/clusters_municipios_pe.csv')

mun_pe_meta <- read.csv2('https://raw.githubusercontent.com/hugoavmedeiros/cd_com_r/master/bases_tratadas/clusters_municipios_pe_meta.csv')

# mun_pe_meta <- read.csv2('bases_tratadas/clusters_municipios_pe_meta.csv')
