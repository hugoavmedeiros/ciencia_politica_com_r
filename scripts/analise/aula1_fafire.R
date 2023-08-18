install.packages('pacman')

pacman::p_load(
  # ETL
  data.table,
  dplyr, 
  # ANÁLISE
  corrplot,
  dataMaid
  )

enem_pe_2019 <- fread(
  'https://raw.githubusercontent.com/hugoavmedeiros/ciencia_politica_com_r/master/bases_tratadas/ENEM_ESCOLA_2019.csv', 
  stringsAsFactors = T,
  dec = ",")

enem_pe_2019 %>% str() 
enem_pe_2019 %>% names()

enem_pe_2019 %>% makeDataReport(
  output = "html", 
  replace = TRUE)
