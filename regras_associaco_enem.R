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

enem <- fread(
  'https://raw.githubusercontent.com/hugoavmedeiros/ciencia_politica_com_r/master/bases_tratadas/ENEM_REGRAS.csv', 
  encoding = 'Latin-1', 
  stringsAsFactors = T) %>%
  clean_names()

enem <- enem %>%
  filter(
    v2 != 'tipo'
  ) %>%
  select(
    -c(
      v1
    )
  )

names(enem) <- c(
  'tipo', 'localizacao', 'ICG', 'INSE', 'TDI_EM', 'MHA_EM', 'REP_EM' 
)

regras_enem <- enem %>% 
  apriori(
    parameter = list(
      supp = 0.2, 
      conf = 0.5, 
      minlen = 2, 
      maxlen = 5))

quality(regras_enem) <- round(quality(regras_enem), digits = 3)

regras_enem <- sort(
  regras_enem, 
  by="lift") 

regras_enem_res <- regras_enem[!is.redundant(regras_enem, measure="lift")]

inspect(regras_enem_res)

regras_enem_df = data.frame(
  lhs = labels(lhs(regras_enem_res)),
  rhs = labels(rhs(regras_enem_res)), 
  regras_enem_res@quality)

regras_enem_df %>% 
  write.csv2('regras_enem.csv')

reactable(
  regras_enem_df, 
  defaultColDef = colDef(cell = data_bars(
    regras_enem_df,
    text_position = 'outside-base')),
  pagination = F
)
