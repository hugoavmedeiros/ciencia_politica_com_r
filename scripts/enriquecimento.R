library(dplyr)
library(tidyverse)

baseCodMun <- read.table('bases_originais/base_codigos_mun.txt', sep = ',', header = T, encoding = 'UTF-8')

campusIES <- read.csv2('bases_originais/ies_georref.csv')

campusIES <- left_join(campusIES, baseCodMun, by = c('CO_MUNICIPIO' = 'id_munic_7'))
