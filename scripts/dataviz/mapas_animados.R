pacman::p_load(dplyr, leaflet, leaflet.extras, leaflet.minicharts, rgdal, tidyr)

escolas_integral <- read.csv2('../../bases_tratadas/escolas_tempo_integral_v2.csv')

escolas_integral$nome_escola <- as.factor(escolas_integral$nome_escola)

escolas_integral_agg <- escolas_integral %>% group_by(nome_escola, ano_implantacao, .drop=FALSE) %>% summarise(n = n()) %>% na.omit() %>% complete(ano_implantacao, nome_escola, fill = list(n = 0)) %>% filter(nome_escola != '') %>% distinct()

escolas_integral_agg <- merge(escolas_integral_agg, escolas_integral, by = 'nome_escola') %>% select(!ano_implantacao.y) %>% distinct()

leaflet(escolas_integral_agg) %>% addTiles() %>%
  addMinicharts(
    escolas_integral_agg$lon, escolas_integral_agg$lat,
    chartdata = escolas_integral_agg$n,
    time = escolas_integral_agg$ano_implantacao.x,
    showLabels = F,
    width = 15, height = 15
  ) %>%
  addFullscreenControl()