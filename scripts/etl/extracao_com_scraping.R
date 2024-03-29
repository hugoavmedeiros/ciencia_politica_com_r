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

# tabelas da globo.com
url <- "https://globoesporte.globo.com/futebol/futebol-internacional/futebol-espanhol/"

stock <- read_html("https://globoesporte.globo.com/futebol/futebol-internacional/futebol-espanhol/") %>% 
  html_nodes(xpath = "//*[@id='classificacao__wrapper']/section/ul/li[1]") %>% html_text()
