##### Regras de Associação 
pacman::p_load(
  # ETL
  dplyr,
  # MACHINE LEARNING
  caret,
  # REGRAS DE ASSOCIAÇÃO
  arules, arulesCBA, arulesViz
)

##### ETL #####

candidatos_pe_2022 <- fread('bases_originais/consulta_cand_2022_PE.csv', encoding = 'Latin-1', stringsAsFactors = T)

# filtrar apenas deputados e variáveis de perfil
estaduais_pe_2022 <- candidatos_pe_2022 %>% filter(DS_CARGO == 'DEPUTADO ESTADUAL') %>% select(TP_AGREMIACAO, NM_MUNICIPIO_NASCIMENTO, NR_IDADE_DATA_POSSE, DS_GENERO, DS_GRAU_INSTRUCAO, DS_ESTADO_CIVIL, DS_COR_RACA, DS_OCUPACAO)

# observar se os dados estão com as classes certas
glimpse(estaduais_pe_2022)

# modificar nomes para facilitar análise e plot
names(estaduais_pe_2022) <- c(
  'agremiacao', 'municipio', 'idade', 'genero', 'instrucao', 'estado_civil', 'raca', 'ocupacao'
)

# discretizar variável numérica
estaduais_pe_2022[ , 3] <- discretizeDF(estaduais_pe_2022[ , 3]) # transforma variáveis numéricas em fatores

##### MINERAÇÃO #####
# mineração com a priori
regras_estaduais <- apriori(
  estaduais_pe_2022, 
  parameter = list(supp = 0.2, conf = 0.5, minlen = 2, maxlen = 5))

## limpar e organizar regras regras
# três casas decimais
quality(regras_estaduais)<-round(quality(regras_estaduais),digits = 3) 
# organizar por lift
rules<-sort(regras_estaduais,by="lift") 
# remover regras redundantes
regras_estaduais_res <- regras_estaduais[!is.redundant(regras_estaduais, measure="lift")]

# inspecionar regras
inspect(regras_estaduais_res)

# gráfico de coordenadas
plot(regras_estaduais_res, method="paracoord",control=list(reorder=T), measure=c("lift"), lty = "dotted")

# gráfico de relações agrupadas
plot(regras_estaduais_res, method="grouped", measure=c("lift"))

### APENAS BRANCOS ###

regras_brancos<-apriori(estaduais_pe_2022, control=list(verbose=F), parameter = list(minlen=2,supp=0.1,conf=0.3), appearance = list(lhs="raca=BRANCA",default="rhs"))

quality(regras_brancos)<-round(quality(regras_brancos),digits = 3)
regras_brancos<-sort(regras_brancos,by="lift")

inspect(regras_brancos)

plot(regras_brancos,method="paracoord",control=list(reorder=T),measure=c("lift"),lty = "dotted")
