<<<<<<< HEAD
# arquivos html
library(rvest)
library(dplyr)

# tabelas da wikipedia
url <- "https://pt.wikipedia.org/wiki/%C3%93scar"

urlTables <- url %>% read_html %>% html_nodes("table")

urlLinks <- url %>% read_html %>% html_nodes("link")

filmesPremiados <- as.data.frame(html_table(urlTables[5]))

# resultados do brasileirão

resultadosBrasileirao <- read_html("https://www.cbf.com.br")

resultadosBrasileirao <- resultadosBrasileirao %>% html_nodes(".swiper-slide")

rodada <- resultadosBrasileirao %>% html_nodes(".aside-header .text-center") %>% html_text()

resultados <- resultadosBrasileirao %>% html_nodes(".aside-content .clearfix")

mandante <- resultados %>% html_nodes(".pull-left .time-sigla") %>% html_text()

visitante <- resultados %>% html_nodes(".pull-right .time-sigla") %>% html_text()

tabelaBrasileirao <- data.frame(
  mandante = mandante,
  visitante = visitante,
  time = timestamp())

write.csv2(tabelaBrasileirao, 'tabelaBrasileirao.csv')
=======
# arquivos html
library(rvest)
library(dplyr)

# tabelas da wikipedia
url <- "https://pt.wikipedia.org/wiki/%C3%93scar"

urlTables <- url %>% read_html %>% html_nodes("table")

urlLinks <- url %>% read_html %>% html_nodes("link")

filmesPremiados <- as.data.frame(html_table(urlTables[5]))

# resultados do brasileirão

resultadosBrasileirao <- read_html("https://www.cbf.com.br")

resultadosBrasileirao <- resultadosBrasileirao %>% html_nodes(".swiper-slide")

rodada <- resultadosBrasileirao %>% html_nodes(".aside-header .text-center") %>% html_text()

resultados <- resultadosBrasileirao %>% html_nodes(".aside-content .clearfix")

mandante <- resultados %>% html_nodes(".pull-left .time-sigla") %>% html_text()

visitante <- resultados %>% html_nodes(".pull-right .time-sigla") %>% html_text()

tabelaBrasileirao <- data.frame(
  mandante = mandante,
  visitante = visitante)
>>>>>>> b450825b5546df3ba24f4db6b09d45e4294294a2
