#### PREPARAÇÃO ####
### PACOTES ###
pacman::p_load(
  # ETL
  data.table, dplyr, lubridate, tidyr,
  # ML
  arules, arulesCBA, arulesViz, caret, rattle
)

### ETL ###
instagram_unifafire <- fread('https://raw.githubusercontent.com/hugoavmedeiros/ciencia_politica_com_r/master/bases_tratadas/instagram_unifafire.csv')

str(instagram_unifafire)

# mudar o tipo de dado das colunas mes e turno para fator 
instagram_unifafire <- instagram_unifafire %>% 
  mutate_at( # mutate_at modifica colunas que já existem
    c('mes', 'turno'), 
    as.factor) # muda tipo do dado para fator

# mudar o tipo de dado da coluna "Data" para date
instagram_unifafire <- instagram_unifafire %>%
  mutate_at( # mutate_at modifica colunas que já existem
    c('Data'), 
    mdy) # muda o tipo de dado para Date, a partir do formato MM/DD/YY

# converter mes para 
instagram_unifafire$mes <- month(instagram_unifafire$Data, label = TRUE)

glimpse(instagram_unifafire)
