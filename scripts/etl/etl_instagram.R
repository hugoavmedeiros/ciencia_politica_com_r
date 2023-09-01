pacman::p_load(dplyr, lubridate, readxl)

instagram_unifafire <- read_xlsx(
  'bases_originais/instagram_unifafire_original.xlsx'
)

instagram_unifafire$Data <- mdy(instagram_unifafire$Data)
instagram_unifafire$Tempo <- paste(instagram_unifafire$Data, instagram_unifafire$`Hora Min`)
instagram_unifafire$Tempo <- as.POSIXlt(instagram_unifafire$Tempo)
instagram_unifafire$Hora <- format(instagram_unifafire$Tempo, "%H")
instagram_unifafire$Hora <- as.integer(instagram_unifafire$Hora)

instagram_unifafire$mes <- month(
  instagram_unifafire$Data,
  label = TRUE,
  abbr = TRUE)

instagram_unifafire <- instagram_unifafire %>% mutate(
  turno = case_when(
    Hora >= 18 ~ 'Noite',
    Hora >= 12 ~ 'Tarde',
    Hora >= 6 ~ 'Manhã',
    Hora >= 0 ~ 'Madrugada'
  ))

# SALVAR #

instagram_unifafire %>% select(-Tempo) %>% data.table::fwrite("bases_tratadas/instagram_unifafire.csv", sep = ";")

saveRDS(
  instagram_unifafire, 
  file = "bases_tratadas/instagram_unifafire.RDS")