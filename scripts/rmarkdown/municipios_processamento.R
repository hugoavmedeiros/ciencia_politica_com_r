# pacotes
pacman::p_load(data.table, dplyr)

# funções
padroniza <- function(x) {
  x <- (x - min(x)) / (max(x) - min(x))
  return(x)
}

# ETL
mun_pe <- fread('https://raw.githubusercontent.com/hugoavmedeiros/cp_com_r/master/bases_tratadas/clusters_municipios_pe.csv', encoding = 'Latin-1', dec = ',')

mun_pe <- mun_pe %>% mutate(across(c(rd, municipio), factor))
mun_pe <- mun_pe %>% mutate(across(c(pib, vab), as.numeric))

# mun_pe <- read.csv2('bases_tratadas/clusters_municipios_pe.csv')

mun_pe_meta <- fread('https://raw.githubusercontent.com/hugoavmedeiros/cp_com_r/master/bases_tratadas/clusters_municipios_pe_meta.csv', encoding = 'Latin-1')

# mun_pe_meta <- read.csv2('bases_tratadas/clusters_municipios_pe_meta.csv')
