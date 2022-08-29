#### CARREGANDO PACOTES ####
pacman::p_load(dplyr, tidyverse)

#### LENDO AS BASES PARA O R ####
# opção para quem baixou a base
baseCodMun <- read.table('bases_originais/base_codigos_mun.txt', sep = ',', header = T, encoding = 'UTF-8')

campusIES <- read.csv2('bases_originais/ies_georref.csv')

# opção para pegar as bases diretamente do github
baseCodMun <- read.table('https://raw.githubusercontent.com/hugoavmedeiros/cp_com_r/master/bases_originais/base_codigos_mun.txt', sep = ',', header = T, encoding = 'UTF-8')

campusIES <- read.csv2('https://raw.githubusercontent.com/hugoavmedeiros/cp_com_r/master/bases_originais/ies_georref.csv')

campusIES <- left_join(campusIES, baseCodMun, by = c('CO_MUNICIPIO' = 'id_munic_7'))
