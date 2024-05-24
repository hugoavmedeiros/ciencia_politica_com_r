##### Regras de Associação 
pacman::p_load(
  # ETL
  data.table, dplyr, janitor,
  # MACHINE LEARNING
  caret,
  # REGRAS DE ASSOCIAÇÃO
  arules, arulesCBA, arulesViz,
  # TABELAS
  reactablefmtr
)

##### ETL #####
candidatos_pe_2022 <- fread('https://raw.githubusercontent.com/hugoavmedeiros/ciencia_politica_com_r/master/bases_originais/consulta_cand_2022_PE.csv', encoding = 'Latin-1', stringsAsFactors = T) %>%
  janitor::clean_names()

# filtrar apenas deputados estaduais e variáveis de perfil
estaduais_pe_2022 <- candidatos_pe_2022 %>% 
  filter(ds_cargo == 'DEPUTADO ESTADUAL') %>% 
  select(tp_agremiacao, nm_municipio_nascimento, nr_idade_data_posse, ds_genero, ds_grau_instrucao, ds_estado_civil, ds_cor_raca, ds_ocupacao)

# observar se os dados estão com as classes certas
estaduais_pe_2022 %>% glimpse()

# discretizar variável numérica
estaduais_pe_2022[ , 3] <- discretizeDF(estaduais_pe_2022[ , 3]) # transforma variáveis numéricas em fatores

##### MINERAÇÃO #####
# mineração com a priori
regras_estaduais <- estaduais_pe_2022 %>% 
  apriori(parameter = list(supp = 0.2, conf = 0.5, minlen = 2, maxlen = 5))

## limpar e organizar regras
# três casas decimais
quality(regras_estaduais) <- round(quality(regras_estaduais), digits = 3)

# organizar por lift
regras_estaduais <- sort(regras_estaduais, by="lift") 
# remover regras redundantes
regras_estaduais_res <- regras_estaduais[!is.redundant(regras_estaduais, measure="lift")]

# inspecionar regras
inspect(regras_estaduais_res)

regras_estaduais_df = data.frame(
  lhs = labels(lhs(regras_estaduais_res)),
  rhs = labels(rhs(regras_estaduais_res)), 
  regras_estaduais_res@quality)

reactable(
  regras_estaduais_df, 
  defaultColDef = colDef(cell = data_bars(regras_estaduais_df ,text_position = 'outside-base')),
  pagination = F
  )

# gráfico de coordenadas
plot(regras_estaduais_res, method="paracoord", control=list(reorder=T), measure=c("lift"), lty = "dotted")

# gráfico de relações agrupadas
plot(regras_estaduais_res, method="grouped", measure=c("lift"))
