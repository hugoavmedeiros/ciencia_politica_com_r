pacman::p_load(dplyr, ggplot2, data.table, gridExtra)

# carregar dados covid19 Pernambuco
covid19PE <- fread('https://dados.seplag.pe.gov.br/apps/basegeral.csv')

# agrupar casos por município ajustando variáveis
covid19PEMun <- covid19PE %>% count(municipio, sort = T, name = 'casos') %>% mutate(casos2 = sqrt(casos), casosLog = log10(casos))

# criar loop para os diferentes gráficoss
nomeVar <- names(covid19PEMun)[2:4] # passar nomes das vars para vetor
listaPlots <- NULL

for(i in nomeVar) {
  plot <- covid19PEMun %>% ggplot(aes_string(x = 'municipio', y=i)) + geom_bar(stat = "identity") + labs(x = "Município")
  listaPlots[[length(listaPlots) + 1]] <- plot
} # criar lista com os plots

# printar todos os plots, lado a lado
grid.arrange(listaPlots[[1]], listaPlots[[2]], listaPlots[[3]], ncol=3)


