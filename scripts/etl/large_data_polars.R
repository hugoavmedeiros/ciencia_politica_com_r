##### ARMAZENAMENTO EM DISCO + COLUNARS #####
#### POLARS ####
#### BASE FICTÍCIA ####
# install.packages("polars", repos = "https://rpolars.r-universe.dev")
pacman::p_load(arrow, dplyr, polars) 

enderecoBase <- 'bases_originais/large data/largeData.csv'

tempo_arrow <- (system.time(base_arrow <- read_csv_arrow(file=enderecoBase)))

base_polars = pl$DataFrame(base_arrow)

base_polars %>% head()

base_polars %>% typeof()

base_polars %>% class()

base_polars %>% object.size() 

base_polars_mod <- lm(a ~ b + c + d + e + f + g, base_polars)

summary(base_polars_mod)

#### BASE REAL  ####
EdStatsData <- read_csv_arrow('bases_originais/large data/EdStatsData.csv')

EdStatsData_p = pl$DataFrame(EdStatsData)

EdStatsData_p %>% head()

EdStatsData_p %>% typeof()

EdStatsData_p %>% class()

EdStatsData_p %>% object.size()

EdStatsData_p %>% names()

# Sumário
EdStatsData_p$describe()
